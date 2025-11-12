# DecaHire Website - GitHub Pages Setup Guide

## 📋 Quick Overview
This guide will help you:
1. Set up GitHub Pages hosting (FREE)
2. Add your logo to the website
3. Replace Unsplash placeholder images with your own

---

## 🚀 PART 1: GitHub Pages Setup (10 minutes)

### Step 1: Create GitHub Account
1. Go to https://github.com
2. Click "Sign up" (if you don't have an account)
3. Choose a username (e.g., `decahire` or your name)

### Step 2: Create Repository
1. Click the **"+"** icon in top right → **"New repository"**
2. **Repository name**: `decahire-website` (or any name you prefer)
3. **Description**: "DecaHire recruitment website"
4. Make it **Public** (required for free GitHub Pages)
5. Check **"Add a README file"**
6. Click **"Create repository"**

### Step 3: Upload Website Files
1. In your new repository, click **"Add file"** → **"Upload files"**
2. Drag and drop these files from this folder:
   - `index.html`
   - The entire `images` folder (with your logo inside)
3. Add a commit message: "Initial website upload"
4. Click **"Commit changes"**

### Step 4: Enable GitHub Pages
1. In your repository, click **"Settings"** tab
2. Scroll down to **"Pages"** in the left sidebar
3. Under "Source":
   - Select **"Deploy from a branch"**
   - Branch: **"main"** (or "master")
   - Folder: **"/ (root)"**
4. Click **"Save"**
5. Wait 2-3 minutes for deployment

### Step 5: View Your Website
Your site will be live at:
```
https://YOUR-USERNAME.github.io/decahire-website/
```
For example: `https://decahire.github.io/decahire-website/`

---

## 🎨 PART 2: Add Your Logo

### Option A: Using GitHub Web Interface (Easiest)
1. In your repository, click on the `images` folder
2. Click **"Add file"** → **"Upload files"**
3. Upload your logo file and name it **`logo.png`**
4. Commit the changes
5. Wait 1-2 minutes, then refresh your website

### Option B: Using Your Computer
1. Clone the repository:
   ```bash
   git clone https://github.com/YOUR-USERNAME/decahire-website.git
   cd decahire-website
   ```
2. Copy your logo to the `images` folder and name it `logo.png`
3. Push changes:
   ```bash
   git add images/logo.png
   git commit -m "Add DecaHire logo"
   git push
   ```

### Logo Requirements:
- **Name**: Must be named `logo.png` (or update `index.html` if different)
- **Format**: PNG with transparent background (recommended) or JPG
- **Size**: Recommended 200-400px width, height will auto-scale
- **File size**: Keep under 100KB for fast loading

---

## 🖼️ PART 3: Replace Unsplash Images

The website currently uses 11 placeholder images from Unsplash. Here's how to replace them:

### Step 1: Prepare Your Images
You need images for these sections:

| Image Purpose | Current File Name | Recommended Size | Description |
|--------------|------------------|------------------|-------------|
| Hero Banner | `hero.jpg` | 1200×500px | Main banner image showing modern tech/office |
| How We Work | `how-we-work.jpg` | 1200×400px | Team collaboration or process |
| Tech Recruitment | `tech-recruitment.jpg` | 1200×500px | Developers coding |
| Executive Search | `executive-search.jpg` | 1200×500px | Leadership/boardroom |
| Contract Hiring | `contract-hiring.jpg` | 1200×500px | Flexible work environment |
| Talent Advisory | `talent-advisory.jpg` | 1200×500px | Strategic planning |
| Product Feature 1 | `feature-1.jpg` | 800×600px | AI/automation visual |
| Product Feature 2 | `feature-2.jpg` | 800×600px | Dashboard/analytics |
| Product Feature 3 | `feature-3.jpg` | 800×600px | Team/collaboration |
| CTA Image 1 | `cta-1.jpg` | 500×500px | Team collaboration |
| CTA Image 2 | `cta-2.jpg` | 500×500px | Modern office |
| CTA Image 3 | `cta-3.jpg` | 500×500px | Team meeting |

### Step 2: Upload Images
1. Save your images with the names above
2. In GitHub, navigate to `images` folder
3. Click **"Add file"** → **"Upload files"**
4. Upload all your images
5. Commit changes

### Step 3: Update HTML (IMPORTANT!)
After uploading, you need to update `index.html` to point to your new images.

**I've created a helper file** `IMAGE_REPLACEMENT_GUIDE.txt` that shows you exactly which lines to change.

---

## 🌐 PART 4: Connect Your Custom Domain

### If You Own a Domain (e.g., decahire.com):

1. In your repository, go to **Settings** → **Pages**
2. Under "Custom domain", enter your domain: `www.decahire.com`
3. Click **"Save"**
4. In your domain registrar (where you bought the domain), add these DNS records:

   **For www.decahire.com:**
   ```
   Type: CNAME
   Name: www
   Value: YOUR-USERNAME.github.io
   TTL: 3600
   ```

   **For decahire.com (root domain):**
   ```
   Type: A
   Name: @
   Values: 
   185.199.108.153
   185.199.109.153
   185.199.110.153
   185.199.111.153
   ```

5. Wait 15-60 minutes for DNS propagation
6. Check **"Enforce HTTPS"** in GitHub Pages settings

### Popular Domain Registrars Instructions:
- **GoDaddy**: DNS Management → Add Records
- **Namecheap**: Advanced DNS → Add New Record
- **Google Domains**: DNS → Custom records
- **Cloudflare**: DNS → Add Record

---

## 🔧 Troubleshooting

### Website Not Loading?
- Wait 3-5 minutes after first deployment
- Check Settings → Pages shows green checkmark
- Clear browser cache (Ctrl+Shift+R or Cmd+Shift+R)

### Images Not Showing?
- Check image filenames match exactly (case-sensitive)
- Ensure images are in the `images` folder
- Check file extensions (.png vs .jpg)

### Logo Too Big/Small?
Edit `index.html`, find line with `.logo {` and change:
```css
.logo {
    height: 40px;  /* Change this number */
}
```

### Custom Domain Not Working?
- DNS changes take 15-60 minutes
- Use https://dnschecker.org to verify propagation
- Make sure CNAME file exists in repository root
- Check your domain registrar's DNS settings

---

## 📝 Quick Commands Cheat Sheet

```bash
# Clone repository
git clone https://github.com/YOUR-USERNAME/decahire-website.git

# Add changes
git add .

# Commit changes
git commit -m "Your message here"

# Push to GitHub
git push

# Check status
git status
```

---

## ✅ Next Steps Checklist

- [ ] GitHub account created
- [ ] Repository created and set to Public
- [ ] Files uploaded (index.html + images folder)
- [ ] GitHub Pages enabled
- [ ] Website loads at github.io URL
- [ ] Logo uploaded and displays correctly
- [ ] Placeholder images identified
- [ ] Your images prepared and uploaded
- [ ] HTML updated to reference your images
- [ ] Custom domain configured (optional)
- [ ] HTTPS enforced

---

## 🆘 Need Help?

Common resources:
- **GitHub Pages Docs**: https://docs.github.com/pages
- **GitHub Support**: https://support.github.com
- **DNS Help**: Contact your domain registrar

---

## 📧 File Overview

Your website structure:
```
decahire-website/
├── index.html                  (Your main website file)
├── images/
│   ├── logo.png               (Your logo - ADD THIS)
│   ├── hero.jpg               (Replace these with your images)
│   ├── tech-recruitment.jpg
│   └── ... (other images)
├── SETUP_GUIDE.md             (This file)
└── IMAGE_REPLACEMENT_GUIDE.txt (Detailed line-by-line instructions)
```

---

**You're all set!** Follow these steps in order and you'll have your website live in under 15 minutes. 🎉
