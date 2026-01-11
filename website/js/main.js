/**
 * Ndmr Website - Main JavaScript
 */

document.addEventListener('DOMContentLoaded', () => {
    // Mobile navigation toggle
    const navToggle = document.querySelector('.nav-toggle');
    const navLinks = document.querySelector('.nav-links');

    if (navToggle && navLinks) {
        navToggle.addEventListener('click', () => {
            navLinks.classList.toggle('active');
            navToggle.classList.toggle('active');
        });
    }

    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                const navHeight = document.querySelector('.nav').offsetHeight;
                const targetPosition = target.getBoundingClientRect().top + window.pageYOffset - navHeight;
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
            }
        });
    });

    // Intersection Observer for fade-in animations
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
            }
        });
    }, observerOptions);

    document.querySelectorAll('.feature-card, .screenshot-card, .radio-card').forEach(el => {
        el.classList.add('fade-in');
        observer.observe(el);
    });

    // Add CSS for fade-in animation
    const style = document.createElement('style');
    style.textContent = `
        .fade-in {
            opacity: 0;
            transform: translateY(20px);
            transition: opacity 0.5s ease, transform 0.5s ease;
        }
        .fade-in.visible {
            opacity: 1;
            transform: translateY(0);
        }
        @media (max-width: 768px) {
            .nav-links.active {
                display: flex;
                flex-direction: column;
                position: absolute;
                top: 64px;
                left: 0;
                right: 0;
                background: var(--color-bg);
                padding: 1rem;
                border-bottom: 1px solid var(--color-border);
                gap: 1rem;
            }
            .nav-toggle.active span:nth-child(1) {
                transform: rotate(45deg) translate(5px, 5px);
            }
            .nav-toggle.active span:nth-child(2) {
                opacity: 0;
            }
            .nav-toggle.active span:nth-child(3) {
                transform: rotate(-45deg) translate(5px, -5px);
            }
        }
    `;
    document.head.appendChild(style);

    // Platform detection for download buttons
    const detectPlatform = () => {
        const userAgent = navigator.userAgent.toLowerCase();
        if (userAgent.includes('win')) return 'windows';
        if (userAgent.includes('mac')) return 'macos';
        if (userAgent.includes('linux')) return 'linux';
        if (userAgent.includes('android')) return 'android';
        if (userAgent.includes('iphone') || userAgent.includes('ipad')) return 'ios';
        return 'unknown';
    };

    // Highlight the user's platform download button
    const platform = detectPlatform();
    const downloadButtons = document.querySelectorAll('.btn-download');
    downloadButtons.forEach(btn => {
        const btnPlatform = btn.querySelector('.dl-platform').textContent.toLowerCase();
        if (btnPlatform === platform) {
            btn.style.background = 'rgba(255, 255, 255, 0.3)';
            btn.style.border = '2px solid rgba(255, 255, 255, 0.5)';
        }
    });

    // Feedback form handling
    initFeedbackForm();
});

// Feedback API endpoint (update after deploying Lambda)
const FEEDBACK_API_URL = 'https://t3jc17asx5.execute-api.eu-west-3.amazonaws.com/feedback';

/**
 * Initialize feedback form
 */
function initFeedbackForm() {
    const form = document.getElementById('feedback-form');
    if (!form) return;

    form.addEventListener('submit', async (e) => {
        e.preventDefault();
        await submitFeedback(form);
    });
}

/**
 * Submit feedback to API
 */
