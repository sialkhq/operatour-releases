// A point field with no geometry in it: every pixel asks how far it is from
// every point. That makes the cost **pixels x points**, which is the opposite
// failure to `p5-points/`, and the one worth understanding before a 4K show.
//
// Measured on an M3 Max. 220 points: 60 fps at 1280x720, 36.8 fps at 3840x2160.
// 600 points: still 60 fps at 720p, 12.4-13.4 fps at 4K over two runs. Nothing
// changed — only how many pixels ran it.
//
// `glsl-raymarch/` does far more work per pixel and holds 60 fps at 4K, because
// its loop exits early against a distance field. A loop that cannot exit is
// what costs; the step count is not the thing to look at.
#define POINTS 220

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = (fragCoord - 0.5 * sialkResolution) / sialkResolution.y;
  float t = sialkTime * 0.35;
  vec3 col = vec3(0.0);

  for (int i = 0; i < POINTS; i++) {
    float f = float(i);
    vec2 p = vec2(
      sin(t * 0.7 + f * 2.399) * 0.62 + sin(t * 1.3 + f * 0.71) * 0.18,
      cos(t * 0.9 + f * 1.111) * 0.42 + cos(t * 1.7 + f * 0.37) * 0.14
    );
    float d = length(uv - p);
    float glow = 0.0016 / (d * d + 0.00004);
    vec3 tint = 0.55 + 0.45 * cos(6.2831 * (vec3(f * 0.013) + vec3(0.0, 0.33, 0.67)));
    col += tint * glow * (0.55 + 0.45 * sialkLevel);
  }

  col = col / (1.0 + col);
  fragColor = vec4(col, 1.0);
}
