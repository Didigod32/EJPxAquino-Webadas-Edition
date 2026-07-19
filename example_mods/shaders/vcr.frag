#pragma header

uniform float iTime;
uniform float glitchModifier;
uniform float noisePercent;
uniform float vignetteStrength;

float random(vec2 uv)
{
    return fract(sin(dot(uv.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void main()
{
    vec2 uv = openfl_TextureCoordv.xy;

    float glitch = sin(uv.y * 12.0 + iTime * 5.0) * glitchModifier;

    uv.x += glitch;

    vec4 color = flixel_texture2D(bitmap, uv);

    float noise = random(uv + iTime) * noisePercent;

    color.rgb += noise;

    float dist = distance(openfl_TextureCoordv, vec2(0.5));
    color.rgb *= smoothstep(0.8, vignetteStrength * 0.01, dist);

    gl_FragColor = color;
}