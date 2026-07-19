#pragma header

uniform float distortion;
uniform float darkness;
uniform float iTime;

void main()
{
    vec2 uv = openfl_TextureCoordv.xy;

    vec2 center = vec2(0.5, 0.5);

    vec2 dist = uv - center;

    float radius = length(dist);

    // ojo de pez invertido
    uv += dist * radius * distortion;

    vec4 color = flixel_texture2D(bitmap, uv);

    // oscurecer bordes
    float vignette = smoothstep(0.2, 0.95, radius);

    color.rgb *= 1.0 - (vignette * darkness);

    gl_FragColor = color;
}