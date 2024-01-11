uniform sampler2D Texture;
uniform lowp float BlendIntensity;
uniform lowp vec4 SimpleColor1;
varying mediump vec2 vTexCoord;


void main()
{
    precision lowp float;

    vec4 color = texture2D(Texture, vTexCoord);
    gl_FragColor.rgba = color.rgba * SimpleColor1 * BlendIntensity;
}
