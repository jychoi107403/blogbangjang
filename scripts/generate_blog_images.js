// scripts/generate_blog_images.js
// 9장의 블로그 일러스트 SVG를 생성하고 sharp-cli로 WebP 변환하는 자동화 스크립트
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const OUTPUT_DIR = path.join(__dirname, '..', 'public', 'blog');
const SCRATCH_DIR = path.join(__dirname, 'temp_svgs');

if (!fs.existsSync(SCRATCH_DIR)) {
  fs.mkdirSync(SCRATCH_DIR, { recursive: true });
}

// 1. Cloudflare Next.js Free Deploy - Cover (1200x630)
const svg_cf_cover = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 630" width="1200" height="630">
  <defs>
    <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#0a0e17" />
      <stop offset="50%" stop-color="#141c2e" />
      <stop offset="100%" stop-color="#1e110a" />
    </linearGradient>
    <linearGradient id="cf_grad" x1="0%" y1="0%" x2="100%" y2="50%">
      <stop offset="0%" stop-color="#f38020" />
      <stop offset="100%" stop-color="#faad3f" />
    </linearGradient>
    <linearGradient id="rocket_grad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#ffffff" />
      <stop offset="100%" stop-color="#cbd5e1" />
    </linearGradient>
    <linearGradient id="flame_grad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" stop-color="#f97316" />
      <stop offset="100%" stop-color="#ef4444" />
    </linearGradient>
    <radialGradient id="glow" cx="50%" cy="50%" r="50%">
      <stop offset="0%" stop-color="#f38020" stop-opacity="0.3" />
      <stop offset="100%" stop-color="#f38020" stop-opacity="0" />
    </radialGradient>
    <pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse">
      <path d="M 40 0 L 0 0 0 40" fill="none" stroke="#334155" stroke-width="1" stroke-opacity="0.2" />
    </pattern>
  </defs>

  <!-- Background -->
  <rect width="1200" height="630" fill="url(#bg)" />
  <rect width="1200" height="630" fill="url(#grid)" />

  <!-- Ambient Glow -->
  <circle cx="600" cy="315" r="400" fill="url(#glow)" />

  <!-- Global Edge Network Orbit Ring -->
  <ellipse cx="600" cy="330" rx="420" ry="180" fill="none" stroke="#f38020" stroke-width="2" stroke-opacity="0.3" stroke-dasharray="8 8" />
  <ellipse cx="600" cy="330" rx="280" ry="120" fill="none" stroke="#38bdf8" stroke-width="1.5" stroke-opacity="0.4" />

  <!-- Orbiting Edge Nodes -->
  <circle cx="240" cy="270" r="8" fill="#f38020" />
  <circle cx="240" cy="270" r="16" fill="none" stroke="#f38020" stroke-opacity="0.4" stroke-width="2" />
  
  <circle cx="960" cy="390" r="8" fill="#38bdf8" />
  <circle cx="960" cy="390" r="16" fill="none" stroke="#38bdf8" stroke-opacity="0.4" stroke-width="2" />

  <circle cx="420" cy="450" r="6" fill="#f59e0b" />
  <circle cx="780" cy="210" r="6" fill="#38bdf8" />

  <!-- Cloudflare Cloud Shape in Center -->
  <g transform="translate(600, 310)">
    <!-- Base Cloud Shadow -->
    <path d="M -160,50 A 70,70 0 0,1 -60,-20 A 100,100 0 0,1 100,-30 A 80,80 0 0,1 170,50 Z" fill="#0f172a" opacity="0.6" />
    <!-- Gradient Cloud -->
    <path d="M -150,40 A 65,65 0 0,1 -55,-25 A 95,95 0 0,1 95,-35 A 75,75 0 0,1 160,40 Z" fill="url(#cf_grad)" />
    
    <!-- Cloud Highlight Waves -->
    <path d="M -110,40 A 45,45 0 0,1 -40, -5 A 75,75 0 0,1 80,-15" fill="none" stroke="#ffffff" stroke-width="5" stroke-linecap="round" opacity="0.4" />
  </g>

  <!-- Launching Rocket -->
  <g transform="translate(600, 240) rotate(-35)">
    <!-- Rocket Thruster Flame -->
    <path d="M -15,80 Q 0,140 15,80 Z" fill="url(#flame_grad)" />
    <path d="M -8,80 Q 0,115 8,80 Z" fill="#fef08a" />

    <!-- Rocket Fins -->
    <path d="M -30,65 L -18,40 L -18,75 Z" fill="#e11d48" />
    <path d="M 30,65 L 18,40 L 18,75 Z" fill="#e11d48" />

    <!-- Rocket Body -->
    <path d="M 0,-70 C 25,-40 25,50 20,80 L -20,80 C -25,50 -25,-40 0,-70 Z" fill="url(#rocket_grad)" />
    <!-- Rocket Nose Cone -->
    <path d="M 0,-70 C 15,-50 18,-30 18,-20 L -18,-20 C -18,-30 -15,-50 0,-70 Z" fill="#f43f5e" />
    
    <!-- Porthole Window -->
    <circle cx="0" cy="10" r="14" fill="#0284c7" />
    <circle cx="0" cy="10" r="10" fill="#38bdf8" />
    <circle cx="-3" cy="7" r="4" fill="#ffffff" opacity="0.8" />
  </g>

  <!-- Speed Particles -->
  <line x1="520" y1="360" x2="480" y2="420" stroke="#f38020" stroke-width="3" stroke-linecap="round" opacity="0.6" />
  <line x1="680" y1="180" x2="720" y2="120" stroke="#38bdf8" stroke-width="3" stroke-linecap="round" opacity="0.6" />
  <line x1="750" y1="260" x2="810" y2="230" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" opacity="0.4" />
