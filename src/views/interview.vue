<script setup lang="ts">
import { onBeforeUnmount, onMounted } from "vue";

let castleSVG: HTMLElement | null = null;
let progressBar: HTMLElement | null = null;
let compassNeedle: HTMLElement | null = null;
let revealObserver: IntersectionObserver | null = null;
let compassResetTimer: ReturnType<typeof setTimeout> | null = null;
let lastScrollY = 0;
let scrollTicking = false;
let svgRevealed = false;

const clamp = (value: number, min: number, max: number) =>
  Math.min(Math.max(value, min), max);

const checkSVGReveal = () => {
  if (!castleSVG || svgRevealed) {
    return;
  }

  const rect = castleSVG.getBoundingClientRect();
  if (rect.top < window.innerHeight * 0.85) {
    castleSVG.classList.add("revealed");
    svgRevealed = true;
  }
};

const updateProgress = () => {
  if (!progressBar) {
    return;
  }

  const docHeight = document.documentElement.scrollHeight - window.innerHeight;
  const progress = docHeight > 0 ? (window.scrollY / docHeight) * 100 : 0;
  progressBar.style.width = `${clamp(progress, 0, 100)}%`;
};

const updateCompass = () => {
  if (!compassNeedle) {
    return;
  }

  const currentScrollY = window.scrollY;
  const delta = currentScrollY - lastScrollY;
  const angle = clamp(delta * 2, -45, 45);

  compassNeedle.style.transform = `rotate(${angle}deg)`;

  if (compassResetTimer) {
    clearTimeout(compassResetTimer);
  }
  compassResetTimer = setTimeout(() => {
    if (compassNeedle) {
      compassNeedle.style.transform = "rotate(0deg)";
    }
  }, 300);

  lastScrollY = currentScrollY;
};

const updateScrollEffects = () => {
  checkSVGReveal();
  updateProgress();
  updateCompass();
};

const handleScroll = () => {
  if (scrollTicking) {
    return;
  }

  scrollTicking = true;
  requestAnimationFrame(() => {
    updateScrollEffects();
    scrollTicking = false;
  });
};

const initRevealObserver = () => {
  revealObserver = new IntersectionObserver(
    entries => {
      entries.forEach(entry => {
        if (!entry.isIntersecting) {
          return;
        }

        entry.target.classList.add("visible");
        revealObserver?.unobserve(entry.target);
      });
    },
    { threshold: 0.1, rootMargin: "0px 0px -50px 0px" }
  );

  document
    .querySelectorAll<HTMLElement>("[data-reveal]")
    .forEach(el => revealObserver?.observe(el));
};

onMounted(() => {
  castleSVG = document.getElementById("castleSVG");
  progressBar = document.getElementById("progressBar");
  compassNeedle = document.getElementById("compassNeedle");
  lastScrollY = window.scrollY;

  initRevealObserver();
  updateScrollEffects();
  window.addEventListener("scroll", handleScroll, { passive: true });
});

