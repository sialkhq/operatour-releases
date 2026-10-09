// GLSL ES 1.00 — what most shaders on the internet still are. `gl_FragColor`
// and `texture2D` are what the host detects the dialect from. Loop bounds are
// constant, which ES 1.00 requires.
precision highp float;

float ring(vec2 p, float r, float w) {
  return smoothstep(w, 0.0, abs(length(p) - r));
}

void main() {
  vec2 uv = (gl_FragCoord.xy - 0.5 * sialkResolution) / sialkResolution.y;
  vec3 colour = vec3(0.0);
  float alpha = 0.0;

  for (int i = 0; i < 20; i++) {
    float f = float(i) / 20.0;
    // Read the spectrum through the 1.00 helper, which is texture2D-backed.
    float band = sialkBand(f);
    float radius = 0.08 + f * 0.55 + band * 0.25;
    float a = ring(uv, radius, 0.012 + 0.03 * band);
    vec3 tint = mix(vec3(0.9, 0.6, 0.35), vec3(0.4, 0.7, 0.95), f);
    colour += tint * a * (0.3 + 0.7 * sialkLevel);
    alpha += a;
  }

  alpha = clamp(alpha, 0.0, 1.0);
  gl_FragColor = vec4(colour, alpha);
}