</svg>
`;

// 2. Cloudflare Next.js Free Deploy - 01 (960x540) CI/CD & Edge Pipeline
const svg_cf_01 = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 540" width="960" height="540">
  <defs>
    <linearGradient id="bg_cf1" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#0b1120" />
      <stop offset="100%" stop-color="#1e293b" />
    </linearGradient>
    <linearGradient id="node_git" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#f43f5e" />
      <stop offset="100%" stop-color="#e11d48" />
    </linearGradient>
    <linearGradient id="node_build" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#3b82f6" />
      <stop offset="100%" stop-color="#1d4ed8" />
    </linearGradient>
    <linearGradient id="node_edge" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#f97316" />
      <stop offset="100%" stop-color="#ea580c" />
    </linearGradient>
    <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="12" stdDeviation="16" flood-color="#000000" flood-opacity="0.4" />
    </filter>
  </defs>

  <rect width="960" height="540" fill="url(#bg_cf1)" />

  <!-- Connecting Pipeline Conduit -->
  <path d="M 230 270 L 480 270 L 730 270" stroke="#334155" stroke-width="8" stroke-linecap="round" />
  <path d="M 230 270 L 480 270 L 730 270" stroke="#38bdf8" stroke-width="4" stroke-dasharray="12 12" stroke-linecap="round" opacity="0.8" />

  <!-- Step 1: Git Repository Card -->
  <g transform="translate(140, 180)" filter="url(#shadow)">
    <rect width="180" height="180" rx="24" fill="#1e293b" stroke="#334155" stroke-width="2" />
    <circle cx="90" cy="70" r="34" fill="url(#node_git)" />
    <!-- Git Branch Icon -->
    <path d="M 80,85 L 80,60 A 10,10 0 0,1 95,50 L 102,50" fill="none" stroke="#ffffff" stroke-width="4" stroke-linecap="round" />
    <circle cx="80" cy="85" r="5" fill="#ffffff" />
    <circle cx="80" cy="55" r="5" fill="#ffffff" />
    <circle cx="102" cy="50" r="5" fill="#ffffff" />
    <!-- Progress Indicator Bar -->
    <rect x="40" y="125" width="100" height="8" rx="4" fill="#334155" />
    <rect x="40" y="125" width="100" height="8" rx="4" fill="#f43f5e" />
  </g>

  <!-- Step 2: Automated Build Card -->
  <g transform="translate(390, 180)" filter="url(#shadow)">
    <rect width="180" height="180" rx="24" fill="#1e293b" stroke="#3b82f6" stroke-width="2" />
    <circle cx="90" cy="70" r="34" fill="url(#node_build)" />
    <!-- Gear / Build Icon -->
    <path d="M 90,52 L 90,56 M 90,84 L 90,88 M 72,70 L 76,70 M 104,70 L 108,70 M 77,57 L 80,60 M 100,80 L 103,83 M 77,83 L 80,80 M 100,60 L 103,57" stroke="#ffffff" stroke-width="4" stroke-linecap="round" />
    <circle cx="90" cy="70" r="10" fill="none" stroke="#ffffff" stroke-width="4" />
    <!-- Animated Style Progress Bar -->
    <rect x="40" y="125" width="100" height="8" rx="4" fill="#334155" />
    <rect x="40" y="125" width="70" height="8" rx="4" fill="#38bdf8" />
  </g>

  <!-- Step 3: Global Edge Deploy Card -->
  <g transform="translate(640, 180)" filter="url(#shadow)">
    <rect width="180" height="180" rx="24" fill="#1e293b" stroke="#f97316" stroke-width="2" />
    <circle cx="90" cy="70" r="34" fill="url(#node_edge)" />
    <!-- Edge Network / Cloud Icon -->
    <path d="M 76,76 A 14,14 0 0,1 86,60 A 18,18 0 0,1 104,64 A 12,12 0 0,1 106,76 Z" fill="#ffffff" />
    <!-- Done Check Indicator -->
    <rect x="40" y="125" width="100" height="8" rx="4" fill="#22c55e" />
  </g>

  <!-- Status Light Badges -->
  <circle cx="230" cy="170" r="8" fill="#10b981" />
  <circle cx="480" cy="170" r="8" fill="#38bdf8" />
  <circle cx="730" cy="170" r="8" fill="#f97316" />
</svg>
`;

