// ==========================================
// DECAHIRE - MAIN JAVASCRIPT
// Contact Form & Modal Functionality
// ==========================================

// Supabase Configuration
const SUPABASE_URL = 'https://xabfzikbvvppdcrijmrw.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhhYmZ6aWtidnZwcGRjcmlqbXJ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMwMDA3MDYsImV4cCI6MjA3ODU3NjcwNn0.xsSS5MQ06WQdcXwA8pkh95zTNkyAVI_TOS-7lNl0snU';
const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// ==========================================
// MODAL FUNCTIONS
// ==========================================

/**
 * Open contact modal
 * @param {string} service - Pre-selected service (optional)
 */
function openContactModal(service = '') {
    const modal = document.getElementById('contactModal');
    modal.classList.add('active');
    document.body.style.overflow = 'hidden';
    
    if (service) {
        document.getElementById('popup-service').value = service;
    }
    
    setTimeout(() => {
        document.getElementById('popup-name').focus();
    }, 300);
}

/**
 * Close contact modal
 */
function closeContactModal() {
    const modal = document.getElementById('contactModal');
    modal.classList.remove('active');
    document.body.style.overflow = '';
    
    // Reset form
    document.getElementById('popupContactForm').reset();
    
    // Hide any messages
    const messageEl = document.getElementById('popup-form-message');
    messageEl.className = 'form-message';
}

// ==========================================
// EVENT LISTENERS
// ==========================================

// Close modal when clicking outside
document.getElementById('contactModal')?.addEventListener('click', function(e) {
    if (e.target === this) {
        closeContactModal();
    }
});

// Close modal with Escape key
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeContactModal();
    }
});

// ==========================================
// FORM VALIDATION & SUBMISSION
// ==========================================

// Rate limiting
let lastSubmitTime = 0;
const COOLDOWN_MS = 30000; // 30 seconds

/**
 * Validate email format
 * @param {string} email - Email to validate
 * @returns {boolean}
 */
function validateEmail(email) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

/**
 * Show form message
 * @param {string} message - Message to display
 * @param {boolean} isSuccess - Success or error
 */
function showMessage(message, isSuccess) {
    const messageEl = document.getElementById('popup-form-message');
    messageEl.textContent = message;
    messageEl.className = 'form-message ' + (isSuccess ? 'success' : 'error') + ' show';
    
    if (isSuccess) {
        setTimeout(() => {
            closeContactModal();
        }, 3000);
    }
}

// Form submission handler
document.getElementById('popupContactForm')?.addEventListener('submit', async function(e) {
    e.preventDefault();
    
    // Rate limiting check
    const now = Date.now();
    if (now - lastSubmitTime < COOLDOWN_MS) {
        const waitSeconds = Math.ceil((COOLDOWN_MS - (now - lastSubmitTime)) / 1000);
        showMessage(`Please wait ${waitSeconds} seconds before submitting again`, false);
        return;
    }
    
    // Collect form data
    const formData = {
        name: document.getElementById('popup-name').value.trim(),
        email: document.getElementById('popup-email').value.trim(),
        company: document.getElementById('popup-company').value.trim() || null,
        phone: document.getElementById('popup-phone').value.trim() || null,
        service: document.getElementById('popup-service').value,
        message: document.getElementById('popup-message').value.trim(),
        status: 'new'
    };
    
    // Validation
    if (!validateEmail(formData.email)) {
        showMessage('Please enter a valid email address', false);
        return;
    }
    
    if (formData.message.length < 10) {
        showMessage('Please provide more details in your message (minimum 10 characters)', false);
        return;
    }
    
    // Show loading state
    const submitBtn = document.getElementById('popup-submit-btn');
    const originalText = submitBtn.textContent;
    submitBtn.textContent = 'Sending...';
    submitBtn.disabled = true;
    
    try {
        // Submit to Supabase
        const { data, error } = await supabase
            .from('contact_submissions')
            .insert([formData])
            .select();
        
        if (error) throw new Error(error.message);
        
        // Success
        showMessage('Thank you! We will contact you within 24 hours.', true);
        e.target.reset();
        lastSubmitTime = now;
        
    } catch (error) {
        console.error('Submission error:', error);
        showMessage('Something went wrong. Please email us at hire@decahire.com', false);
    } finally {
        // Restore button state
        submitBtn.textContent = originalText;
        submitBtn.disabled = false;
    }
});

// ==========================================
// CTA BUTTON HANDLERS
// ==========================================

document.addEventListener('DOMContentLoaded', function() {
    // Find all CTA buttons
    const ctaButtons = document.querySelectorAll('a.cta-button, a[href="#contact"]');
    
    ctaButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Determine which service to pre-select based on context
            let service = '';
            const buttonText = this.textContent.toLowerCase();
            const sectionId = this.closest('section')?.id || '';
            
            // Map button context to service
            if (buttonText.includes('technology talent') || buttonText.includes('technical talent') || sectionId === 'tech-recruitment') {
                service = 'tech-recruitment';
            } else if (buttonText.includes('leader') || buttonText.includes('executive') || sectionId === 'executive-search') {
                service = 'executive-search';
            } else if (buttonText.includes('contract') || buttonText.includes('staffing') || sectionId === 'contract-hiring') {
                service = 'contract-hiring';
            } else if (buttonText.includes('advisory') || buttonText.includes('consultation') || sectionId === 'talent-advisory') {
                service = 'talent-advisory';
            } else if (buttonText.includes('partner')) {
                service = 'partnership';
            } else {
                service = 'general-inquiry';
            }
            
            openContactModal(service);
        });
    });
    
    console.log('✅ DecaHire initialized!', ctaButtons.length, 'CTA buttons connected');
});

// ==========================================
// SMOOTH SCROLLING (Optional Enhancement)
// ==========================================

document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
        const href = this.getAttribute('href');
        
        // Skip if it's just "#contact" (handled by modal)
        if (href === '#contact') return;
        
        // Skip if it's just "#"
        if (href === '#') {
            e.preventDefault();
            return;
        }
        
        const target = document.querySelector(href);
        if (target) {
            e.preventDefault();
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});
