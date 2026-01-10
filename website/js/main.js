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
});