// 3. Cloudflare Next.js Free Deploy - 02 (960x540) Environment Variables & Vault
const svg_cf_02 = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 540" width="960" height="540">
  <defs>
    <linearGradient id="bg_cf2" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#0a101d" />
      <stop offset="100%" stop-color="#111f38" />
    </linearGradient>
    <linearGradient id="vault_metal" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#334155" />
      <stop offset="50%" stop-color="#1e293b" />
      <stop offset="100%" stop-color="#0f172a" />
    </linearGradient>
    <linearGradient id="gold_key" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#fbbf24" />
      <stop offset="100%" stop-color="#d97706" />
    </linearGradient>
    <filter id="glow_shield" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="0" stdDeviation="20" flood-color="#10b981" flood-opacity="0.3" />
    </filter>
  </defs>

  <rect width="960" height="540" fill="url(#bg_cf2)" />

  <!-- Shield Base in Center -->
  <g transform="translate(480, 260)" filter="url(#glow_shield)">
    <!-- Protective Shield Outer -->
    <path d="M 0,-140 C 90,-140 140,-100 140,10 C 140,90 50,150 0,170 C -50,150 -140,90 -140,10 C -140,-100 -90,-140 0,-140 Z" fill="#0f172a" stroke="#10b981" stroke-width="4" />

    <!-- Inner Safe Door Frame -->
    <circle cx="0" cy="15" r="85" fill="url(#vault_metal)" stroke="#475569" stroke-width="6" />
    <circle cx="0" cy="15" r="70" fill="none" stroke="#64748b" stroke-width="2" stroke-dasharray="8 6" />

    <!-- Safe Lock Handle / Wheel -->
    <circle cx="0" cy="15" r="30" fill="#334155" stroke="#94a3b8" stroke-width="4" />
    <line x1="0" y1="-15" x2="0" y2="45" stroke="#94a3b8" stroke-width="6" stroke-linecap="round" />
    <line x1="-30" y1="15" x2="30" y2="15" stroke="#94a3b8" stroke-width="6" stroke-linecap="round" />
    <circle cx="0" cy="15" r="10" fill="#10b981" />
  </g>

  <!-- Left Side: Secret Variable Chips -->
  <g transform="translate(180, 190)">
    <rect width="180" height="50" rx="12" fill="#1e293b" stroke="#334155" stroke-width="2" />
    <circle cx="30" cy="25" r="8" fill="#10b981" />
    <rect x="50" y="21" width="70" height="8" rx="4" fill="#64748b" />
    <circle cx="140" cy="25" r="4" fill="#94a3b8" />
    <circle cx="150" cy="25" r="4" fill="#94a3b8" />
    <circle cx="160" cy="25" r="4" fill="#94a3b8" />
  </g>
  <g transform="translate(150, 280)">
    <rect width="210" height="50" rx="12" fill="#1e293b" stroke="#334155" stroke-width="2" />
    <circle cx="30" cy="25" r="8" fill="#f59e0b" />
    <rect x="50" y="21" width="90" height="8" rx="4" fill="#64748b" />
    <circle cx="160" cy="25" r="4" fill="#94a3b8" />
    <circle cx="170" cy="25" r="4" fill="#94a3b8" />
    <circle cx="180" cy="25" r="4" fill="#94a3b8" />
  </g>

  <!-- Right Side: Encryption Key -->
  <g transform="translate(670, 240)">
    <circle cx="50" cy="50" r="35" fill="none" stroke="url(#gold_key)" stroke-width="12" />
    <rect x="80" y="44" width="70" height="12" rx="4" fill="url(#gold_key)" />
    <rect x="120" y="56" width="12" height="18" rx="3" fill="url(#gold_key)" />
    <rect x="138" y="56" width="12" height="24" rx="3" fill="url(#gold_key)" />
  </g>