async function submitFeedback(form) {
    const submitBtn = document.getElementById('submit-btn');
    const sendIcon = submitBtn.querySelector('.send-icon');
    const loadingIcon = submitBtn.querySelector('.loading-icon');
    const statusDiv = document.getElementById('form-status');

    // Get form data
    const formData = {
        name: form.querySelector('#feedback-name').value.trim(),
        callsign: form.querySelector('#feedback-callsign').value.trim(),
        email: form.querySelector('#feedback-email').value.trim(),
        type: form.querySelector('#feedback-type').value,
        message: form.querySelector('#feedback-message').value.trim(),
        source: 'website'
    };

    // Validate
    if (!formData.name || !formData.email || !formData.message) {
        showStatus(statusDiv, 'error', getStatusMessage('error', 'required'));
        return;
    }

    // Show loading state
    submitBtn.disabled = true;
    sendIcon.style.display = 'none';
    loadingIcon.style.display = 'inline';
    statusDiv.className = 'form-status';
    statusDiv.style.display = 'none';

    try {
        const response = await fetch(FEEDBACK_API_URL, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(formData)
        });

        const result = await response.json();

        if (response.ok && result.success) {
            showStatus(statusDiv, 'success', getStatusMessage('success'));
            form.reset();
        } else {
            showStatus(statusDiv, 'error', getStatusMessage('error', 'server'));
        }
    } catch (error) {
        console.error('Feedback error:', error);
        showStatus(statusDiv, 'error', getStatusMessage('error', 'network'));
    } finally {
        // Reset button state
        submitBtn.disabled = false;
        sendIcon.style.display = 'inline';
        loadingIcon.style.display = 'none';
    }
}

/**
 * Show status message
 */
function showStatus(statusDiv, type, message) {
    statusDiv.textContent = message;
    statusDiv.className = `form-status ${type}`;
}

/**
 * Get localized status message
 */
function getStatusMessage(type, subtype) {
    const messages = {
        success: {
            fr: 'Message envoyé avec succès ! Merci pour votre retour.',
            en: 'Message sent successfully! Thank you for your feedback.',
            es: '¡Mensaje enviado con éxito! Gracias por tu comentario.',
            pt: 'Mensagem enviada com sucesso! Obrigado pelo seu feedback.',
            it: 'Messaggio inviato con successo! Grazie per il tuo feedback.',
            de: 'Nachricht erfolgreich gesendet! Vielen Dank für Ihr Feedback.',
            uk: 'Повідомлення успішно надіслано! Дякуємо за ваш відгук.'
        },
        error: {
            required: {
                fr: 'Veuillez remplir tous les champs obligatoires.',
                en: 'Please fill in all required fields.',
                es: 'Por favor, complete todos los campos obligatorios.',
                pt: 'Por favor, preencha todos os campos obrigatórios.',
                it: 'Si prega di compilare tutti i campi obbligatori.',
                de: 'Bitte füllen Sie alle erforderlichen Felder aus.',
                uk: 'Будь ласка, заповніть усі обов\'язкові поля.'
            },
            network: {
                fr: 'Erreur réseau. Veuillez réessayer.',
                en: 'Network error. Please try again.',
                es: 'Error de red. Por favor, inténtelo de nuevo.',
                pt: 'Erro de rede. Por favor, tente novamente.',
                it: 'Errore di rete. Si prega di riprovare.',
                de: 'Netzwerkfehler. Bitte versuchen Sie es erneut.',
                uk: 'Помилка мережі. Будь ласка, спробуйте ще раз.'
            },
            server: {
                fr: 'Erreur serveur. Veuillez réessayer plus tard.',
                en: 'Server error. Please try again later.',
                es: 'Error del servidor. Por favor, inténtelo más tarde.',
                pt: 'Erro do servidor. Por favor, tente novamente mais tarde.',
                it: 'Errore del server. Si prega di riprovare più tardi.',
                de: 'Serverfehler. Bitte versuchen Sie es später erneut.',
                uk: 'Помилка сервера. Будь ласка, спробуйте пізніше.'
            }
        }
    };

    const lang = window.i18n ? window.i18n.currentLang() : 'en';

    if (type === 'success') {
        return messages.success[lang] || messages.success.en;
    } else if (type === 'error' && subtype) {
        return messages.error[subtype][lang] || messages.error[subtype].en;
    }

    return 'An error occurred.';
}
