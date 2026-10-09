// 3D in p5, which is `WEBGL` mode and one draw call per shape issued from
// JavaScript. That makes the cost **the number of shapes**, not the number of
// pixels: measured on an M3 Max, 600 boxes hold 60 fps at 1280x720 and at
// 3840x2160 alike, and so do 2,000. Raise N until it does not — the number you
// find is a property of the machine, and it will not move when the projector
// does.
//
// Audio: `sialk.level` and the bands are on `window.sialk`; this one stays
// still on purpose so the frame cost is readable.
const N = 600;
let angle = 0;

function setup() {
  // Full size, not a fixed canvas: p5-fit scales a small canvas up rather than
  // resizing it, so `createCanvas(400, 400)` would measure nothing about 4K.
  createCanvas(windowWidth, windowHeight, WEBGL);
}

function draw() {
  background(4, 4, 12);
  ambientLight(48);
  directionalLight(220, 210, 255, -0.4, -0.6, -1);
  pointLight(120, 180, 255, 0, 0, 400);
  angle += 0.004;

  const spread = min(width, height) * 0.45;
  for (let i = 0; i < N; i++) {
    const t = i / N;
    push();
    rotateY(angle + t * TWO_PI);
    rotateX(angle * 0.7 + t * PI);
    translate(cos(t * TWO_PI * 7) * spread, sin(t * TWO_PI * 5) * spread * 0.6, sin(t * 30) * 200);
    rotateZ(angle * 2 + t);
    specularMaterial(120 + 120 * sin(t * 9), 90, 200 - 100 * cos(t * 6));
    box(18 + 10 * sin(t * 12));
    pop();
  }
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
}