</svg>
`;

// 4. Free AI Image Generators - Cover (1200x630) Creative Canvas & Magic
const svg_ai_cover = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 630" width="1200" height="630">
  <defs>
    <linearGradient id="bg_ai" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#110726" />
      <stop offset="50%" stop-color="#240e46" />
      <stop offset="100%" stop-color="#0a122c" />
    </linearGradient>
    <linearGradient id="canvas_glow" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#ec4899" />
      <stop offset="50%" stop-color="#8b5cf6" />
      <stop offset="100%" stop-color="#3b82f6" />
    </linearGradient>
    <radialGradient id="sparkle_light" cx="50%" cy="50%" r="50%">
      <stop offset="0%" stop-color="#d8b4fe" stop-opacity="0.8" />
      <stop offset="100%" stop-color="#8b5cf6" stop-opacity="0" />
    </radialGradient>
    <filter id="card_shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="16" stdDeviation="24" flood-color="#000000" flood-opacity="0.5" />
    </filter>
  </defs>

  <rect width="1200" height="630" fill="url(#bg_ai)" />

  <!-- Ambient Light -->
  <circle cx="600" cy="315" r="380" fill="url(#sparkle_light)" />

  <!-- Central Digital Art Canvas Frame -->
  <g transform="translate(360, 115)" filter="url(#card_shadow)">
    <!-- Canvas Outer Bezel -->
    <rect width="480" height="380" rx="28" fill="#1e1b4b" stroke="url(#canvas_glow)" stroke-width="4" />
    
    <!-- Artwork Inside Canvas -->
    <rect x="20" y="20" width="440" height="340" rx="20" fill="#0f0c29" />
    
    <!-- Neon Sun / Horizon -->
    <circle cx="220" cy="180" r="80" fill="url(#canvas_glow)" opacity="0.9" />
    
    <!-- Digital Mountains Wave -->
    <path d="M 20,360 L 140,240 L 260,310 L 370,210 L 460,360 Z" fill="#2e1065" opacity="0.9" />
    <path d="M 80,360 L 200,270 L 310,330 L 460,250 L 460,360 Z" fill="#4c1d95" opacity="0.7" />
  </g>

  <!-- AI Magic Wand / Creative Beam -->
  <g transform="translate(860, 200) rotate(30)">
    <rect x="-10" y="0" width="20" height="160" rx="8" fill="#e2e8f0" stroke="#94a3b8" stroke-width="2" />
    <rect x="-10" y="0" width="20" height="40" rx="6" fill="#f43f5e" />
    <!-- Wand Tip Star -->
    <path d="M 0,-30 L 6,-8 L 28,-8 L 10,4 L 16,26 L 0,12 L -16,26 L -10,4 L -28,-8 L -6,-8 Z" fill="#fbbf24" />
  </g>

  <!-- Sparkling Stars -->
  <g transform="translate(300, 180)">
    <path d="M 0,-20 L 4,-4 L 20,0 L 4,4 L 0,20 L -4,4 L -20,0 L -4,-4 Z" fill="#f472b6" />
  </g>
  <g transform="translate(820, 440)">
    <path d="M 0,-15 L 3,-3 L 15,0 L 3,3 L 0,15 L -3,3 L -15,0 L -3,-3 Z" fill="#38bdf8" />
  </g>
  <g transform="translate(260, 420)">
    <path d="M 0,-12 L 2,-2 L 12,0 L 2,2 L 0,12 L -2,2 L -12,0 L -2,-2 Z" fill="#fbbf24" />
  </g>
</svg>
`;

