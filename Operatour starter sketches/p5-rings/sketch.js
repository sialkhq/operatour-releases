// A p5 layer, in the shape the p5 web editor produces: one folder, one
// `sketch.js`, two global functions. Nothing about it is Sialk-specific except
// the four lines that read `sialk` — and a sketch that never mentions Sialk
// still runs, it just does not move to the music.
//
// p5 itself is supplied by Sialk, so this folder needs no library, no
// `index.html` and no network.

let hits = 0;
const rings = [];

function setup() {
  // The layer's own size. A sketch that asks for a fixed size instead —
  // `createCanvas(400, 400)` — is scaled up to fill the layer, keeping its
  // aspect and its own coordinate system.
  createCanvas(windowWidth, windowHeight);
  noFill();
  strokeWeight(2);
  colorMode(HSB, 1);

  // ─── What the performer can see, and later play ──────────────────────
  //
  // Declared once, at startup. In the beta the Inspector shows these as live
  // readouts — name, range and current value, the bar a meter rather than a
  // fader — and the sketch is the only thing that writes them (`0047`).
  // Editing them from the surface arrives at v1, and this sketch does not
  // change when it does: the declaration is the whole contract.
  window.sialk?.parameters.declare({
    density: {
      type: 'number',
      label: 'Ring density',
      group: 'Rings',
      default: 14,
      min: 2,
      max: 60,
      unit: 'rings',
    },
    speed: { type: 'number', label: 'Speed', group: 'Rings', default: 1, min: 0.1, max: 4 },
    hue: { type: 'number', label: 'Hue', group: 'Rings', default: 0.6, min: 0, max: 1 },
  });
}

function draw() {
  // Never `background()` on a layer you want to see through. `clear()` leaves
  // the frame transparent, which is what lets the layers below show.
  clear();

  const audio = window.sialk?.audio;
  const level = audio?.level ?? 0;
  const bass = audio?.bass ?? 0;

  // The declared values, read every frame. The same object for the sketch's
  // whole life, mutated in place — never re-read from the host.
  const values = window.sialk?.parameters.values ?? {};
  const density = values.density ?? 14;
  const speed = values.speed ?? 1;
  const hue = values.hue ?? 0.6;

  // The sketch moves its own parameters, which is what the beta's Inspector
  // exists to show: density follows the bass, speed the broadband level, hue
  // drifts. Nothing on the surface is driving these — the sketch is.
  if (window.sialk) {
    window.sialk.parameters.values.density = 14 + bass * 40;
    window.sialk.parameters.values.speed = 0.4 + level * 3;
    window.sialk.parameters.values.hue = (frameCount / 3000) % 1;
  }

  // A ring per onset. `hits` is a monotonic counter, so a dropped frame loses
  // nothing — the difference is how many onsets happened while we were away.
  const counted = audio?.hits ?? 0;
  while (hits < counted) {
    if (rings.length < density) rings.push({ born: millis(), strength: 0.4 + bass * 0.6 });
    hits += 1;
  }

  for (let at = rings.length - 1; at >= 0; at -= 1) {
    const ring = rings[at];
    const age = ((millis() - ring.born) / 1400) * speed;
    if (age > 1) {
      rings.splice(at, 1);
      continue;
    }
    const radius = age * max(width, height) * 0.9;
    stroke(hue, 0.35, 1, (1 - age) * ring.strength);
    circle(width / 2, height / 2, radius);
  }

  // A quiet centre that breathes with the broadband level, so the layer is
  // never completely empty between onsets.
  stroke((hue + 0.5) % 1, 0.24, 0.9, 0.16 + level * 0.7);
  circle(width / 2, height / 2, 40 + level * 220);
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
}