onBeforeUnmount(() => {
  window.removeEventListener("scroll", handleScroll);
  revealObserver?.disconnect();
  revealObserver = null;

  if (compassResetTimer) {
    clearTimeout(compassResetTimer);
    compassResetTimer = null;
  }
});
</script>
<template>
  <div class="cv-wrapper">
    <!-- Scroll progress bar -->
    <div class="progress-track">
      <div class="progress-bar" id="progressBar"></div>
    </div>

    <div class="content-layer">

      <!-- ===== TITLE BLOCK ===== -->
      <div class="title-block" style="position:relative">
        <div class="approval-stamp">Approved ✓</div>
        <div class="title-block-header">
          <div class="title-block-main">
            <h1>Sandcastle Menu</h1>
            <div class="subtitle">Beachside Sandwich Shack — Cross-Sectional Technical Drawing</div>
          </div>
          <div class="title-block-meta">
            <span><strong>Drawing No.</strong> SB-2026-MAY</span>
            <span><strong>Scale</strong> NTS (Not to Scale)</span>
            <span><strong>Sheet</strong> 1 of 1</span>
            <span><strong>Rev.</strong> C — Final Menu</span>
          </div>
        </div>
        <div class="title-block-footer">
          <div>Material: Sand, Salt Air & Good Vibes</div>
          <div>Tolerance: ±∞ Flavor Units</div>
          <div>Finish: Sun-Kissed</div>
        </div>
      </div>

      <!-- ===== MENU SECTIONS ===== -->

      <!-- SECTION A: SIGNATURE SANDWICHES (Left Tower) -->
      <div class="section-annotation">
        <div class="annotation-row" data-reveal>
          <div class="annotation-marker">A</div>
          <div class="annotation-content">
            <div class="annotation-label">Callout A — Left Tower, Upper Chamber</div>
            <h2 class="annotation-title">Signature Sandwiches</h2>
            <p class="annotation-desc">Constructed between two slabs of freshly baked bread. Structural
              integrity guaranteed through premium ingredient layering.</p>
            <div class="items-spec-sheet">
              <div class="spec-row">
                <span class="spec-id">A-001</span>
                <span class="spec-name">The Breaker<span class="spec-desc">Smoked turkey, pepper jack,
                    avocado mash, pickled jalapeños, chipotle aioli on sourdough</span>
                  <span class="spec-tags"><span class="spec-tag">Spicy</span><span class="spec-tag">Fan
                      Favorite</span></span>
                </span>
                <span class="spec-price">$14</span>
              </div>
              <div class="spec-row spec-row-alt">
                <span class="spec-id">A-002</span>
                <span class="spec-name">Pelican Club<span class="spec-desc">Triple-decker: crispy bacon,
                    roasted chicken, swiss, lettuce, tomato, herb mayo on toast</span>
                  <span class="spec-tags"><span class="spec-tag">Classic</span></span>
                </span>
                <span class="spec-price">$15</span>
              </div>
              <div class="spec-row">
                <span class="spec-id">A-003</span>
                <span class="spec-name">Reef Reuben<span class="spec-desc">Pastrami, sauerkraut, gruyère,
                    thousand island on dark rye — pressed warm</span>
                  <span class="spec-tags"><span class="spec-tag">Pressed</span></span>
                </span>
                <span class="spec-price">$14</span>
              </div>
              <div class="spec-row spec-row-alt">
                <span class="spec-id">A-004</span>
                <span class="spec-name">The Undertow<span class="spec-desc">Pulled pork, coleslaw, pickles,
                    Carolina gold sauce on a brioche bun</span>
                  <span class="spec-tags"><span class="spec-tag">Smoky</span><span class="spec-tag">Sweet</span></span>
                </span>
                <span class="spec-price">$13</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="section-divider"><span>Section B — Right Tower</span></div>

      <!-- SECTION B: CATCH OF THE DAY (Right Tower) -->
      <div class="section-annotation">
        <div class="annotation-row" data-reveal>
          <div class="annotation-marker">B</div>
          <div class="annotation-content">
            <div class="annotation-label">Callout B — Right Tower, Watchroom</div>
            <h2 class="annotation-title">Catch of the Day</h2>
            <p class="annotation-desc">Ocean specimens harvested at dawn. Assembled dockside with salt-air
              precision.</p>
            <div class="items-spec-sheet">
              <div class="spec-row">
                <span class="spec-id">B-001</span>
                <span class="spec-name">Shore Catch Po' Boy<span class="spec-desc">Beer-battered cod,
                    shredded lettuce, tomato, remoulade on a crusty roll</span>
                  <span class="spec-tags"><span class="spec-tag">Crispy</span><span
                      class="spec-tag">Signature</span></span>
                </span>
                <span class="spec-price">$16</span>
              </div>
              <div class="spec-row spec-row-alt">
                <span class="spec-id">B-002</span>
                <span class="spec-name">Tidal Wrap<span class="spec-desc">Grilled shrimp, mango salsa, black
                    beans, lime crema in a spinach tortilla</span>
                  <span class="spec-tags"><span class="spec-tag">Fresh</span><span class="spec-tag">Zesty</span></span>
                </span>
                <span class="spec-price">$15</span>
              </div>
              <div class="spec-row">
                <span class="spec-id">B-003</span>
                <span class="spec-name">Seabreeze Salad<span class="spec-desc">Seared ahi tuna, mixed
                    greens, edamame, sesame ginger dressing, wonton crisps</span>
                  <span class="spec-tags"><span class="spec-tag">Light</span><span
                      class="spec-tag">Healthy</span></span>
                </span>
                <span class="spec-price">$13</span>
              </div>
              <div class="spec-row spec-row-alt">
                <span class="spec-id">B-004</span>
                <span class="spec-name">Captain's Lobster Roll<span class="spec-desc">Chilled lobster, lemon
                    butter, celery, chives on a toasted split-top roll</span>
                  <span class="spec-tags"><span class="spec-tag">Premium</span></span>
                </span>
                <span class="spec-price">$19</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="section-divider"><span>Section C — Great Hall</span></div>

      <!-- SECTION C: BOWLS & GREENS (Great Hall) -->
      <div class="section-annotation">
        <div class="annotation-row" data-reveal>
          <div class="annotation-marker">C</div>
          <div class="annotation-content">
            <div class="annotation-label">Callout C — Great Hall, West Wing</div>
            <h2 class="annotation-title">Bowls & Greens</h2>
            <p class="annotation-desc">Provisions for the health-conscious voyager. Assembled fresh upon each
              order.</p>
            <div class="items-spec-sheet">
              <div class="spec-row">
                <span class="spec-id">C-001</span>
                <span class="spec-name">Sunset Buddha Bowl<span class="spec-desc">Quinoa, roasted sweet
                    potato, chickpeas, kale, tahini drizzle, pickled onion</span>
                  <span class="spec-tags"><span class="spec-tag">Vegan</span><span class="spec-tag">Power</span></span>
                </span>
                <span class="spec-price">$14</span>
              </div>
              <div class="spec-row spec-row-alt">
                <span class="spec-id">C-002</span>
                <span class="spec-name">Tropic Thunder Bowl<span class="spec-desc">Acai, coconut granola,
                    fresh mango, banana, passion fruit, toasted coconut flakes</span>
                  <span class="spec-tags"><span class="spec-tag">Sweet</span><span
                      class="spec-tag">Energizing</span></span>
                </span>
                <span class="spec-price">$15</span>
              </div>
              <div class="spec-row">
                <span class="spec-id">C-003</span>
                <span class="spec-name">Seawall Caesar<span class="spec-desc">Crisp romaine, shaved
                    parmesan, garlic croutons, house-made caesar, add grilled chicken +$4</span>
                  <span class="spec-tags"><span class="spec-tag">Classic</span><span
                      class="spec-tag">Customizable</span></span>
                </span>
                <span class="spec-price">$12</span>
              </div>
              <div class="spec-row spec-row-alt">
                <span class="spec-id">C-004</span>
                <span class="spec-name">Kelp Noodle Stir<span class="spec-desc">Kelp noodles, stir-fried
                    veggies, peanut sauce, cilantro, crushed peanuts, lime wedge</span>
                  <span class="spec-tags"><span class="spec-tag">Gluten-Free</span></span>
                </span>
                <span class="spec-price">$14</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="section-divider"><span>Section D — Kitchen</span></div>

      <!-- SECTION D: SIDES & SNACKS (Kitchen) -->
      <div class="section-annotation">
        <div class="annotation-row" data-reveal>
          <div class="annotation-marker">D</div>
          <div class="annotation-content">
            <div class="annotation-label">Callout D — Kitchen, East Wing</div>
            <h2 class="annotation-title">Sides & Snacks</h2>
            <p class="annotation-desc">Complementary structural components. Designed to support primary
              assemblies.</p>
            <div class="items-spec-sheet">
              <div class="spec-row">
                <span class="spec-id">D-001</span>
                <span class="spec-name">Driftwood Fries<span class="spec-desc">Thick-cut seasoned fries with
                    house fry sauce</span>
                  <span class="spec-tags"><span class="spec-tag">Crispy</span></span>
                </span>
                <span class="spec-price">$6</span>
              </div>
              <div class="spec-row spec-row-alt">
                <span class="spec-id">D-002</span>
                <span class="spec-name">Tide Pool Bites<span class="spec-desc">Fried calamari with marinara
                    and lemon aioli</span>
                  <span class="spec-tags"><span class="spec-tag">Shareable</span></span>
                </span>
                <span class="spec-price">$9</span>
              </div>
              <div class="spec-row">
                <span class="spec-id">D-003</span>
                <span class="spec-name">Sand Dollar Sliders<span class="spec-desc">Three mini smash burgers
                    with American cheese, pickles, special sauce</span>
                  <span class="spec-tags"><span class="spec-tag">Mini</span><span class="spec-tag">3
                      Pack</span></span>
                </span>
                <span class="spec-price">$10</span>
              </div>
              <div class="spec-row spec-row-alt">
                <span class="spec-id">D-004</span>
                <span class="spec-name">Coconut Shrimp<span class="spec-desc">Crispy coconut-crusted shrimp
                    with sweet chili dipping sauce</span>
                  <span class="spec-tags"><span class="spec-tag">Tropical</span></span>
                </span>
                <span class="spec-price">$11</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="section-divider"><span>Section E — The Moat</span></div>

      <!-- SECTION E: DRINKS (Moat) -->
      <div class="section-annotation">
        <div class="annotation-row" data-reveal>
          <div class="annotation-marker">E</div>
          <div class="annotation-content">
            <div class="annotation-label">Callout E — Perimeter Moat, Ground Level</div>
            <h2 class="annotation-title">Drinks</h2>
            <p class="annotation-desc">Liquid provisions surrounding the structure. Essential for structural
              hydration.</p>
            <div class="items-spec-sheet">
              <div class="spec-row">
                <span class="spec-id">E-001</span>
                <span class="spec-name">Riptide Lemonade<span class="spec-desc">Fresh-squeezed lemonade with
                    a hint of lavender and honey</span>
                  <span class="spec-tags"><span class="spec-tag">Refreshing</span><span class="spec-tag">House
                      Made</span></span>
                </span>
                <span class="spec-price">$5</span>
              </div>
              <div class="spec-row spec-row-alt">
                <span class="spec-id">E-002</span>
                <span class="spec-name">Mango Current<span class="spec-desc">Mango purée, sparkling water,
                    lime, agave, served over crushed ice</span>
                  <span class="spec-tags"><span class="spec-tag">Tropical</span><span
                      class="spec-tag">Non-Alcoholic</span></span>
                </span>
                <span class="spec-price">$6</span>
              </div>
              <div class="spec-row">
                <span class="spec-id">E-003</span>
                <span class="spec-name">Cold Brew Undertow<span class="spec-desc">Slow-steeped cold brew
                    with oat milk and vanilla bean</span>
                  <span class="spec-tags"><span class="spec-tag">Coffee</span><span
                      class="spec-tag">Energizing</span></span>
                </span>
                <span class="spec-price">$5</span>
              </div>
              <div class="spec-row spec-row-alt">
                <span class="spec-id">E-004</span>
                <span class="spec-name">Kelp Colada Smoothie<span class="spec-desc">Pineapple, coconut
                    cream, spinach, banana, spirulina boost</span>
                  <span class="spec-tags"><span class="spec-tag">Superfood</span><span
                      class="spec-tag">Vegan</span></span>
                </span>
                <span class="spec-price">$7</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="section-divider"><span>Section F — Foundation</span></div>

      <!-- SECTION F: DESSERTS (Foundation) -->
      <div class="section-annotation">
        <div class="annotation-row" data-reveal>
          <div class="annotation-marker">F</div>
          <div class="annotation-content">
            <div class="annotation-label">Callout F — Foundation Level, Below Grade</div>
            <h2 class="annotation-title">Desserts</h2>
            <p class="annotation-desc">The bedrock upon which all great meals are founded. Sweet structural
              completion.</p>
            <div class="items-spec-sheet">
              <div class="spec-row">
                <span class="spec-id">F-001</span>
                <span class="spec-name">Key Lime Tide<span class="spec-desc">Classic key lime pie with
                    graham cracker crust and whipped cream</span>
                  <span class="spec-tags"><span class="spec-tag">Tangy</span><span
                      class="spec-tag">Classic</span></span>
                </span>
                <span class="spec-price">$8</span>
              </div>
              <div class="spec-row spec-row-alt">
                <span class="spec-id">F-002</span>
                <span class="spec-name">Sandy Churros<span class="spec-desc">Cinnamon sugar churros with
                    chocolate and caramel dipping sauces</span>
                  <span class="spec-tags"><span class="spec-tag">Warm</span><span
                      class="spec-tag">Shareable</span></span>
                </span>
                <span class="spec-price">$7</span>
              </div>
              <div class="spec-row">
                <span class="spec-id">F-003</span>
                <span class="spec-name">Coconut Bliss Sundae<span class="spec-desc">Coconut ice cream,
                    toasted macadamia nuts, pineapple compote, rum caramel drizzle</span>
                  <span class="spec-tags"><span class="spec-tag">Indulgent</span></span>
                </span>
                <span class="spec-price">$9</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- ===== INFO TABLE ===== -->
      <div class="info-blueprint" data-reveal>
        <div class="dim-callout">Site Information — General Notes</div>
        <table class="info-table">
          <thead>
            <tr>
              <th colspan="2">Project Site Data</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Address</td>
              <td>742 Seabreeze Boulevard, Sunset Cove, FL 33139</td>
            </tr>
            <tr>
              <td>Operating Hours</td>
              <td>Mon – Fri: 0700 – 2100 hrs &nbsp;|&nbsp; Sat – Sun: 0800 – 2200 hrs</td>
            </tr>
            <tr>
              <td>Telephone</td>
              <td>(305) 555-WAVE &nbsp;/&nbsp; (305) 555-9283</td>
            </tr>
            <tr>
              <td>Structural Note</td>
              <td>All sandwiches built to order. No structural warranties on sandcastle after high tide.</td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- ===== REVISION TABLE ===== -->
      <div class="revision-block" data-reveal>
        <div class="dim-callout">Revision History</div>
        <table class="revision-table">
          <thead>
            <tr>
              <th>Rev</th>
              <th>Date</th>
              <th>Description</th>
              <th>By</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>A</td>
              <td>2026-05-01</td>
              <td>Initial sketch on napkin</td>
              <td>Chef</td>
            </tr>
            <tr>
              <td>B</td>
              <td>2026-05-12</td>
              <td>Added dessert foundation layer</td>
              <td>Chef</td>
            </tr>
            <tr>
              <td>C</td>
              <td>2026-05-19</td>
              <td>Final menu — Approved for construction</td>
              <td>Chef</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

  </div>
