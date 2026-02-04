-- Function to update user's geolocation
-- Updates latitude and longitude for the authenticated user

create or replace function update_user_location(
  p_latitude double precision,
  p_longitude double precision
) returns void
language plpgsql
security definer
as $$
declare
  v_user_id uuid;
begin
  -- Get the authenticated user's ID
  v_user_id := auth.uid();

  if v_user_id is null then
    raise exception 'Not authenticated';
  end if;

  -- Update user location
  update users
  set
    latitude = p_latitude,
    longitude = p_longitude,
    last_sync = now()
  where id = v_user_id;

end;
$$;
