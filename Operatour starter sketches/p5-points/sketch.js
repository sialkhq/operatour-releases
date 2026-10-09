// A point cloud in p5, rebuilt every frame inside one `beginShape(POINTS)` —
// one draw call, so the cost is vertex throughput and the JavaScript around it.
//
// **This breaks on count, never on resolution.** Measured on an M3 Max: 60,000
// points hold 60 fps at 1280x720 and at 3840x2160 alike; 250,000 fall to 27.8
// fps at 720p and 27.2 at 4K — the same number, because four times the pixels
// cost nothing here. Compare `glsl-points/`, which fails the opposite way.
const N = 60000;
let t = 0;
const seeds = [];

function setup() {
  createCanvas(windowWidth, windowHeight, WEBGL);
  for (let i = 0; i < N; i++) {
    seeds.push([Math.random() * TWO_PI, Math.random() * PI, 0.4 + Math.random() * 0.6]);
  }
  strokeWeight(2);
}

function draw() {
  background(2, 2, 8);
  t += 0.006;
  rotateY(t);
  rotateX(t * 0.4);
  const r = min(width, height) * 0.42;
  stroke(150, 200, 255, 170);
  beginShape(POINTS);
  for (let i = 0; i < N; i++) {
    const [a, b, k] = seeds[i];
    const wob = 1 + 0.14 * sin(t * 2 + a * 5 + b * 3);
    vertex(r * k * wob * sin(b) * cos(a), r * k * wob * sin(b) * sin(a), r * k * wob * cos(b));
  }
  endShape();
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
}