</template>

<style scoped lang="scss">
:global(:root) {
  --parchment: #f5ead6;
  --parchment-dark: #e8d5b4;
  --ink: #2c1810;
  --ink-light: #5c3a28;
  --blue-accent: #1a5276;
  --blue-light: #2980b9;
  --sand: #d4a853;
  --sand-light: #e8c97a;
  --sand-dark: #a87d32;
  --water: #48a9a6;
  --water-deep: #2d7a78;
  --coral: #c0392b;
  --seaweed: #27ae60;
  --grid-line: rgba(44, 24, 16, 0.06);
  --grid-line-major: rgba(44, 24, 16, 0.12);
}

.cv-wrapper {
  scroll-behavior: smooth;
  font-family: "Courier New", Courier, monospace;
  background: var(--parchment);
  color: var(--ink);
  overflow-x: hidden;
  line-height: 1.6;
  height: 100vh;

  &::before {
    content: "";
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background:
      /* Minor grid */
      linear-gradient(var(--grid-line) 1px,
        transparent 1px),
      linear-gradient(90deg, var(--grid-line) 1px, transparent 1px),
      /* Major grid */
      linear-gradient(var(--grid-line-major) 1px, transparent 1px),
      linear-gradient(90deg, var(--grid-line-major) 1px, transparent 1px);
    background-size: 20px 20px, 20px 20px, 100px 100px, 100px 100px;
    pointer-events: none;
    z-index: 0;
    opacity: 0.7;
  }
}

