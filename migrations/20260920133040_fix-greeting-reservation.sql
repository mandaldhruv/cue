CREATE OR REPLACE FUNCTION public.reserve_cue_greeting(
  p_audience text,
  p_event_id uuid
)
RETURNS TABLE (time_block smallint, message_index smallint)
LANGUAGE plpgsql
VOLATILE
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
DECLARE
  v_user_id uuid := auth.uid();
  v_time_block smallint;
  v_message_index smallint;
  v_existing_audience text;
BEGIN
  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Authentication required';
  END IF;

  IF p_audience NOT IN ('admin', 'student') THEN
    RAISE EXCEPTION 'Invalid greeting audience';
  END IF;

  IF p_audience = 'admin' AND NOT public.is_cue_admin() THEN
    RAISE EXCEPTION 'Admin greeting access denied';
  END IF;

  -- The same authenticated account may use the public student experience and
  -- the private Admin dashboard. The audience keeps both sequences isolated.
  PERFORM pg_advisory_xact_lock(hashtext(v_user_id::text), hashtext(p_event_id::text));

  SELECT event.time_block, event.message_index, event.audience
    INTO v_time_block, v_message_index, v_existing_audience
  FROM public.greeting_display_events AS event
  WHERE event.user_id = v_user_id
    AND event.event_id = p_event_id;

  IF FOUND THEN
    IF v_existing_audience <> p_audience THEN
      RAISE EXCEPTION 'Greeting event audience mismatch';
    END IF;
    RETURN QUERY SELECT v_time_block, v_message_index;
    RETURN;
  END IF;

  v_time_block := (extract(hour FROM (now() AT TIME ZONE 'Asia/Kolkata'))::integer / 3 + 1)::smallint;

  INSERT INTO public.greeting_progress (user_id, audience, time_block)
  VALUES (v_user_id, p_audience, v_time_block)
  ON CONFLICT ON CONSTRAINT greeting_progress_pkey DO NOTHING;

  UPDATE public.greeting_progress AS progress
  SET next_message_index = ((progress.next_message_index + 1) % 100)::smallint,
      updated_at = now()
  WHERE progress.user_id = v_user_id
    AND progress.audience = p_audience
    AND progress.time_block = v_time_block
  RETURNING ((progress.next_message_index + 99) % 100)::smallint
    INTO v_message_index;

  INSERT INTO public.greeting_display_events (
    user_id,
    event_id,
    audience,
    time_block,
    message_index
  ) VALUES (
    v_user_id,
    p_event_id,
    p_audience,
    v_time_block,
    v_message_index
  );

  RETURN QUERY SELECT v_time_block, v_message_index;
END;
$$;

REVOKE ALL ON FUNCTION public.reserve_cue_greeting(text, uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.reserve_cue_greeting(text, uuid) TO authenticated;