// 5. Free AI Image Generators - 01 (960x540) 4 Style Comparison Cards
const svg_ai_01 = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 540" width="960" height="540">
  <defs>
    <linearGradient id="bg_comp" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#0f0e1a" />
      <stop offset="100%" stop-color="#1a1829" />
    </linearGradient>
    <filter id="f_shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="10" stdDeviation="12" flood-color="#000000" flood-opacity="0.4" />
    </filter>
  </defs>

  <rect width="960" height="540" fill="url(#bg_comp)" />

  <!-- Card 1: Landscape / Nature -->
  <g transform="translate(60, 140)" filter="url(#f_shadow)">
    <rect width="190" height="260" rx="18" fill="#18182b" stroke="#38bdf8" stroke-width="2" />
    <rect x="15" y="15" width="160" height="150" rx="12" fill="#0c4a6e" />
    <!-- Mountain & Sun -->
    <circle cx="95" cy="70" r="24" fill="#f59e0b" />
    <path d="M 25,165 L 75,100 L 125,145 L 165,110 L 175,165 Z" fill="#0284c7" />
    <!-- Label Placeholder Bar -->
    <rect x="35" y="195" width="120" height="10" rx="5" fill="#38bdf8" />
    <rect x="55" y="220" width="80" height="8" rx="4" fill="#475569" />
  </g>

  <!-- Card 2: Portrait / Character -->
  <g transform="translate(280, 140)" filter="url(#f_shadow)">
    <rect width="190" height="260" rx="18" fill="#18182b" stroke="#ec4899" stroke-width="2" />
    <rect x="15" y="15" width="160" height="150" rx="12" fill="#500724" />
    <!-- Minimalist Portrait Silhouette -->
    <circle cx="95" cy="70" r="28" fill="#f472b6" />
    <path d="M 50,165 C 50,120 140,120 140,165 Z" fill="#be185d" />
    <!-- Label Placeholder Bar -->
    <rect x="35" y="195" width="120" height="10" rx="5" fill="#ec4899" />
    <rect x="55" y="220" width="80" height="8" rx="4" fill="#475569" />
  </g>

  <!-- Card 3: Icon / Vector -->
  <g transform="translate(500, 140)" filter="url(#f_shadow)">
    <rect width="190" height="260" rx="18" fill="#18182b" stroke="#10b981" stroke-width="2" />
    <rect x="15" y="15" width="160" height="150" rx="12" fill="#064e3b" />
    <!-- Vector Diamond / Hexagon -->
    <polygon points="95,45 135,70 135,115 95,140 55,115 55,70" fill="none" stroke="#34d399" stroke-width="6" stroke-linejoin="round" />
    <circle cx="95" cy="92" r="14" fill="#34d399" />
    <!-- Label Placeholder Bar -->
    <rect x="35" y="195" width="120" height="10" rx="5" fill="#10b981" />
    <rect x="55" y="220" width="80" height="8" rx="4" fill="#475569" />
  </g>

  <!-- Card 4: 3D Render / Object -->
  <g transform="translate(720, 140)" filter="url(#f_shadow)">
    <rect width="190" height="260" rx="18" fill="#18182b" stroke="#a855f7" stroke-width="2" />
    <rect x="15" y="15" width="160" height="150" rx="12" fill="#3b0764" />
    <!-- Isometric 3D Cube -->
    <g transform="translate(95, 90)">
      <!-- Top Face -->
      <polygon points="0,-40 35,-20 0,0 -35,-20" fill="#c084fc" />
      <!-- Left Face -->
      <polygon points="-35,-20 0,0 0,40 -35,20" fill="#9333ea" />
      <!-- Right Face -->
      <polygon points="0,0 35,-20 35,20 0,40" fill="#7e22ce" />
    </g>
    <!-- Label Placeholder Bar -->
    <rect x="35" y="195" width="120" height="10" rx="5" fill="#a855f7" />
    <rect x="55" y="220" width="80" height="8" rx="4" fill="#475569" />
  </g>
</svg>
`;

// 6. Free AI Image Generators - 02 (960x540) WebP Optimization & Copyright Shield
const svg_ai_02 = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 540" width="960" height="540">
  <defs>
    <linearGradient id="bg_sh" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#0b1320" />
      <stop offset="100%" stop-color="#162238" />
    </linearGradient>
    <linearGradient id="shield_g" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#10b981" />
      <stop offset="100%" stop-color="#059669" />
    </linearGradient>
    <filter id="shield_glow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="12" stdDeviation="18" flood-color="#10b981" flood-opacity="0.3" />
    </filter>
  </defs>

  <rect width="960" height="540" fill="url(#bg_sh)" />

  <!-- Left: File Size Downsizing (Heavy -> Light WebP) -->
  <g transform="translate(180, 170)">
    <!-- Heavy File Card -->
    <rect width="140" height="180" rx="16" fill="#1e293b" stroke="#ef4444" stroke-width="2" />
    <circle cx="70" cy="65" r="24" fill="#ef4444" opacity="0.2" />
    <rect x="45" y="55" width="50" height="20" rx="6" fill="#ef4444" />
    <rect x="30" y="115" width="80" height="8" rx="4" fill="#64748b" />
    <rect x="40" y="135" width="60" height="8" rx="4" fill="#475569" />

    <!-- Compress Arrow -->
    <path d="M 165,90 L 225,90 M 205,75 L 225,90 L 205,105" stroke="#38bdf8" stroke-width="4" stroke-linecap="round" stroke-linejoin="round" />

    <!-- Lightweight WebP Card -->
    <g transform="translate(250, 20)">
      <rect width="120" height="150" rx="14" fill="#1e293b" stroke="#10b981" stroke-width="2" />
      <circle cx="60" cy="55" r="20" fill="#10b981" opacity="0.2" />
      <rect x="40" y="45" width="40" height="18" rx="5" fill="#10b981" />
      <rect x="25" y="95" width="70" height="8" rx="4" fill="#64748b" />
      <rect x="35" y="115" width="50" height="8" rx="4" fill="#475569" />
    </g>
  </g>

  <!-- Right: Copyright Safe Shield -->
  <g transform="translate(680, 260)" filter="url(#shield_glow)">
    <path d="M 0,-120 C 70,-120 110,-90 110,10 C 110,80 40,130 0,150 C -40,130 -110,80 -110,10 C -110,-90 -70,-120 0,-120 Z" fill="#0f172a" stroke="url(#shield_g)" stroke-width="5" />
    <!-- Big Glowing Checkmark -->
    <path d="M -35,15 L -10,40 L 40,-20" fill="none" stroke="#10b981" stroke-width="12" stroke-linecap="round" stroke-linejoin="round" />
  </g>
</svg>
`;