/* === SCROLLBAR === */
:global(::-webkit-scrollbar) {
  width: 8px;
}

:global(::-webkit-scrollbar-track) {
  background: var(--parchment-dark);
}

:global(::-webkit-scrollbar-thumb) {
  background: var(--ink-light);
  border-radius: 4px;
}

/* === SHARED === */
.content-layer {
  position: relative;
  z-index: 2;
}

/* === TITLE BLOCK (Blueprint style) === */
.title-block {
  border: 2px solid var(--ink);
  margin: 2rem auto;
  max-width: 900px;
  position: relative;
}

.title-block::before {
  content: "";
  position: absolute;
  top: 4px;
  left: 4px;
  right: 4px;
  bottom: 4px;
  border: 1px solid var(--ink-light);
  pointer-events: none;
}

.title-block-header {
  display: flex;
  justify-content: space-between;
  align-items: stretch;
  border-bottom: 2px solid var(--ink);
}

.title-block-main {
  flex: 1;
  padding: 1.2rem 1.5rem;
  border-right: 2px solid var(--ink);
}

.title-block-main h1 {
  font-size: clamp(1.8rem, 5vw, 3rem);
  font-weight: 900;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  line-height: 1.1;
}

.title-block-main .subtitle {
  font-size: 0.75rem;
  letter-spacing: 0.3em;
  text-transform: uppercase;
  color: var(--ink-light);
  margin-top: 0.3rem;
}

