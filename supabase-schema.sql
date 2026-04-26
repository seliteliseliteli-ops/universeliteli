-- ═══════════════════════════════════════════════════════════
-- РОЭНЦ — Supabase Database Schema
-- Запустите этот скрипт в Supabase → SQL Editor → New Query
-- ═══════════════════════════════════════════════════════════

-- 1. USERS (profiles)
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  display_name TEXT,
  photo_url TEXT,
  role TEXT DEFAULT 'client' CHECK (role IN ('client', 'student', 'curator', 'admin')),
  phone TEXT,
  course_access TEXT[] DEFAULT '{}',
  blocked BOOLEAN DEFAULT FALSE,
  admin_notes TEXT,
  agreement_signed_at TIMESTAMPTZ,
  agreement_version TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. HEALERS
CREATE TABLE IF NOT EXISTS healers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  photo_url TEXT,
  city TEXT NOT NULL,
  specialization TEXT,
  description TEXT,
  phone TEXT,
  whatsapp_url TEXT,
  published BOOLEAN DEFAULT TRUE,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. CITIES
CREATE TABLE IF NOT EXISTS cities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  address TEXT,
  phone TEXT,
  schedule TEXT,
  sort_order INT DEFAULT 0
);

-- 4. COURSES
CREATE TABLE IF NOT EXISTS courses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  cover_image TEXT,
  healer_id UUID REFERENCES healers(id) ON DELETE SET NULL,
  healer_name TEXT,
  price INT DEFAULT 0,
  currency TEXT DEFAULT 'KZT',
  topic TEXT,
  published BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. MODULES
CREATE TABLE IF NOT EXISTS modules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  sort_order INT DEFAULT 0
);

