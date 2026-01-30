-- 1. Create Profiles table (Syncs with UserContext)
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL PRIMARY KEY,
  core_values TEXT[] DEFAULT '{}',
  north_star_metric TEXT,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_synced_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Create Sessions table (Syncs with Isar Sessions)
CREATE TABLE public.sessions (
  uuid UUID NOT NULL PRIMARY KEY,
  user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  protocol_type TEXT,
  history JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_synced_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Create Coaches table (For remote prompt management)
CREATE TABLE public.coaches (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  system_prompt TEXT NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Enable Row Level Security (RLS)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.coaches ENABLE ROW LEVEL SECURITY;

-- 5. Create RLS Policies
-- Profiles: Users can only see/update their own profile
CREATE POLICY "Users can manage their own profile" ON public.profiles
  FOR ALL USING (auth.uid() = id);

-- Sessions: Users can only see/update their own sessions
CREATE POLICY "Users can manage their own sessions" ON public.sessions
  FOR ALL USING (auth.uid() = user_id);

-- Coaches: Everyone can read active coaches, only admins (service role) can write
CREATE POLICY "Anyone can view active coaches" ON public.coaches
  FOR SELECT USING (is_active = true);

-- 6. Setup automatic profile creation on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id)
  VALUES (new.id);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
