// A GLSL layer, in the shape Sialk plays: one folder, one `sketch.glsl`, and
// no page, no loop and no boilerplate anywhere.
//
// Everything below `sialk` comes from the audio contract v1 and is supplied by
// the host as uniforms. Nothing here is imported, declared or polled — the
// values are simply there, updated once per composited frame.
//
// Drop the folder on Sialk and play music at it.

void main() {
  vec2 uv = gl_FragCoord.xy / sialkResolution;

  // Twenty-four bars across the frame.
  float bar = floor(uv.x * 24.0) / 24.0;

  // **Headroom.** A bar that reaches the top of the frame has stopped being a
  // reading and started being a wall, and the difference between a loud room
  // and a very loud one disappears with it. Two thirds of the height for the
  // loudest thing the spectrum reports leaves the top of the frame meaning
  // something, and it is the first thing to change if these look short.
  float height = sialkBand(bar) * 0.66;
  float lit = step(uv.y, height);

  // The bands colour it: bass low and warm, high up and cold.
  vec3 warm = vec3(0.76, 0.67, 0.58);
  vec3 cold = vec3(0.61, 0.74, 0.92);
  vec3 tint = mix(warm, cold, uv.x);

  // A beat brightens the bars rather than the frame. `beatPhase` ramps 0 → 1
  // between beats, so `1 - beatPhase` is a decay in time with the music rather
  // than with a timer — but adding it to the whole frame's alpha painted a
  // solid sheet over everything on every beat, and a layer that goes opaque
  // four times a bar is not a layer anybody can stack under.
  float pulse = (1.0 - sialkBeatPhase) * step(1.0, sialkBpm);

  // Transparent where it does not paint, so the layers under it show through:
  // `0030`, and the whole reason a stack works.
  float alpha = lit * (0.30 + 0.45 * sialkLevel + 0.25 * pulse);
  fragColor = vec4(tint * alpha, alpha);
}
