<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>Ocean View Resort | Your Paradise Awaits</title>

<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
/* ===== Modern Reset & Global Style ===== */
:root {
    --teal-accent: #2dd4bf;
    --blue-accent: #3b82f6;
    --glass: rgba(15, 23, 42, 0.82);
}

body, html {
    margin: 0; padding: 0;
    width: 100%; height: 100%;
    font-family: 'Plus Jakarta Sans', sans-serif;
    background-color: #020617;
    color: white;
    overflow: hidden;
    display: flex;
    justify-content: center;
    align-items: center;
}

/* ===== CINEMATIC BACKGROUND ===== */
.hero-bg {
    position: fixed; inset: 0;
    background: linear-gradient(rgba(15,23,42,0.45), rgba(15,23,42,0.75)),
                url("https://images.unsplash.com/photo-1506929113614-bb4885828c50?auto=format&fit=crop&w=1920&q=80");
    background-size: cover;
    background-position: center;
    z-index: -2;
    animation: kenBurns 50s infinite alternate ease-in-out;
}

@keyframes kenBurns {
    0%   { transform: scale(1.00)   translate(0, 0); }
    100% { transform: scale(1.085)  translate(2%, 1.5%); }
}

/* ===== Softer, more elegant floating auras ===== */
.aura {
    position: absolute; border-radius: 50%; z-index: -1; filter: blur(90px); opacity: 0.7;
    animation: auraDrift 28s infinite ease-in-out alternate;
}
.aura-1 { width: 45vw; height: 45vw; background: rgba(45,212,191,0.18); top: -18%; left: -15%; }
.aura-2 { width: 38vw; height: 38vw; background: rgba(59,130,246,0.16); bottom: -12%; right: -12%; animation-delay: -14s; }

@keyframes auraDrift {
    0%   { transform: translate(0, 0)   scale(1); }
    100% { transform: translate(8vw, 6vh) scale(1.12); }
}

/* ===== Very subtle background sparkle ===== */
.sparkles {
    position: fixed; inset: 0; pointer-events: none; z-index: -1; overflow: hidden;
}
.sparkle {
    position: absolute;
    background: white;
    border-radius: 50%;
    opacity: 0;
    animation: twinkle 12s infinite;
}
@keyframes twinkle {
    0%,100% { opacity: 0; transform: scale(0); }
    50%     { opacity: 0.25; transform: scale(1); }
}

/* ===== MAIN CARD ===== */
.welcome-card {
    background: var(--glass);
    backdrop-filter: blur(32px);
    -webkit-backdrop-filter: blur(32px);
    border: 1px solid rgba(255,255,255,0.09);
    border-radius: 2.8rem;
    padding: 3.5vh 4vw;
    width: 90%; max-width: 820px;
    max-height: 92vh;
    text-align: center;
    box-shadow: 0 60px 140px -30px rgba(0,0,0,0.75);
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    opacity: 0;
    transform: translateY(40px) scale(0.96);
    animation: cardReveal 1.8s cubic-bezier(0.23, 1, 0.32, 1) 0.3s forwards;
}

@keyframes cardReveal {
    to { opacity: 1; transform: translateY(0) scale(1); }
}

/* Logo with breathing + glow */
.brand-logo {
    font-size: clamp(3.5rem, 9vh, 5.8rem);
    filter: drop-shadow(0 0 30px rgba(45,212,191,0.45));
    animation: 
        floatLogo 6s ease-in-out infinite,
        gentleBreath 8s ease-in-out infinite;
}

@keyframes floatLogo {
    0%,100% { transform: translateY(0); }
    50%     { transform: translateY(-18px); }
}
@keyframes gentleBreath {
    0%,100% { filter: drop-shadow(0 0 30px rgba(45,212,191,0.45)); }
    50%     { filter: drop-shadow(0 0 50px rgba(45,212,191,0.65)); }
}

