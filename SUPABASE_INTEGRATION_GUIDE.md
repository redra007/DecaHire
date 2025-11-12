# Supabase Integration Guide for DecaHire Website

## 📋 Overview

This guide shows you how to integrate Supabase with your website for:
- **Contact form submissions** (store inquiries in a database)
- **Newsletter signups**
- **Job applications**
- **Candidate registrations**
- **Any other data collection needs**

**Why Supabase?**
- FREE tier (50,000 monthly active users)
- Real-time database
- Built-in authentication (if needed later)
- PostgreSQL database
- Automatic APIs
- Easy to use

---

## 🚀 Part 1: Supabase Setup (10 minutes)

### Step 1: Create Supabase Account
1. Go to https://supabase.com
2. Click "Start your project"
3. Sign in with GitHub (easiest) or email
4. Create new organization (e.g., "DecaHire")

### Step 2: Create Project
1. Click "New Project"
2. **Name**: DecaHire Website
3. **Database Password**: Create a strong password (save it!)
4. **Region**: Choose closest to your users (e.g., US East, EU West, Asia Southeast)
5. **Pricing**: Select FREE tier
6. Click "Create new project"
7. Wait 2-3 minutes for setup

### Step 3: Create Contact Form Table
1. In Supabase dashboard, click "Table Editor" (left sidebar)
2. Click "Create a new table"
3. **Table name**: `contact_submissions`
4. Enable "Enable Row Level Security (RLS)" ✅
5. Add columns:

   | Column Name | Type | Default Value | Extra |
   |------------|------|---------------|-------|
   | id | int8 | (auto) | Primary Key, Auto-increment |
   | created_at | timestamptz | now() | - |
   | name | text | - | - |
   | email | text | - | - |
   | company | text | - | nullable |
   | message | text | - | - |
   | phone | text | - | nullable |
   | service | text | - | nullable |
   | status | text | 'new' | - |

6. Click "Save"

### Step 4: Set Row Level Security (RLS) Policies
1. Click on "contact_submissions" table
2. Click "RLS" tab
3. Click "New Policy"
4. **Policy name**: Allow anonymous inserts
5. **Policy command**: INSERT
6. **Using expression**: 
   ```sql
   true
   ```
7. Click "Save policy"

This allows anyone to submit forms (but not read or modify existing data).

