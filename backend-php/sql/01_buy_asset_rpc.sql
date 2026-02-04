-- Function to handle asset purchase (Pokemon or Infrastructure)
-- Calculates cost, checks balance, updates inventory and logs transaction.

create or replace function buy_asset(
  p_asset_type text,
  p_asset_id bigint
) returns json
language plpgsql
security definer
as $$
declare
  v_user_id uuid;
  v_base_cost numeric;
  v_current_quantity int;
  v_cost numeric;
  v_user_balance numeric;
  v_new_balance numeric;
  v_asset_name text;
begin
  -- Get the authenticated user's ID
  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Not authenticated';
  end if;

  -- Initialize quantity
  v_current_quantity := 0;

  -- Determine Asset details based on type
  if p_asset_type = 'pokemon' then
    -- Check if Asset exists and get Base Cost
    select base_cost, name into v_base_cost, v_asset_name
    from ref_pokemon
    where id = p_asset_id;

    if not found then
      raise exception 'Pokemon with ID % not found', p_asset_id;
    end if;

    -- Get Current Quantity (if any)
    select quantity into v_current_quantity
    from user_pokemon
    where user_id = v_user_id and pokemon_id = p_asset_id;

  elsif p_asset_type = 'infrastructure' then
    -- Check Infrastructure
    select base_cost, name into v_base_cost, v_asset_name
    from ref_infrastructures
    where id = p_asset_id;

    if not found then
      raise exception 'Infrastructure with ID % not found', p_asset_id;
    end if;

    -- Get Current Quantity (if any)
    select quantity into v_current_quantity
    from user_infrastructures
    where user_id = v_user_id and infrastructure_id = p_asset_id;

  else
    raise exception 'Invalid asset type: %', p_asset_type;
  end if;

  -- Handle null quantity (if not found in inventory)
  if v_current_quantity is null then
    v_current_quantity := 0;
  end if;

  -- Calculate Cost: Base * (1.15 ^ Quantity)
  v_cost := v_base_cost * power(1.15, v_current_quantity);

  -- Round cost to 2 decimal places to avoid float issues
  v_cost := round(v_cost, 2);

  -- Check User Balance
  select pokedollars into v_user_balance
  from users
  where id = v_user_id;

  if v_user_balance is null then
     raise exception 'User profile not found for ID %', v_user_id;
  end if;

  if v_user_balance < v_cost then
    raise exception 'Insufficient funds. Cost: %, Balance: %', v_cost, v_user_balance;
  end if;

  -- Execute Transaction
  v_new_balance := v_user_balance - v_cost;

  -- 1. Debit User
  update users
  set pokedollars = v_new_balance
  where id = v_user_id;

  -- 2. Update Inventory
  if p_asset_type = 'pokemon' then
    insert into user_pokemon (user_id, pokemon_id, quantity, date_acquired)
    values (v_user_id, p_asset_id, 1, now())
    on conflict (user_id, pokemon_id)
    do update set quantity = user_pokemon.quantity + 1;
  elsif p_asset_type = 'infrastructure' then
    insert into user_infrastructures (user_id, infrastructure_id, quantity, date_built)
    values (v_user_id, p_asset_id, 1, now())
    on conflict (user_id, infrastructure_id)
    do update set quantity = user_infrastructures.quantity + 1;
  end if;

  -- 3. Log Transaction
  insert into transaction_logs (user_id, transaction_type, amount, description, timestamp)
  values (v_user_id, 'BUY', -v_cost, 'Bought ' || p_asset_type || ': ' || v_asset_name, now());

  return json_build_object(
    'success', true,
    'new_balance', v_new_balance,
    'asset_type', p_asset_type,
    'asset_id', p_asset_id,
    'cost', v_cost,
    'new_quantity', v_current_quantity + 1
  );

end;
$$;
