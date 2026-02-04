CREATE OR REPLACE FUNCTION buy_asset(
    p_asset_type VARCHAR,
    p_asset_id BIGINT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_user_id BIGINT;
    v_base_cost NUMERIC;
    v_current_quantity INTEGER := 0;
    v_calculated_cost NUMERIC;
    v_user_balance NUMERIC;
    v_new_balance NUMERIC;
    v_asset_name VARCHAR;
BEGIN
    -- 1. Get User ID from Supabase Auth
    v_user_id := auth.uid()::BIGINT;

    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'Not authenticated';
    END IF;

    -- 2. Determine Asset details and Current Quantity
    IF p_asset_type = 'pokemon' THEN
        -- Get base cost and name
        SELECT base_cost, name INTO v_base_cost, v_asset_name
        FROM ref_pokemon
        WHERE id = p_asset_id;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Pokemon not found';
        END IF;

        -- Get current quantity (default 0)
        SELECT quantity INTO v_current_quantity
        FROM user_pokemon
        WHERE user_id = v_user_id AND pokemon_id = p_asset_id;

        v_current_quantity := COALESCE(v_current_quantity, 0);

    ELSIF p_asset_type = 'infrastructure' THEN
        -- Get base cost and name
        SELECT base_cost, name INTO v_base_cost, v_asset_name
        FROM ref_infrastructures
        WHERE id = p_asset_id;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Infrastructure not found';
        END IF;

        -- Get current quantity (default 0)
        SELECT quantity INTO v_current_quantity
        FROM user_infrastructures
        WHERE user_id = v_user_id AND infrastructure_id = p_asset_id;

        v_current_quantity := COALESCE(v_current_quantity, 0);

    ELSE
        RAISE EXCEPTION 'Invalid asset type: %', p_asset_type;
    END IF;

    -- 3. Calculate Cost: Base * (1.15 ^ Current_Quantity)
    v_calculated_cost := v_base_cost * POWER(1.15, v_current_quantity);
    -- Round to integer to avoid floating point dust, or keep numeric
    v_calculated_cost := FLOOR(v_calculated_cost);

    -- 4. Check User Balance
    SELECT pokedollars INTO v_user_balance
    FROM users
    WHERE id = v_user_id;

    IF v_user_balance < v_calculated_cost THEN
        RAISE EXCEPTION 'Insufficient funds. Cost: %, Balance: %', v_calculated_cost, v_user_balance;
    END IF;

    -- 5. Execute Transaction

    -- Deduct funds
    UPDATE users
    SET pokedollars = pokedollars - v_calculated_cost
    WHERE id = v_user_id
    RETURNING pokedollars INTO v_new_balance;

    -- Update Inventory
    IF p_asset_type = 'pokemon' THEN
        INSERT INTO user_pokemon (user_id, pokemon_id, quantity, date_acquired)
        VALUES (v_user_id, p_asset_id, 1, NOW())
        ON CONFLICT (user_id, pokemon_id)
        DO UPDATE SET quantity = user_pokemon.quantity + 1;
    ELSIF p_asset_type = 'infrastructure' THEN
        INSERT INTO user_infrastructures (user_id, infrastructure_id, quantity, date_built)
        VALUES (v_user_id, p_asset_id, 1, NOW())
        ON CONFLICT (user_id, infrastructure_id)
        DO UPDATE SET quantity = user_infrastructures.quantity + 1;
    END IF;

    -- Log Transaction
    INSERT INTO transaction_logs (user_id, transaction_type, amount, description, timestamp)
    VALUES (
        v_user_id,
        'BUY',
        -v_calculated_cost,
        'Bought ' || p_asset_type || ': ' || v_asset_name || ' (Qty: ' || (v_current_quantity + 1) || ')',
        NOW()
    );

    -- 6. Return Success Response
    RETURN jsonb_build_object(
        'success', true,
        'new_balance', v_new_balance,
        'asset_bought', v_asset_name,
        'cost', v_calculated_cost,
        'new_quantity', v_current_quantity + 1
    );
END;
$$;
