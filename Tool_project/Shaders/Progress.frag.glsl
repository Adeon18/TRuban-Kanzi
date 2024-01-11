precision mediump float;

varying mediump vec2 vTexCoord;

uniform mediump vec4 SimpleColor1;
uniform mediump vec4 SimpleColor2;

uniform mediump float Progress;

void main()
{
    float progress = step(vTexCoord.y, Progress);
    
    float mask = mix(0.0, 1.0, vTexCoord.y/Progress)*progress;
    
    vec4 tempColor = mix(SimpleColor2, SimpleColor1, mask);
    
    gl_FragColor = mix(vec4(0.0), tempColor, mask);
}