// A raymarched scene, deliberately expensive: 96 steps, analytic normals
// (four extra field evaluations), soft shadows (24 more), and a domain that
// repeats. Written here rather than taken from Shadertoy, whose library is
// CC-BY-NC and must never enter this repository.

mat2 rot(float a) { float c = cos(a), s = sin(a); return mat2(c, -s, s, c); }

float sdBox(vec3 p, vec3 b) {
  vec3 q = abs(p) - b;
  return length(max(q, 0.0)) + min(max(q.x, max(q.y, q.z)), 0.0);
}

float map(vec3 p) {
  p.xz *= rot(sialkTime * 0.25);
  p.xy *= rot(sialkTime * 0.17);
  vec3 q = p;
  q = mod(q + 2.0, 4.0) - 2.0;
  float pulse = 0.55 + 0.35 * sialkBass;
  float d = length(q) - pulse;
  float b = sdBox(q, vec3(0.42 + 0.2 * sialkHigh));
  d = max(d, -b);
  float ripple = 0.06 * sin(8.0 * p.x + sialkTime * 2.0)
               * sin(8.0 * p.y + sialkTime * 1.7)
               * sin(8.0 * p.z);
  return d + ripple * (0.4 + sialkLevel);
}

vec3 normalAt(vec3 p) {
  vec2 e = vec2(0.0015, 0.0);
  return normalize(vec3(
    map(p + e.xyy) - map(p - e.xyy),
    map(p + e.yxy) - map(p - e.yxy),
    map(p + e.yyx) - map(p - e.yyx)));
}

float shadow(vec3 origin, vec3 direction) {
  float shade = 1.0;
  float t = 0.05;
  for (int i = 0; i < 24; i++) {
    float d = map(origin + direction * t);
    shade = min(shade, 12.0 * d / t);
    t += clamp(d, 0.02, 0.4);
    if (shade < 0.002 || t > 6.0) break;
  }
  return clamp(shade, 0.0, 1.0);
}

void main() {
  vec2 uv = (gl_FragCoord.xy - 0.5 * sialkResolution) / sialkResolution.y;
  vec3 origin = vec3(0.0, 0.0, -3.2);
  vec3 direction = normalize(vec3(uv, 1.4));

  float t = 0.0;
  float hit = 0.0;
  for (int i = 0; i < 96; i++) {
    vec3 p = origin + direction * t;
    float d = map(p);
    if (d < 0.001) { hit = 1.0; break; }
    t += d * 0.85;
    if (t > 14.0) break;
  }

  vec3 colour = vec3(0.0);
  float alpha = 0.0;
  if (hit > 0.5) {
    vec3 p = origin + direction * t;
    vec3 n = normalAt(p);
    vec3 light = normalize(vec3(0.6, 0.8, -0.4));
    float diffuse = clamp(dot(n, light), 0.0, 1.0);
    float rim = pow(1.0 - clamp(dot(n, -direction), 0.0, 1.0), 3.0);
    float sh = shadow(p + n * 0.02, light);
    vec3 warm = vec3(0.85, 0.66, 0.42);
    vec3 cool = vec3(0.42, 0.62, 0.92);
    colour = mix(cool, warm, 0.5 + 0.5 * sin(sialkTime * 0.4 + t));
    colour *= 0.25 + diffuse * sh * (0.7 + 0.6 * sialkMid);
    colour += rim * 0.5 * vec3(0.9, 0.8, 1.0);
    alpha = clamp(1.0 - t / 14.0, 0.0, 1.0);
  }
  fragColor = vec4(colour * alpha, alpha);
}