// 7. Side Hustle Checklist - Cover (1200x630) Laptop, Clock & Upward Roadmap
const svg_hustle_cover = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 630" width="1200" height="630">
  <defs>
    <linearGradient id="bg_sh_cov" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#0b1329" />
      <stop offset="60%" stop-color="#16203d" />
      <stop offset="100%" stop-color="#1e1b4b" />
    </linearGradient>
    <linearGradient id="gold_grad" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#fbbf24" />
      <stop offset="100%" stop-color="#d97706" />
    </linearGradient>
    <filter id="h_shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="16" stdDeviation="20" flood-color="#000000" flood-opacity="0.5" />
    </filter>
  </defs>

  <rect width="1200" height="630" fill="url(#bg_sh_cov)" />

  <!-- Upward Trend Chart Line in Background -->
  <path d="M 150,500 Q 400,480 600,340 T 1050,160" fill="none" stroke="#38bdf8" stroke-width="4" stroke-linecap="round" opacity="0.4" />
  <path d="M 150,500 Q 400,480 600,340 T 1050,160 L 1050,550 L 150,550 Z" fill="#38bdf8" opacity="0.05" />

  <!-- Central Laptop Setup -->
  <g transform="translate(420, 180)" filter="url(#h_shadow)">
    <!-- Laptop Screen Bezel -->
    <rect width="360" height="230" rx="16" fill="#1e293b" stroke="#475569" stroke-width="3" />
    <!-- Display Content (Checklist UI) -->
    <rect x="15" y="15" width="330" height="200" rx="10" fill="#0f172a" />
    
    <!-- Checklist items inside laptop -->
    <rect x="40" y="45" width="22" height="22" rx="6" fill="#10b981" />
    <path d="M 46,56 L 50,60 L 56,52" fill="none" stroke="#ffffff" stroke-width="3" stroke-linecap="round" />
    <rect x="75" y="52" width="180" height="8" rx="4" fill="#94a3b8" />

    <rect x="40" y="85" width="22" height="22" rx="6" fill="#10b981" />
    <path d="M 46,96 L 50,100 L 56,92" fill="none" stroke="#ffffff" stroke-width="3" stroke-linecap="round" />
    <rect x="75" y="92" width="140" height="8" rx="4" fill="#94a3b8" />

    <rect x="40" y="125" width="22" height="22" rx="6" fill="#f59e0b" />
    <path d="M 46,136 L 50,140 L 56,132" fill="none" stroke="#ffffff" stroke-width="3" stroke-linecap="round" />
    <rect x="75" y="132" width="200" height="8" rx="4" fill="#94a3b8" />

    <!-- Laptop Base -->
    <path d="M -40,230 L 400,230 L 370,250 L -10,250 Z" fill="#334155" />
    <rect x="150" y="230" width="60" height="6" rx="3" fill="#64748b" />
  </g>

  <!-- Left Side: Evening Clock (Time Management) -->
  <g transform="translate(240, 250)" filter="url(#h_shadow)">
    <circle cx="60" cy="60" r="60" fill="#1e293b" stroke="#64748b" stroke-width="4" />
    <circle cx="60" cy="60" r="5" fill="#f59e0b" />
    <!-- Clock Hands (Showing 8:00 PM) -->
    <line x1="60" y1="60" x2="60" y2="25" stroke="#f8fafc" stroke-width="4" stroke-linecap="round" />
    <line x1="60" y1="60" x2="35" y2="75" stroke="#f59e0b" stroke-width="4" stroke-linecap="round" />
    <!-- Crescent Moon Accent -->
    <path d="M 75,25 A 15,15 0 0,0 90,40 A 15,15 0 1,1 75,25 Z" fill="#fbbf24" opacity="0.8" />
  </g>

  <!-- Right Side: Stacking Growth Coins -->
  <g transform="translate(870, 280)" filter="url(#h_shadow)">
    <!-- Bottom Coin -->
    <ellipse cx="60" cy="110" rx="50" ry="18" fill="url(#gold_grad)" stroke="#b45309" stroke-width="2" />
    <!-- Middle Coin -->
    <ellipse cx="60" cy="80" rx="50" ry="18" fill="url(#gold_grad)" stroke="#b45309" stroke-width="2" />
    <!-- Top Coin -->
    <ellipse cx="60" cy="50" rx="50" ry="18" fill="url(#gold_grad)" stroke="#b45309" stroke-width="2" />
    <ellipse cx="60" cy="50" rx="36" ry="12" fill="none" stroke="#fef3c7" stroke-width="2" />
  </g>