/* Title shine + scale subtle */
h1 {
    font-size: clamp(2.2rem, 7vh, 4.5rem);
    margin: 0.4rem 0;
    font-weight: 800;
    letter-spacing: -2.2px;
    background: linear-gradient(90deg, #ffffff, var(--teal-accent), var(--blue-accent), #ffffff);
    background-size: 300% auto;
    -webkit-background-clip: text;
    background-clip: text;
    -webkit-text-fill-color: transparent;
    animation: shine 7s linear infinite;
    transform: scale(0.95);
    opacity: 0;
    animation: titlePop 1.4s cubic-bezier(0.34, 1.56, 0.64, 1) 0.7s forwards;
}

@keyframes titlePop {
    to { transform: scale(1); opacity: 1; }
}

@keyframes shine {
    to { background-position: 300% center; }
}

h2 {
    font-size: clamp(0.75rem, 2.2vh, 1rem);
    letter-spacing: 12px;
    color: var(--teal-accent);
    text-transform: uppercase;
    margin-bottom: 1.6rem;
    opacity: 0;
    animation: fadeInUp 1.2s ease-out 1.1s forwards;
}

/* Description fade */
.description {
    font-size: clamp(0.95rem, 2.6vh, 1.15rem);
    line-height: 1.65;
    color: #c7d2fe;
    max-width: 620px;
    margin-bottom: 2.4rem;
    opacity: 0;
    transform: translateY(20px);
    animation: fadeInUp 1.3s ease-out 1.4s forwards;
}

@keyframes fadeInUp {
    to { opacity: 1; transform: translateY(0); }
}

/* ===== BUTTONS ===== */
.cta-group {
    display: flex; gap: 1.2rem; flex-wrap: wrap; justify-content: center;
    opacity: 0;
    animation: fadeInUp 1.4s ease-out 1.7s forwards;
}

.btn {
    padding: 1.1rem 2.8rem;
    border-radius: 100px;
    text-decoration: none;
    font-weight: 700;
    font-size: 0.98rem;
    display: flex; align-items: center; gap: 12px;
    transition: all 0.45s cubic-bezier(0.34, 1.56, 0.64, 1);
    position: relative;
    overflow: hidden;
}

.btn::after {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.25), transparent);
    transform: translateX(-100%);
    transition: transform 0.6s ease;
}

.btn:hover::after { transform: translateX(100%); }

.btn-primary {
    background: var(--teal-accent);
    color: #020617;
    box-shadow: 0 12px 24px rgba(45,212,191,0.28);
}

.btn-primary:hover {
    transform: translateY(-4px) scale(1.06);
    box-shadow: 0 20px 40px rgba(45,212,191,0.45);
}

.btn-outline {
    background: rgba(255,255,255,0.06);
    color: white;
    border: 1px solid rgba(255,255,255,0.18);
}

.btn-outline:hover {
    background: rgba(255,255,255,0.14);
    border-color: rgba(255,255,255,0.6);
    transform: translateY(-3px);
}

/* ===== FEATURE CARDS ===== */
.features {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 1.2rem;
    width: 100%;
    margin-top: 2.8rem;
    opacity: 0;
    animation: fadeInUp 1.5s ease-out 2s forwards;
}

.feature-item {
    padding: 1.3rem 0.8rem;
    background: rgba(255,255,255,0.035);
    border-radius: 1.6rem;
    border: 1px solid rgba(255,255,255,0.06);
    transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
    opacity: 0;
    transform: translateY(30px);
}

.feature-item:nth-child(1) { animation: featurePop 0.9s ease-out 2.4s forwards; }
.feature-item:nth-child(2) { animation: featurePop 0.9s ease-out 2.55s forwards; }
.feature-item:nth-child(3) { animation: featurePop 0.9s ease-out 2.7s forwards; }
.feature-item:nth-child(4) { animation: featurePop 0.9s ease-out 2.85s forwards; }

@keyframes featurePop {
    to { opacity: 1; transform: translateY(0); }
}

.feature-item:hover {
    background: rgba(45,212,191,0.14);
    transform: translateY(-8px) scale(1.04);
    border-color: var(--teal-accent);
    box-shadow: 0 15px 35px rgba(45,212,191,0.25);
}