.title-block-meta {
  width: 200px;
  padding: 0.8rem 1rem;
  font-size: 0.7rem;
  line-height: 1.8;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.title-block-meta span {
  display: block;
  border-bottom: 1px solid var(--grid-line-major);
  padding-bottom: 2px;
}

.title-block-footer {
  display: flex;
  border-top: 2px solid var(--ink);
}

.title-block-footer>div {
  flex: 1;
  padding: 0.6rem 1rem;
  font-size: 0.65rem;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  border-right: 2px solid var(--ink);
  text-align: center;
}

.title-block-footer>div:last-child {
  border-right: none;
}

/* === SECTION ANNOTATIONS (Leader lines from castle to menu) === */
.section-annotation {
  max-width: 900px;
  margin: 0 auto;
  padding: 0 1.5rem;
}

.annotation-row {
  display: flex;
  align-items: flex-start;
  gap: 1rem;
  margin-bottom: 4rem;
  opacity: 0;
  transform: translateY(30px);
  transition: opacity 0.8s ease, transform 0.8s ease;
}

.annotation-row.visible {
  opacity: 1;
  transform: translateY(0);
}

.annotation-marker {
  flex-shrink: 0;
  width: 48px;
  height: 48px;
  border: 2px solid var(--ink);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.2rem;
  font-weight: 900;
  position: relative;
  background: var(--parchment);
}

.annotation-marker::after {
  content: "";
  position: absolute;
  top: 100%;
  left: 50%;
  width: 2px;
  height: 60px;
  background: repeating-linear-gradient(to bottom,
      var(--ink) 0px,
      var(--ink) 4px,
      transparent 4px,
      transparent 8px);
  transform: translateX(-50%);
}

.annotation-content {
  flex: 1;
  padding-top: 0.3rem;
}

.annotation-label {
  font-size: 0.6rem;
  letter-spacing: 0.4em;
  text-transform: uppercase;
  color: var(--ink-light);
  margin-bottom: 0.2rem;
}

.annotation-title {
  font-size: clamp(1.4rem, 3.5vw, 2rem);
  font-weight: 900;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 0.3rem;
  position: relative;
  display: inline-block;
}

.annotation-title::after {
  content: "";
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 100%;
  height: 3px;
  background: var(--ink);
}

.annotation-desc {
  font-size: 0.75rem;
  color: var(--ink-light);
  font-style: italic;
  margin-bottom: 1.5rem;
  max-width: 500px;
}

/* === MENU ITEMS (Spec sheet style) === */
.items-spec-sheet {
  display: grid;
  grid-template-columns: 1fr;
  gap: 0;
  border: 1.5px solid var(--ink);
  background: rgba(245, 234, 214, 0.5);
}

.spec-row {
  display: grid;
  grid-template-columns: auto 1fr auto;
  gap: 1rem;
  padding: 0.8rem 1.2rem;
  border-bottom: 1px solid var(--grid-line-major);
  align-items: baseline;
  transition: background 0.3s ease;
  cursor: default;
}

.spec-row:last-child {
  border-bottom: none;
}

.spec-row:hover {
  background: rgba(212, 168, 83, 0.1);
}

.spec-row-alt {
  background: rgba(44, 24, 16, 0.02);
}

.spec-id {
  font-size: 0.6rem;
  color: var(--ink-light);
  letter-spacing: 0.1em;
  min-width: 40px;
  padding-top: 2px;
}

.spec-name {
  font-weight: 700;
  font-size: 0.95rem;
}

.spec-name .spec-desc {
  display: block;
  font-weight: 400;
  font-size: 0.75rem;
  color: var(--ink-light);
  margin-top: 0.15rem;
  line-height: 1.4;
}

.spec-tags {
  display: flex;
  gap: 0.3rem;
  flex-wrap: wrap;
  margin-top: 0.3rem;
}

.spec-tag {
  font-size: 0.55rem;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  padding: 0.1rem 0.4rem;
  border: 1px solid var(--ink-light);
  color: var(--ink-light);
}

.spec-price {
  font-weight: 900;
  font-size: 1rem;
  white-space: nowrap;
  text-align: right;
  min-width: 45px;
}

/* === INFO SECTION === */
.info-blueprint {
  max-width: 900px;
  margin: 4rem auto;
  padding: 0 1.5rem;
}

.info-table {
  width: 100%;
  border: 2px solid var(--ink);
  border-collapse: collapse;
}

.info-table th {
  background: var(--ink);
  color: var(--parchment);
  padding: 0.6rem 1rem;
  text-align: left;
  font-size: 0.7rem;
  letter-spacing: 0.3em;
  text-transform: uppercase;
}

.info-table td {
  padding: 0.7rem 1rem;
  border-bottom: 1px solid var(--grid-line-major);
  font-size: 0.8rem;
  vertical-align: top;
}

.info-table tr:last-child td {
  border-bottom: none;
}

.info-table td:first-child {
  font-weight: 700;
  width: 140px;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  font-size: 0.7rem;
  color: var(--ink-light);
}

/* === REVISION TABLE === */
.revision-block {
  max-width: 900px;
  margin: 2rem auto 4rem;
  padding: 0 1.5rem;
}

.revision-table {
  width: 100%;
  border: 2px solid var(--ink);
  border-collapse: collapse;
}

.revision-table th {
  background: rgba(44, 24, 16, 0.06);
  padding: 0.5rem 0.8rem;
  text-align: left;
  font-size: 0.65rem;
  letter-spacing: 0.2em;
  text-transform: uppercase;
  border-bottom: 2px solid var(--ink);
}

.revision-table td {
  padding: 0.5rem 0.8rem;
  font-size: 0.75rem;
  border-bottom: 1px solid var(--grid-line-major);
}

/* === STAMP DECORATION === */
.approval-stamp {
  position: absolute;
  top: 20px;
  right: 20px;
  border: 3px solid var(--coral);
  border-radius: 8px;
  padding: 0.4rem 0.8rem;
  transform: rotate(12deg);
  font-size: 0.7rem;
  font-weight: 900;
  color: var(--coral);
  letter-spacing: 0.2em;
  text-transform: uppercase;
  opacity: 0.7;
  pointer-events: none;
}

/* === SCROLL PROGRESS BAR === */
.progress-track {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 3px;
  background: rgba(44, 24, 16, 0.1);
  z-index: 200;
}

.progress-bar {
  height: 100%;
  width: 0%;
  background: var(--ink);
  transition: width 0.1s linear;
}

/* === SECTION DIVIDER === */
.section-divider {
  max-width: 900px;
  margin: 0 auto;
  padding: 0 1.5rem;
  display: flex;
  align-items: center;
  gap: 1rem;
}

.section-divider::before,
.section-divider::after {
  content: "";
  flex: 1;
  height: 0;
  border-top: 1px solid var(--ink-light);
}

.section-divider span {
  font-size: 0.6rem;
  letter-spacing: 0.3em;
  text-transform: uppercase;
  color: var(--ink-light);
  white-space: nowrap;
}

/* === RESPONSIVE === */
@media (max-width: 640px) {
  .title-block-header {
    flex-direction: column;
  }

  .title-block-meta {
    width: 100%;
    border-top: 2px solid var(--ink);
  }

  .title-block-main {
    border-right: none;
  }

  .title-block-footer {
    flex-wrap: wrap;
  }

  .title-block-footer>div {
    flex: 1 1 50%;
    border-bottom: 1px solid var(--ink-light);
  }

  .annotation-row {
    flex-direction: column;
    align-items: flex-start;
  }

  .annotation-marker::after {
    display: none;
  }

  .spec-row {
    grid-template-columns: 1fr auto;
    gap: 0.5rem;
  }

  .spec-id {
    display: none;
  }

  .info-table td:first-child {
    width: 100px;
  }

}

/* === PRINT STYLES === */
@media print {
  body {
    background: #fff;
    color: #000;
  }

  body::before,
  body::after {
    display: none;
  }

  .compass,
  .progress-track {
    display: none;
  }

  .approval-stamp {
    opacity: 0.5;
    border-color: #999;
    color: #999;
  }

  .title-block {
    border-color: #000;
  }

  .annotation-row {
    opacity: 1 !important;
    transform: none !important;
    page-break-inside: avoid;
  }

  .items-spec-sheet {
    page-break-inside: avoid;
  }

  .spec-row:hover {
    background: none;
  }

}
</style>