</svg>
`;

// 8. Side Hustle Checklist - 01 (960x540) Employment Rule & Legal Shield
const svg_hustle_01 = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 540" width="960" height="540">
  <defs>
    <linearGradient id="bg_h1" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#0b1220" />
      <stop offset="100%" stop-color="#152033" />
    </linearGradient>
    <filter id="doc_shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="12" stdDeviation="16" flood-color="#000000" flood-opacity="0.4" />
    </filter>
  </defs>

  <rect width="960" height="540" fill="url(#bg_h1)" />

  <!-- Center-Left: Official Document / Company Rule -->
  <g transform="translate(240, 100)" filter="url(#doc_shadow)">
    <!-- Document Page with folded corner -->
    <path d="M 0,0 L 220,0 L 270,50 L 270,340 L 0,340 Z" fill="#1e293b" stroke="#334155" stroke-width="2" />
    <path d="M 220,0 L 220,50 L 270,50 Z" fill="#0f172a" stroke="#334155" stroke-width="2" />

    <!-- Text Lines -->
    <rect x="35" y="40" width="120" height="12" rx="6" fill="#38bdf8" />
    <rect x="35" y="80" width="200" height="8" rx="4" fill="#64748b" />
    <rect x="35" y="105" width="180" height="8" rx="4" fill="#64748b" />
    <rect x="35" y="130" width="190" height="8" rx="4" fill="#64748b" />

    <rect x="35" y="170" width="80" height="10" rx="5" fill="#f59e0b" />
    <rect x="35" y="195" width="170" height="8" rx="4" fill="#64748b" />
    <rect x="35" y="220" width="150" height="8" rx="4" fill="#64748b" />

    <!-- Approved / Review Stamp -->
    <g transform="translate(150, 240) rotate(-15)">
      <rect width="100" height="50" rx="8" fill="none" stroke="#10b981" stroke-width="4" stroke-dasharray="6 3" />
      <circle cx="50" cy="25" r="16" fill="none" stroke="#10b981" stroke-width="3" />
      <path d="M 42,25 L 48,31 L 58,20" fill="none" stroke="#10b981" stroke-width="3" stroke-linecap="round" />
    </g>
  </g>

  <!-- Center-Right: Caution Shield & Inspection Loupe -->
  <g transform="translate(620, 240)" filter="url(#doc_shadow)">
    <!-- Caution Shield -->
    <path d="M 0,-110 C 60,-110 90,-80 90,10 C 90,70 30,110 0,130 C -30,110 -90,70 -90,10 C -90,-80 -60,-110 0,-110 Z" fill="#1e293b" stroke="#f59e0b" stroke-width="4" />
    <!-- Caution Exclamation Mark -->
    <rect x="-5" y="-60" width="10" height="50" rx="5" fill="#f59e0b" />
    <circle cx="0" cy="15" r="6" fill="#f59e0b" />

    <!-- Magnifying Glass Accent -->
    <g transform="translate(-100, 30) rotate(-30)">
      <circle cx="0" cy="0" r="34" fill="none" stroke="#38bdf8" stroke-width="8" />
      <line x1="24" y1="24" x2="55" y2="55" stroke="#38bdf8" stroke-width="10" stroke-linecap="round" />
    </g>
  </g>
</svg>
`;

