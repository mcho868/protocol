-- Decision Protocol tables: decision_matrices + decision_events

-- 1. Create decision_matrices table
CREATE TABLE public.decision_matrices (
  decision_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  session_uuid UUID REFERENCES public.sessions(uuid) ON DELETE SET NULL,
  title TEXT,
  protocol_label TEXT DEFAULT 'Decision Protocol',
  raw_json JSONB NOT NULL,
  outcome TEXT DEFAULT 'PENDING',
  review_notes TEXT,
  calibration_summary TEXT,
  next_step TEXT,
  first_action_due TIMESTAMP WITH TIME ZONE,
  review_date TIMESTAMP WITH TIME ZONE,
  last_reviewed_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Create decision_events table (append-only audit log)
CREATE TABLE public.decision_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  decision_id UUID REFERENCES public.decision_matrices(decision_id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  event_type TEXT NOT NULL,
  note TEXT,
  occurred_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Enable Row Level Security
ALTER TABLE public.decision_matrices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.decision_events ENABLE ROW LEVEL SECURITY;

-- 4. RLS Policies
-- Decision matrices: users can only manage their own
CREATE POLICY "Users can manage their own decision matrices" ON public.decision_matrices
  FOR ALL USING (auth.uid() = user_id);

-- Decision events: users can only manage their own
CREATE POLICY "Users can manage their own decision events" ON public.decision_events
  FOR ALL USING (auth.uid() = user_id);

-- 5. Optional outcome constraint (keeps values consistent)
ALTER TABLE public.decision_matrices
  ADD CONSTRAINT decision_outcome_check
  CHECK (outcome IN ('PENDING', 'SUCCESS', 'FAILURE', 'AMBIGUOUS'));

-- 6. Indexes
CREATE INDEX decision_matrices_user_id_idx ON public.decision_matrices(user_id);
CREATE INDEX decision_events_decision_id_idx ON public.decision_events(decision_id);
