-- ROENC v11 — Run in Supabase SQL Editor (safe to run again)
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS can_publish_courses BOOLEAN DEFAULT FALSE;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS can_receive_messages BOOLEAN DEFAULT FALSE;

CREATE TABLE IF NOT EXISTS user_courses (id UUID PRIMARY KEY DEFAULT gen_random_uuid(),user_id UUID,course_id UUID,purchased_at TIMESTAMPTZ DEFAULT NOW());
ALTER TABLE user_courses ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "uc_all" ON user_courses;CREATE POLICY "uc_all" ON user_courses FOR ALL USING (true);

CREATE TABLE IF NOT EXISTS private_messages (id UUID PRIMARY KEY DEFAULT gen_random_uuid(),sender_id UUID NOT NULL,sender_name TEXT,receiver_id UUID NOT NULL,receiver_name TEXT,text TEXT NOT NULL,read BOOLEAN DEFAULT FALSE,created_at TIMESTAMPTZ DEFAULT NOW());
ALTER TABLE private_messages ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "pm_all" ON private_messages;CREATE POLICY "pm_all" ON private_messages FOR ALL USING (true);
DO $$ BEGIN ALTER PUBLICATION supabase_realtime ADD TABLE private_messages;EXCEPTION WHEN OTHERS THEN NULL;END $$;

CREATE TABLE IF NOT EXISTS masterclasses (id UUID PRIMARY KEY DEFAULT gen_random_uuid(),title TEXT NOT NULL,description TEXT,event_date TEXT,city TEXT,price INT DEFAULT 0,whatsapp_url TEXT,published BOOLEAN DEFAULT TRUE,created_at TIMESTAMPTZ DEFAULT NOW());
ALTER TABLE masterclasses ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "mc_all" ON masterclasses;CREATE POLICY "mc_all" ON masterclasses FOR ALL USING (true);

ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_role_check;
ALTER TABLE profiles ADD CONSTRAINT profiles_role_check CHECK (role IN ('client','student','healer','curator','admin'));
SELECT '✅ v11 done!' AS status;