// 9. Side Hustle Checklist - 02 (960x540) Calculator & Hourly Net Profit
const svg_hustle_02 = `
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 540" width="960" height="540">
  <defs>
    <linearGradient id="bg_h2" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#091424" />
      <stop offset="100%" stop-color="#132238" />
    </linearGradient>
    <linearGradient id="gold_coin" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#fbbf24" />
      <stop offset="100%" stop-color="#d97706" />
    </linearGradient>
    <filter id="calc_shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="12" stdDeviation="16" flood-color="#000000" flood-opacity="0.4" />
    </filter>
  </defs>

  <rect width="960" height="540" fill="url(#bg_h2)" />

  <!-- Left: Sleek Calculator Device -->
  <g transform="translate(180, 110)" filter="url(#calc_shadow)">
    <rect width="220" height="320" rx="22" fill="#1e293b" stroke="#334155" stroke-width="3" />
    <!-- Display Screen -->
    <rect x="20" y="20" width="180" height="60" rx="10" fill="#0f172a" stroke="#475569" stroke-width="1.5" />
    <rect x="40" y="42" width="140" height="16" rx="4" fill="#10b981" opacity="0.8" />

    <!-- Keypad Grid (4x3) -->
    <!-- Row 1 -->
    <rect x="25" y="105" width="45" height="35" rx="8" fill="#334155" />
    <rect x="87" y="105" width="45" height="35" rx="8" fill="#334155" />
    <rect x="150" y="105" width="45" height="35" rx="8" fill="#0284c7" />
    <!-- Row 2 -->
    <rect x="25" y="155" width="45" height="35" rx="8" fill="#334155" />
    <rect x="87" y="155" width="45" height="35" rx="8" fill="#334155" />
    <rect x="150" y="155" width="45" height="35" rx="8" fill="#0284c7" />
    <!-- Row 3 -->
    <rect x="25" y="205" width="45" height="35" rx="8" fill="#334155" />
    <rect x="87" y="205" width="45" height="35" rx="8" fill="#334155" />
    <rect x="150" y="205" width="45" height="35" rx="8" fill="#f59e0b" />
    <!-- Row 4 -->
    <rect x="25" y="255" width="107" height="35" rx="8" fill="#10b981" />
    <rect x="150" y="255" width="45" height="35" rx="8" fill="#f59e0b" />
  </g>

  <!-- Right: Net Profit Balance & Tax Documents -->
  <g transform="translate(520, 130)" filter="url(#calc_shadow)">
    <!-- Calendar / Period Card -->
    <rect width="260" height="150" rx="16" fill="#1e293b" stroke="#334155" stroke-width="2" />
    <!-- Calendar Header -->
    <rect width="260" height="40" rx="16" fill="#e11d48" />
    <circle cx="40" cy="20" r="5" fill="#ffffff" />
    <circle cx="70" cy="20" r="5" fill="#ffffff" />
    <circle cx="100" cy="20" r="5" fill="#ffffff" />
    <!-- Calendar Dots Grid -->
    <circle cx="50" cy="70" r="8" fill="#64748b" />
    <circle cx="95" cy="70" r="8" fill="#64748b" />
    <circle cx="140" cy="70" r="8" fill="#64748b" />
    <circle cx="185" cy="70" r="8" fill="#10b981" />
    <circle cx="50" cy="110" r="8" fill="#64748b" />
    <circle cx="95" cy="110" r="8" fill="#64748b" />
    <circle cx="140" cy="110" r="8" fill="#10b981" />
    <circle cx="185" cy="110" r="8" fill="#10b981" />
  </g>

  <!-- Golden Stack of Net Profit Coins -->
  <g transform="translate(630, 310)">
    <ellipse cx="60" cy="90" rx="55" ry="18" fill="url(#gold_coin)" stroke="#b45309" stroke-width="2" />
    <ellipse cx="60" cy="65" rx="55" ry="18" fill="url(#gold_coin)" stroke="#b45309" stroke-width="2" />
    <ellipse cx="60" cy="40" rx="55" ry="18" fill="url(#gold_coin)" stroke="#b45309" stroke-width="2" />
    <ellipse cx="60" cy="40" rx="42" ry="12" fill="none" stroke="#fef3c7" stroke-width="2" />
  </g>
</svg>
`;

const images = [
  // Cloudflare
  { slug: 'cloudflare-nextjs-free-deploy', name: 'cover', svg: svg_cf_cover },
  { slug: 'cloudflare-nextjs-free-deploy', name: '01', svg: svg_cf_01 },
  { slug: 'cloudflare-nextjs-free-deploy', name: '02', svg: svg_cf_02 },
  // AI Tools
  { slug: 'free-ai-image-generators-comparison', name: 'cover', svg: svg_ai_cover },
  { slug: 'free-ai-image-generators-comparison', name: '01', svg: svg_ai_01 },
  { slug: 'free-ai-image-generators-comparison', name: '02', svg: svg_ai_02 },
  // Side Hustle
  { slug: 'side-hustle-checklist-for-employees', name: 'cover', svg: svg_hustle_cover },
  { slug: 'side-hustle-checklist-for-employees', name: '01', svg: svg_hustle_01 },
  { slug: 'side-hustle-checklist-for-employees', name: '02', svg: svg_hustle_02 }
];

console.log('Writing SVG files...');
for (const img of images) {
  const targetDir = path.join(OUTPUT_DIR, img.slug);
  if (!fs.existsSync(targetDir)) {
    fs.mkdirSync(targetDir, { recursive: true });
  }

  const svgPath = path.join(SCRATCH_DIR, `${img.slug}_${img.name}.svg`);
  const webpPath = path.join(targetDir, `${img.name}.webp`);

  fs.writeFileSync(svgPath, img.svg.trim(), 'utf8');

  console.log(`Converting ${img.slug}/${img.name}.webp via sharp-cli...`);
  // Windows shell safe execution
  const cmd = `npx.cmd -y sharp-cli -i "${svgPath}" -o "${webpPath}" -f webp -q 80`;
  execSync(cmd, { stdio: 'inherit' });
}

console.log('All 9 images generated and converted to WebP successfully!');
