// The exact signature Shadertoy generates, parameter name and all. This is the
// form nearly every shader in the wild uses, and it must compile untouched.
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord / iResolution.xy;
    vec3 col = 0.5 + 0.5 * cos(iTime + uv.xyx + vec3(0, 2, 4));
    col *= 0.4 + 0.6 * sialkLevel;
    fragColor = vec4(col, 1.0);
}