### Step 5: Get Your API Keys
1. Click "Project Settings" (gear icon, bottom left)
2. Click "API" in the sidebar
3. Copy these values (you'll need them):
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon public key**: `eyJhbGc...` (long string)

---

## 💻 Part 2: Add Contact Form to Website

### Option A: Simple JavaScript (Recommended for Beginners)

Add this code to your `index.html` just before `</body>`:

```html
<!-- Supabase Integration -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<script>
// Initialize Supabase
const SUPABASE_URL = 'YOUR_PROJECT_URL_HERE';
const SUPABASE_KEY = 'YOUR_ANON_KEY_HERE';
const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY);

// Handle contact form submission
async function handleContactSubmit(event) {
    event.preventDefault();
    
    const formData = {
        name: document.getElementById('name').value,
        email: document.getElementById('email').value,
        company: document.getElementById('company').value || null,
        phone: document.getElementById('phone').value || null,
        service: document.getElementById('service').value || null,
        message: document.getElementById('message').value,
        status: 'new'
    };
    
    // Show loading state
    const submitButton = event.target.querySelector('button[type="submit"]');
    const originalText = submitButton.textContent;
    submitButton.textContent = 'Sending...';
    submitButton.disabled = true;
    
    try {
        const { data, error } = await supabase
            .from('contact_submissions')
            .insert([formData]);
        
        if (error) throw error;
        
        // Success!
        alert('Thank you! We\'ll get back to you soon.');
        event.target.reset();
        
    } catch (error) {
        console.error('Error:', error);
        alert('Something went wrong. Please try again or email us directly.');
    } finally {
        submitButton.textContent = originalText;
        submitButton.disabled = false;
    }
}

// Attach to your form
document.addEventListener('DOMContentLoaded', function() {
    const contactForm = document.getElementById('contact-form');
    if (contactForm) {
        contactForm.addEventListener('submit', handleContactSubmit);
    }
});
</script>
```

### Add Contact Form HTML

Replace the contact section in your HTML with this:

```html
<section class="contact-section" id="contact">
    <div class="container">
        <h2>Get in Touch</h2>
        <p>Let's discuss how we can help you build your team</p>
        
        <form id="contact-form" class="contact-form">
            <div class="form-row">
                <div class="form-group">
                    <label for="name">Full Name *</label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div class="form-group">
                    <label for="email">Email *</label>
                    <input type="email" id="email" name="email" required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="company">Company</label>
                    <input type="text" id="company" name="company">
                </div>
                <div class="form-group">
                    <label for="phone">Phone</label>
                    <input type="tel" id="phone" name="phone">
                </div>
            </div>
            
            <div class="form-group">
                <label for="service">Service Interested In</label>
                <select id="service" name="service">
                    <option value="">Select a service...</option>
                    <option value="tech-recruitment">Tech Recruitment</option>
                    <option value="executive-search">Executive Search</option>
                    <option value="contract-hiring">Contract Hiring</option>
                    <option value="talent-advisory">Talent Advisory</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="message">Message *</label>
                <textarea id="message" name="message" rows="5" required></textarea>
            </div>
            
            <button type="submit" class="cta-button">Send Message</button>
        </form>
    </div>
</section>

<style>
.contact-form {
    max-width: 600px;
    margin: 40px auto;
}

.form-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
    margin-bottom: 20px;
}

.form-group {
    margin-bottom: 20px;
}

.form-group label {
    display: block;
    margin-bottom: 8px;
    font-weight: 600;
    color: #1a1a1a;
}

.form-group input,
.form-group textarea,
.form-group select {
    width: 100%;
    padding: 12px;
    border: 2px solid #e0e0e0;
    border-radius: 8px;
    font-size: 16px;
    font-family: inherit;
    transition: border-color 0.3s;
}

.form-group input:focus,
.form-group textarea:focus,
.form-group select:focus {
    outline: none;
    border-color: #ff6b4a;
}

@media (max-width: 768px) {
    .form-row {
        grid-template-columns: 1fr;
    }
}
</style>
```

---

## 📊 Part 3: View Submissions

### Method 1: Supabase Dashboard
1. Go to your Supabase project
2. Click "Table Editor"
3. Click "contact_submissions"
4. See all submissions in real-time!

### Method 2: Email Notifications (Advanced)

You can set up Supabase Edge Functions to email you when someone submits:

```sql
-- Create a function that triggers on new rows
create or replace function notify_new_contact()
returns trigger as $$
begin
  -- You'll need to configure email sending through a service like SendGrid
  -- Or use Supabase's built-in email triggers
  perform net.http_post(
    url:='YOUR_WEBHOOK_URL',
    body:=jsonb_build_object(
      'name', new.name,
      'email', new.email,
      'message', new.message
    )
  );
  return new;
end;
$$ language plpgsql;

-- Create trigger
create trigger on_contact_submission
  after insert on contact_submissions
  for each row execute function notify_new_contact();
```

---

## 🎯 Part 4: Additional Use Cases

### Newsletter Signup Table

```sql
CREATE TABLE newsletter_subscribers (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    email TEXT UNIQUE NOT NULL,
    name TEXT,
    subscribed BOOLEAN DEFAULT true
);
```

### Job Applications Table

```sql
CREATE TABLE job_applications (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    position TEXT NOT NULL,
    resume_url TEXT,
    cover_letter TEXT,
    linkedin_url TEXT,
    years_experience INTEGER,
    status TEXT DEFAULT 'new'
);
```

### Candidate Registration Table

```sql
CREATE TABLE candidate_registrations (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    current_role TEXT,
    years_experience INTEGER,
    skills TEXT[],
    resume_url TEXT,
    linkedin_url TEXT,
    github_url TEXT,
    portfolio_url TEXT,
    availability TEXT,
    salary_expectation TEXT,
    willing_to_relocate BOOLEAN,
    preferred_location TEXT,
    status TEXT DEFAULT 'active'
);
```

---

## 🔒 Security Best Practices

### 1. Row Level Security (RLS)
Always enable RLS on tables! Example policies:

```sql
-- Allow anyone to insert (but not read others' data)
CREATE POLICY "Allow anonymous inserts" 
ON contact_submissions 
FOR INSERT 
WITH CHECK (true);

-- Only authenticated users with admin role can read
CREATE POLICY "Only admins can read submissions"
ON contact_submissions
FOR SELECT
USING (auth.jwt() ->> 'role' = 'admin');
```

### 2. Rate Limiting
Add this to prevent spam:

```javascript
// Simple client-side rate limiting
let lastSubmitTime = 0;
const COOLDOWN_MS = 30000; // 30 seconds

async function handleContactSubmit(event) {
    event.preventDefault();
    
    const now = Date.now();
    if (now - lastSubmitTime < COOLDOWN_MS) {
        alert('Please wait 30 seconds before submitting again.');
        return;
    }
    
    // ... rest of submission code
    
    lastSubmitTime = now;
}
```

### 3. Input Validation
```javascript
function validateEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

function validatePhone(phone) {
    return /^[\d\s\-\+\(\)]+$/.test(phone);
}

// Use before submitting
if (!validateEmail(formData.email)) {
    alert('Please enter a valid email address');
    return;
}
```

---

## 📧 Email Notifications Options

### Option 1: Zapier Integration (Easiest)
1. Create free Zapier account
2. New Zap: Supabase → Gmail/Email
3. Trigger: New row in contact_submissions
4. Action: Send email to yourself
5. Done! Get notified of all submissions

### Option 2: Supabase Edge Functions + SendGrid
```javascript
// Create edge function in Supabase
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  const { record } = await req.json()
  
  // Send email via SendGrid or similar
  await fetch('https://api.sendgrid.com/v3/mail/send', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${Deno.env.get('SENDGRID_API_KEY')}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      personalizations: [{
        to: [{ email: 'your@email.com' }]
      }],
      from: { email: 'noreply@decahire.com' },
      subject: `New Contact: ${record.name}`,
      content: [{
        type: 'text/plain',
        value: `Name: ${record.name}\nEmail: ${record.email}\nMessage: ${record.message}`
      }]
    })
  })
  
  return new Response('OK')
})
```

### Option 3: Webhook to Your Server
```javascript
// In your contact submission code:
await fetch('YOUR_WEBHOOK_URL', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(formData)
});
```

---

## 🚀 Deployment Checklist

- [ ] Supabase account created
- [ ] Project created and database ready
- [ ] Tables created with proper columns
- [ ] RLS policies configured
- [ ] API keys copied
- [ ] JavaScript code added to index.html
- [ ] Contact form HTML added
- [ ] Tested form submission
- [ ] Submissions appear in Supabase dashboard
- [ ] Email notifications configured (optional)
- [ ] Rate limiting implemented
- [ ] Input validation added
- [ ] Pushed to GitHub
- [ ] Tested on live site

---

## 🔧 Troubleshooting

### Form Not Submitting?
- Check browser console (F12) for errors
- Verify API keys are correct
- Ensure RLS policy allows INSERT
- Check network tab to see API call

### "Failed to fetch" Error?
- Enable CORS in Supabase project settings
- Verify Project URL is correct
- Check if RLS policies are too restrictive

### Data Not Appearing?
- Verify table name matches code
- Check column names match exactly
- Look for errors in Supabase logs (Settings → Logs)

### CORS Issues?
Supabase should handle CORS automatically, but if issues persist:
1. Project Settings → API
2. Scroll to CORS settings
3. Add your domain (and github.io domain)

---

## 💡 Advanced Features

### 1. Real-time Notifications
```javascript
// Listen for new submissions in real-time
const channel = supabase
    .channel('contact-changes')
    .on('postgres_changes', 
        { event: 'INSERT', schema: 'public', table: 'contact_submissions' },
        (payload) => {
            console.log('New submission:', payload.new);
            // Show notification, update dashboard, etc.
        }
    )
    .subscribe();
```

### 2. File Upload (for resumes)
```javascript
// Upload resume to Supabase Storage
async function uploadResume(file) {
    const fileExt = file.name.split('.').pop();
    const fileName = `${Math.random()}.${fileExt}`;
    
    const { data, error } = await supabase.storage
        .from('resumes')
        .upload(fileName, file);
    
    if (error) throw error;
    return data.path;
}
```

### 3. Search and Filter
```javascript
// Search submissions
const { data, error } = await supabase
    .from('contact_submissions')
    .select('*')
    .ilike('name', '%john%')
    .eq('service', 'tech-recruitment')
    .order('created_at', { ascending: false })
    .limit(10);
```

---

## 📈 Analytics Integration

Track form submissions with Google Analytics:

```javascript
// After successful submission
if (typeof gtag !== 'undefined') {
    gtag('event', 'form_submit', {
        'event_category': 'Contact',
        'event_label': 'Contact Form',
        'value': 1
    });
}
```

---

## 💰 Pricing

**Supabase Free Tier:**
- 500MB database space
- 1GB file storage
- 2GB bandwidth
- 50,000 monthly active users
- 500,000 Edge Function invocations

**More than enough for your website!**

Need more? Pro plan starts at $25/month.

---

## ✅ Quick Summary

1. **Setup** (10 min): Create Supabase project & table
2. **Code** (15 min): Add JavaScript & form HTML
3. **Test** (5 min): Submit test form, verify in dashboard
4. **Deploy** (2 min): Push to GitHub, goes live!
5. **Done!** ✅ You now have a database-backed contact form

**Total time:** ~30 minutes for full setup!

---

## 📚 Resources

- Supabase Docs: https://supabase.com/docs
- JavaScript Client: https://supabase.com/docs/reference/javascript
- RLS Guide: https://supabase.com/docs/guides/auth/row-level-security
- Edge Functions: https://supabase.com/docs/guides/functions

---

Need help? Check the Supabase documentation or their Discord community!
