-- ═══════════════════════════════════════════════════════════════
-- SUPABASE DATABASE SETUP - COPY & PASTE INTO SQL EDITOR
-- ═══════════════════════════════════════════════════════════════
-- 
-- How to use:
-- 1. Go to your Supabase project
-- 2. Click "SQL Editor" in the left sidebar
-- 3. Click "New Query"
-- 4. Copy and paste the SQL below
-- 5. Click "Run" or press Cmd/Ctrl + Enter
-- 
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- 1. CONTACT SUBMISSIONS TABLE
-- ───────────────────────────────────────────────────────────────
-- Stores all contact form submissions from your website

CREATE TABLE IF NOT EXISTS contact_submissions (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    company TEXT,
    phone TEXT,
    service TEXT,
    message TEXT NOT NULL,
    status TEXT DEFAULT 'new' NOT NULL,
    
    -- Optional: Add these for better tracking
    ip_address INET,
    user_agent TEXT,
    referrer TEXT,
    
    -- Indexes for better query performance
    CONSTRAINT contact_submissions_status_check CHECK (status IN ('new', 'contacted', 'qualified', 'closed', 'spam'))
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS contact_submissions_created_at_idx ON contact_submissions(created_at DESC);
CREATE INDEX IF NOT EXISTS contact_submissions_status_idx ON contact_submissions(status);
CREATE INDEX IF NOT EXISTS contact_submissions_email_idx ON contact_submissions(email);

-- Enable Row Level Security (RLS)
ALTER TABLE contact_submissions ENABLE ROW LEVEL SECURITY;

-- Policy: Allow anyone to insert (submit forms)
CREATE POLICY "Allow anonymous inserts on contact_submissions"
ON contact_submissions
FOR INSERT
WITH CHECK (true);

-- Policy: Only authenticated admin users can read
-- (You'll set up admin authentication later if needed)
CREATE POLICY "Allow authenticated reads on contact_submissions"
ON contact_submissions
FOR SELECT
USING (auth.role() = 'authenticated');

-- Add comment to table
COMMENT ON TABLE contact_submissions IS 'Stores contact form submissions from the DecaHire website';

-- ───────────────────────────────────────────────────────────────
-- 2. NEWSLETTER SUBSCRIBERS TABLE (Optional)
-- ───────────────────────────────────────────────────────────────
-- Stores newsletter signup emails

CREATE TABLE IF NOT EXISTS newsletter_subscribers (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    email TEXT UNIQUE NOT NULL,
    name TEXT,
    subscribed BOOLEAN DEFAULT true NOT NULL,
    unsubscribed_at TIMESTAMPTZ,
    source TEXT DEFAULT 'website',
    
    CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

CREATE INDEX IF NOT EXISTS newsletter_subscribers_email_idx ON newsletter_subscribers(email);
CREATE INDEX IF NOT EXISTS newsletter_subscribers_subscribed_idx ON newsletter_subscribers(subscribed) WHERE subscribed = true;

ALTER TABLE newsletter_subscribers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow anonymous inserts on newsletter_subscribers"
ON newsletter_subscribers
FOR INSERT
WITH CHECK (true);

CREATE POLICY "Allow authenticated reads on newsletter_subscribers"
ON newsletter_subscribers
FOR SELECT
USING (auth.role() = 'authenticated');

COMMENT ON TABLE newsletter_subscribers IS 'Newsletter subscription list';

-- ───────────────────────────────────────────────────────────────
-- 3. JOB APPLICATIONS TABLE (Optional)
-- ───────────────────────────────────────────────────────────────
-- Stores job applications and candidate info

CREATE TABLE IF NOT EXISTS job_applications (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    position TEXT NOT NULL,
    resume_url TEXT,
    cover_letter TEXT,
    linkedin_url TEXT,
    github_url TEXT,
    portfolio_url TEXT,
    years_experience INTEGER,
    current_salary TEXT,
    expected_salary TEXT,
    availability TEXT,
    willing_to_relocate BOOLEAN DEFAULT false,
    status TEXT DEFAULT 'new' NOT NULL,
    notes TEXT,
    
    CONSTRAINT job_applications_status_check CHECK (status IN ('new', 'screening', 'interview', 'offer', 'hired', 'rejected'))
);

CREATE INDEX IF NOT EXISTS job_applications_created_at_idx ON job_applications(created_at DESC);
CREATE INDEX IF NOT EXISTS job_applications_status_idx ON job_applications(status);
CREATE INDEX IF NOT EXISTS job_applications_position_idx ON job_applications(position);

ALTER TABLE job_applications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow anonymous inserts on job_applications"
ON job_applications
FOR INSERT
WITH CHECK (true);

CREATE POLICY "Allow authenticated reads on job_applications"
ON job_applications
FOR SELECT
USING (auth.role() = 'authenticated');

COMMENT ON TABLE job_applications IS 'Job applications and candidate submissions';

-- ───────────────────────────────────────────────────────────────
-- 4. CANDIDATE POOL TABLE (Optional)
-- ───────────────────────────────────────────────────────────────
-- Stores candidate profiles for your talent pool

CREATE TABLE IF NOT EXISTS candidate_pool (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    current_role TEXT,
    current_company TEXT,
    years_experience INTEGER,
    skills TEXT[], -- Array of skills
    resume_url TEXT,
    linkedin_url TEXT,
    github_url TEXT,
    portfolio_url TEXT,
    availability TEXT,
    salary_expectation TEXT,
    preferred_location TEXT,
    willing_to_relocate BOOLEAN DEFAULT false,
    work_authorization TEXT,
    education TEXT,
    certifications TEXT[],
    status TEXT DEFAULT 'active' NOT NULL,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    notes TEXT,
    source TEXT DEFAULT 'website',
    
    CONSTRAINT candidate_pool_status_check CHECK (status IN ('active', 'placed', 'not_interested', 'archived'))
);

CREATE INDEX IF NOT EXISTS candidate_pool_email_idx ON candidate_pool(email);
CREATE INDEX IF NOT EXISTS candidate_pool_status_idx ON candidate_pool(status);
CREATE INDEX IF NOT EXISTS candidate_pool_skills_idx ON candidate_pool USING GIN(skills);
CREATE INDEX IF NOT EXISTS candidate_pool_updated_at_idx ON candidate_pool(updated_at DESC);

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_candidate_pool_updated_at BEFORE UPDATE ON candidate_pool
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE candidate_pool ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow anonymous inserts on candidate_pool"
ON candidate_pool
FOR INSERT
WITH CHECK (true);

CREATE POLICY "Allow authenticated reads on candidate_pool"
ON candidate_pool
FOR SELECT
USING (auth.role() = 'authenticated');

COMMENT ON TABLE candidate_pool IS 'Talent pool of available candidates';

-- ───────────────────────────────────────────────────────────────
-- 5. CLIENT COMPANIES TABLE (Optional)
-- ───────────────────────────────────────────────────────────────
-- Track your client companies

CREATE TABLE IF NOT EXISTS client_companies (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    company_name TEXT NOT NULL,
    industry TEXT,
    website TEXT,
    company_size TEXT,
    location TEXT,
    primary_contact_name TEXT,
    primary_contact_email TEXT,
    primary_contact_phone TEXT,
    status TEXT DEFAULT 'prospect' NOT NULL,
    notes TEXT,
    
    CONSTRAINT client_companies_status_check CHECK (status IN ('prospect', 'active', 'inactive', 'closed'))
);

CREATE INDEX IF NOT EXISTS client_companies_company_name_idx ON client_companies(company_name);
CREATE INDEX IF NOT EXISTS client_companies_status_idx ON client_companies(status);

CREATE TRIGGER update_client_companies_updated_at BEFORE UPDATE ON client_companies
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE client_companies ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow authenticated reads on client_companies"
ON client_companies
FOR SELECT
USING (auth.role() = 'authenticated');

COMMENT ON TABLE client_companies IS 'Client company information';

-- ───────────────────────────────────────────────────────────────
-- 6. JOB POSTINGS TABLE (Optional)
-- ───────────────────────────────────────────────────────────────
-- Track job postings from clients

CREATE TABLE IF NOT EXISTS job_postings (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    client_company_id BIGINT REFERENCES client_companies(id),
    title TEXT NOT NULL,
    description TEXT,
    requirements TEXT,
    location TEXT,
    employment_type TEXT, -- full-time, part-time, contract
    salary_range TEXT,
    experience_level TEXT, -- entry, mid, senior, lead, executive
    skills_required TEXT[],
    status TEXT DEFAULT 'open' NOT NULL,
    positions_available INTEGER DEFAULT 1,
    applications_count INTEGER DEFAULT 0,
    
    CONSTRAINT job_postings_status_check CHECK (status IN ('draft', 'open', 'on_hold', 'filled', 'closed'))
);

CREATE INDEX IF NOT EXISTS job_postings_status_idx ON job_postings(status);
CREATE INDEX IF NOT EXISTS job_postings_client_company_id_idx ON job_postings(client_company_id);
CREATE INDEX IF NOT EXISTS job_postings_skills_required_idx ON job_postings USING GIN(skills_required);

CREATE TRIGGER update_job_postings_updated_at BEFORE UPDATE ON job_postings
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE job_postings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public reads on job_postings"
ON job_postings
FOR SELECT
USING (status = 'open');

COMMENT ON TABLE job_postings IS 'Active and historical job postings';

-- ───────────────────────────────────────────────────────────────
-- 7. USEFUL VIEWS
-- ───────────────────────────────────────────────────────────────

-- View: Recent contact submissions
CREATE OR REPLACE VIEW recent_contacts AS
SELECT 
    id,
    created_at,
    name,
    email,
    company,
    service,
    status,
    LEFT(message, 100) || '...' as message_preview
FROM contact_submissions
ORDER BY created_at DESC
LIMIT 50;

-- View: Active candidates
CREATE OR REPLACE VIEW active_candidates AS
SELECT 
    id,
    full_name,
    email,
    current_role,
    years_experience,
    skills,
    availability,
    rating,
    updated_at
FROM candidate_pool
WHERE status = 'active'
ORDER BY updated_at DESC;

-- View: Open positions summary
CREATE OR REPLACE VIEW open_positions_summary AS
SELECT 
    jp.id,
    jp.title,
    cc.company_name,
    jp.location,
    jp.employment_type,
    jp.experience_level,
    jp.applications_count,
    jp.positions_available,
    jp.created_at
FROM job_postings jp
LEFT JOIN client_companies cc ON jp.client_company_id = cc.id
WHERE jp.status = 'open'
ORDER BY jp.created_at DESC;

-- ───────────────────────────────────────────────────────────────
-- 8. ANALYTICS QUERIES (Examples)
-- ───────────────────────────────────────────────────────────────

-- Contact submissions by service type
CREATE OR REPLACE VIEW contacts_by_service AS
SELECT 
    service,
    COUNT(*) as count,
    COUNT(*) FILTER (WHERE status = 'new') as new_count,
    COUNT(*) FILTER (WHERE status = 'qualified') as qualified_count
FROM contact_submissions
GROUP BY service
ORDER BY count DESC;

-- Daily submission counts (last 30 days)
CREATE OR REPLACE VIEW daily_submissions AS
SELECT 
    DATE(created_at) as date,
    COUNT(*) as submissions
FROM contact_submissions
WHERE created_at >= NOW() - INTERVAL '30 days'
GROUP BY DATE(created_at)
ORDER BY date DESC;

-- ═══════════════════════════════════════════════════════════════
-- SETUP COMPLETE!
-- ═══════════════════════════════════════════════════════════════
-- 
-- Next steps:
-- 1. Copy your Supabase URL and Anon Key from Project Settings > API
-- 2. Add them to your website's JavaScript (see contact-form-supabase.html)
-- 3. Test the contact form!
-- 
-- To view your data:
-- - Go to "Table Editor" in Supabase
-- - Click on any table to see submissions
-- - Use the views for quick insights
-- 
-- ═══════════════════════════════════════════════════════════════