-- 6. LESSONS
CREATE TABLE IF NOT EXISTS lessons (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  module_id UUID REFERENCES modules(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  video_url TEXT,
  content TEXT,
  sort_order INT DEFAULT 0
);

-- 7. POSTS (news + blog)
CREATE TABLE IF NOT EXISTS posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  slug TEXT UNIQUE,
  excerpt TEXT,
  content TEXT,
  cover_image TEXT,
  tags TEXT[] DEFAULT '{}',
  published BOOLEAN DEFAULT TRUE,
  post_type TEXT DEFAULT 'news' CHECK (post_type IN ('news', 'blog')),
  author_name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. MASTERCLASSES
CREATE TABLE IF NOT EXISTS masterclasses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  event_date TEXT,
  city TEXT,
  cover_image TEXT,
  whatsapp_url TEXT,
  published BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 9. GALLERY
CREATE TABLE IF NOT EXISTS gallery (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  item_type TEXT DEFAULT 'photo' CHECK (item_type IN ('photo', 'video')),
  url TEXT,
  youtube_url TEXT,
  caption TEXT,
  published BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 10. REVIEWS
CREATE TABLE IF NOT EXISTS reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  text TEXT,
  photo_url TEXT,
  video_url TEXT,
  rating INT DEFAULT 5 CHECK (rating >= 1 AND rating <= 5),
  published BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 11. CHAT MESSAGES
CREATE TABLE IF NOT EXISTS chat_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
  user_name TEXT,
  user_photo TEXT,
  text TEXT NOT NULL,
  msg_type TEXT DEFAULT 'community' CHECK (msg_type IN ('community', 'personal')),
  recipient_id UUID,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 12. AGREEMENTS
CREATE TABLE IF NOT EXISTS agreements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  pdf_url TEXT,
  version TEXT,
  active BOOLEAN DEFAULT FALSE,
  uploaded_at TIMESTAMPTZ DEFAULT NOW()
);

-- 13. SITE SETTINGS (single row)
CREATE TABLE IF NOT EXISTS site_settings (
  id INT PRIMARY KEY DEFAULT 1 CHECK (id = 1),
  logo_url TEXT,
  site_name TEXT DEFAULT 'РОЭНЦ',
  whatsapp_number TEXT,
  whatsapp_url TEXT,
  whatsapp_message TEXT,
  phone TEXT,
  email TEXT,
  instagram TEXT,
  telegram TEXT,
  seo_title TEXT,
  seo_description TEXT,
  seo_keywords TEXT,
  footer_text TEXT
);

-- 14. HOMEPAGE DATA (single row)
CREATE TABLE IF NOT EXISTS homepage_data (
  id INT PRIMARY KEY DEFAULT 1 CHECK (id = 1),
  hero_title TEXT,
  hero_subtitle TEXT,
  hero_mission TEXT,
  hero_bg_image TEXT,
  hero_cta_text TEXT DEFAULT 'Найти целителя',
  hero_cta_link TEXT DEFAULT '/registry',
  stats_healers INT DEFAULT 150,
  stats_cities INT DEFAULT 25,
  stats_years INT DEFAULT 12,
  stats_students INT DEFAULT 3000,
  about_text TEXT
);

-- 15. ACADEMY CONTENT
CREATE TABLE IF NOT EXISTS academy_content (
  id INT PRIMARY KEY DEFAULT 1 CHECK (id = 1),
  title TEXT DEFAULT 'Академия ЭСД',
  subtitle TEXT,
  description TEXT,
  cover_image TEXT,
  whatsapp_url TEXT,
  cities TEXT[] DEFAULT '{}',
  features TEXT[] DEFAULT '{}',
  published BOOLEAN DEFAULT TRUE
);

-- 16. SCHOOL CONTENT
CREATE TABLE IF NOT EXISTS school_content (
  id INT PRIMARY KEY DEFAULT 1 CHECK (id = 1),
  title TEXT DEFAULT 'Школа ЭСД',
  subtitle TEXT,
  description TEXT,
  cover_image TEXT,
  min_age INT DEFAULT 14,
  whatsapp_url TEXT,
  cities TEXT[] DEFAULT '{}',
  features TEXT[] DEFAULT '{}',
  published BOOLEAN DEFAULT TRUE
);

-- ═══════════════════════════════════════════════════════════
-- ROW LEVEL SECURITY (RLS)
-- ═══════════════════════════════════════════════════════════

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE healers ENABLE ROW LEVEL SECURITY;
ALTER TABLE cities ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE modules ENABLE ROW LEVEL SECURITY;
ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE masterclasses ENABLE ROW LEVEL SECURITY;
ALTER TABLE gallery ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE agreements ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE homepage_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE academy_content ENABLE ROW LEVEL SECURITY;
ALTER TABLE school_content ENABLE ROW LEVEL SECURITY;

-- Public read for published content
CREATE POLICY "Public read healers" ON healers FOR SELECT USING (published = true);
CREATE POLICY "Public read cities" ON cities FOR SELECT USING (true);
CREATE POLICY "Public read courses" ON courses FOR SELECT USING (published = true);
CREATE POLICY "Public read modules" ON modules FOR SELECT USING (true);
CREATE POLICY "Public read lessons" ON lessons FOR SELECT USING (true);
CREATE POLICY "Public read posts" ON posts FOR SELECT USING (published = true);
CREATE POLICY "Public read masterclasses" ON masterclasses FOR SELECT USING (published = true);
CREATE POLICY "Public read gallery" ON gallery FOR SELECT USING (published = true);
CREATE POLICY "Public read reviews" ON reviews FOR SELECT USING (published = true);
CREATE POLICY "Public read settings" ON site_settings FOR SELECT USING (true);
CREATE POLICY "Public read homepage" ON homepage_data FOR SELECT USING (true);
CREATE POLICY "Public read academy" ON academy_content FOR SELECT USING (true);
CREATE POLICY "Public read school" ON school_content FOR SELECT USING (true);
CREATE POLICY "Public read agreements" ON agreements FOR SELECT USING (true);

-- Profiles: users read all, update own
CREATE POLICY "Users read profiles" ON profiles FOR SELECT USING (true);
CREATE POLICY "Users update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- Chat: authenticated can read and insert
CREATE POLICY "Auth read chat" ON chat_messages FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Auth insert chat" ON chat_messages FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Admin full access (using service role or custom function)
-- For now, admins manage via Supabase Dashboard or we add admin policies later

-- ═══════════════════════════════════════════════════════════
-- SEED DATA (начальные данные)
-- ═══════════════════════════════════════════════════════════

-- Site Settings
INSERT INTO site_settings (id, site_name, phone, email, whatsapp_url, seo_title, seo_description, footer_text)
VALUES (1, 'РОЭНЦ', '+7 (777) 123-45-67', 'info@roenc.kz', 'https://wa.me/77771234567', 'РОЭНЦ — Республиканское Общество Целителей', 'Республиканское Общество Народных и Энергетических Целителей Казахстана', '© 2026 РОЭНЦ — Все права защищены')
ON CONFLICT (id) DO NOTHING;

-- Homepage
INSERT INTO homepage_data (id, hero_title, hero_subtitle, hero_mission, stats_healers, stats_cities, stats_years, stats_students)
VALUES (1, 'Республиканское Общество Народных и Энергетических Целителей', 'Объединяем целителей Казахстана для сохранения и развития традиций исцеления', 'Исцеление через знание', 150, 25, 12, 3000)
ON CONFLICT (id) DO NOTHING;

-- Academy
INSERT INTO academy_content (id, title, subtitle, description, features, cities)
VALUES (1, 'Академия ЭСД', 'Энергетика · Сила · Дух', 'Профессиональное обучение энергетическому целительству. Глубокое погружение в мир целительских практик под руководством опытных мастеров.', ARRAY['Индивидуальный подход к каждому студенту', 'Практические занятия с реальными случаями', 'Сертификация по завершении обучения', 'Постоянная поддержка кураторов'], ARRAY['Алматы', 'Астана', 'Шымкент'])
ON CONFLICT (id) DO NOTHING;

-- School
INSERT INTO school_content (id, title, subtitle, description, min_age, features, cities)
VALUES (1, 'Школа ЭСД', 'Для молодого поколения', 'Обучение основам целительских практик для молодых людей. Программа адаптирована для подросткового восприятия.', 14, ARRAY['Адаптированная программа для подростков', 'Безопасные практики под наблюдением', 'Развитие интуиции и энергочувствительности', 'Групповые занятия и командная работа'], ARRAY['Алматы', 'Астана'])
ON CONFLICT (id) DO NOTHING;

-- Cities
INSERT INTO cities (name, phone, schedule, sort_order) VALUES
('Алматы', '+7 (727) 123-45-67', 'Пн-Пт: 09:00 — 18:00', 1),
('Астана', '+7 (717) 234-56-78', 'Пн-Пт: 09:00 — 18:00', 2),
('Шымкент', '+7 (725) 345-67-89', 'Пн-Пт: 09:00 — 17:00', 3),
('Караганда', '+7 (721) 456-78-90', 'Пн-Пт: 09:00 — 17:00', 4),
('Актобе', '+7 (713) 567-89-01', 'Пн-Пт: 10:00 — 17:00', 5),
('Тараз', '+7 (726) 678-90-12', 'Пн-Пт: 10:00 — 17:00', 6);

-- Healers
INSERT INTO healers (name, city, specialization, description, published, sort_order) VALUES
('Айгуль Нурланова', 'Алматы', 'Энергетическое целительство', 'Мастер с 15-летним опытом работы в области энергетического целительства и биоэнергетики. Проводит индивидуальные и групповые сеансы.', true, 1),
('Бауыржан Сериков', 'Астана', 'Народная медицина', 'Специалист по народным методам лечения, знаток казахской традиционной медицины с 20-летним стажем.', true, 2),
('Гульнара Ахметова', 'Алматы', 'Рэйки и биоэнергетика', 'Сертифицированный мастер Рэйки, практик холистического исцеления.', true, 3),
('Дархан Мусаев', 'Шымкент', 'Траволечение', 'Эксперт в области фитотерапии и траволечения с глубоким знанием целебных растений.', true, 4),
('Елена Ким', 'Караганда', 'Энергетический массаж', 'Практик энергетического массажа и восстановительных практик.', true, 5),
('Жанар Тулегенова', 'Астана', 'Целительство звуком', 'Мастер звуковой терапии, использует поющие чаши и обертонное пение.', true, 6);

-- Courses (link to healers by name for simplicity)
INSERT INTO courses (title, healer_name, price, topic, published, healer_id) VALUES
('Основы энергетического целительства', 'Айгуль Нурланова', 45000, 'Энергетика', true, (SELECT id FROM healers WHERE name = 'Айгуль Нурланова' LIMIT 1)),
('Траволечение Казахстана', 'Дархан Мусаев', 35000, 'Народная медицина', true, (SELECT id FROM healers WHERE name = 'Дархан Мусаев' LIMIT 1)),
('Рэйки: Первая ступень', 'Гульнара Ахметова', 55000, 'Рэйки', true, (SELECT id FROM healers WHERE name = 'Гульнара Ахметова' LIMIT 1)),
('Звуковая терапия для начинающих', 'Жанар Тулегенова', 40000, 'Звукотерапия', true, (SELECT id FROM healers WHERE name = 'Жанар Тулегенова' LIMIT 1)),
('Биоэнергетика и диагностика', 'Бауыржан Сериков', 50000, 'Биоэнергетика', true, (SELECT id FROM healers WHERE name = 'Бауыржан Сериков' LIMIT 1)),
('Медитация и самоисцеление', 'Елена Ким', 30000, 'Медитация', true, (SELECT id FROM healers WHERE name = 'Елена Ким' LIMIT 1));

-- Reviews
INSERT INTO reviews (name, text, rating, published) VALUES
('Марина К.', 'Благодаря РОЭНЦ я нашла удивительного целителя, который помог мне восстановить здоровье. Бесконечно благодарна!', 5, true),
('Алексей Т.', 'Курс по энергетике изменил моё понимание мира. Профессиональные преподаватели и глубокие знания.', 5, true),
('Сауле М.', 'Академия ЭСД — это место, где знания передаются с душой. Рекомендую всем, кто на пути к исцелению.', 4, true),
('Дмитрий В.', 'Прошёл мастер-класс по звукотерапии. Невероятный опыт! Планирую записаться на полный курс.', 5, true);

-- Posts (news + blog)
INSERT INTO posts (title, slug, excerpt, post_type, author_name, published) VALUES
('Открытие нового филиала в Караганде', 'opening-karaganda', 'Рады сообщить об открытии филиала РОЭНЦ в Караганде. Приглашаем на день открытых дверей.', 'news', 'РОЭНЦ', true),
('Весенний фестиваль целительских практик', 'spring-festival', 'С 1 по 5 апреля приглашаем на ежегодный фестиваль в Алматы. Мастер-классы, лекции, практики.', 'news', 'РОЭНЦ', true),
('Сила намерения: путь к гармонии', 'power-of-intention', 'Как осознанное намерение может трансформировать вашу практику целительства.', 'blog', 'Айгуль Нурланова', true),
('Традиции казахского целительства', 'kazakh-traditions', 'Исследуем корни народной медицины Казахстана и её место в современном мире.', 'blog', 'Бауыржан Сериков', true);

-- Masterclasses
INSERT INTO masterclasses (title, description, event_date, city, published) VALUES
('Энергетическая диагностика', 'Научитесь определять энергетические блоки и дисбаланс в теле.', '5 апреля 2026', 'Алматы', true),
('Основы звукотерапии', 'Практикум по использованию поющих чаш и звуковых инструментов.', '12 апреля 2026', 'Астана', true),
('Целительные травы Казахстана', 'Экскурсия и мастер-класс по сбору и применению лекарственных растений.', '19 апреля 2026', 'Шымкент', true);

-- Done!
SELECT 'Database setup complete! ✅' AS status;