.feature-item i {
    font-size: 1.8rem;
    color: var(--teal-accent);
    margin-bottom: 0.6rem;
    transition: transform 0.4s ease;
}

.feature-item:hover i {
    transform: scale(1.15) rotate(8deg);
}

.feature-item h3 {
    font-size: 0.78rem;
    letter-spacing: 1.2px;
    color: #94a3b8;
    margin: 0;
}

/* Footer */
.footer-note {
    margin-top: 2.5rem;
    font-size: 0.82rem;
    color: #64748b;
    border-top: 1px solid rgba(255,255,255,0.08);
    padding-top: 1.6rem;
    width: 100%;
}

/* Responsive adjustments */
@media (max-height: 700px) {
    .features { display: none; }
    .description { margin-bottom: 1.2rem; }
}

@media (max-width: 600px) {
    .features { grid-template-columns: repeat(2, 1fr); gap: 1rem; }
    .btn { width: 100%; justify-content: center; }
}
</style>
</head>

<body>

<div class="hero-bg"></div>
<div class="aura aura-1"></div>
<div class="aura aura-2"></div>

<!-- Very subtle sparkles -->
<div class="sparkles" aria-hidden="true">
    <div class="sparkle" style="width:2px;height:2px;top:15%;left:18%;animation-delay:0s;"></div>
    <div class="sparkle" style="width:1.5px;height:1.5px;top:28%;left:72%;animation-delay:2.3s;"></div>
    <div class="sparkle" style="width:2px;height:2px;top:65%;left:12%;animation-delay:4.8s;"></div>
    <div class="sparkle" style="width:1.8px;height:1.8px;top:42%;left:88%;animation-delay:7.1s;"></div>
    <div class="sparkle" style="width:2.2px;height:2.2px;top:80%;left:35%;animation-delay:9.6s;"></div>
</div>

<div class="welcome-card">
    <span class="brand-logo">🏖️</span>

    <h1>OceanView</h1>
    <h2>Luxury Resort </h2>

    <p class="description">
        Experience a world where the sapphire sky meets the emerald sea. 
        Your journey to paradise starts with a single click.
    </p>

    <div class="cta-group">
        <a href="login.jsp" class="btn btn-primary">
            <i class="fas fa-door-open"></i> Enter Resort
        </a>
        <a href="help.jsp" class="btn btn-outline">
            <i class="fas fa-question-circle"></i> Need Help?
        </a>
    </div>

    <div class="features">
        <div class="feature-item">
            <i class="fas fa-bed"></i>
            <h3>Luxury</h3>
        </div>
        <div class="feature-item">
            <i class="fas fa-shield-alt"></i>
            <h3>Secure</h3>
        </div>
        <div class="feature-item">
            <i class="fas fa-swimmer"></i>
            <h3>Infinity</h3>
        </div>
        <div class="feature-item">
            <i class="fas fa-concierge-bell"></i>
            <h3>Service</h3>
        </div>
    </div>

    <div class="footer-note">
        <p style="margin-bottom:8px;">Excellence defined. Paradise found.</p>
        <p>
            <i class="fas fa-phone-alt"></i> +94 76 3689100 |  
            <a href="mailto:aseemulhaq@gmail.com" style="color: var(--teal-accent); text-decoration: none;">
                aseemaseemulhaq@gmail.com
            </a>
        </p>
    </div>
</div>

<script>
// Smoother & damped parallax tilt
const card = document.querySelector('.welcome-card');
let currentX = 0, currentY = 0;
let targetX = 0, targetY = 0;

function updateTilt() {
    currentX += (targetX - currentX) * 0.08;
    currentY += (targetY - currentY) * 0.08;
    card.style.transform = `perspective(1200px) rotateY(${currentX}deg) rotateX(${currentY}deg)`;
    requestAnimationFrame(updateTilt);
}

document.addEventListener('mousemove', (e) => {
    targetX = (window.innerWidth / 2 - e.pageX) / 65;
    targetY = (window.innerHeight / 2 - e.pageY) / 65;
});

requestAnimationFrame(updateTilt);
</script>

</body>
</html>