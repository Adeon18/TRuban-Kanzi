precision mediump float;

uniform samplerCube TextureCube;
uniform sampler2D NormalMapTexture;
uniform sampler2D RoughnessTexture;

uniform lowp vec4 CubemapColor;
uniform lowp float BlendIntensity;
uniform lowp float NormalMapStrength;
uniform lowp float RoughnessStrength;

varying mediump vec3 vNormal;
varying mediump vec3 vTangent;
varying mediump vec3 vBinormal;
varying mediump vec3 vViewDirection;
varying lowp vec4 vColor;
varying mediump vec2 vTexCoord;


void main()
{    
    float roughness = texture2D(RoughnessTexture, vTexCoord.yx).x;
    vec3 textureNormal = texture2D(NormalMapTexture, vTexCoord.yx).xyz * 2.0;// - vec3(1.0);
    vec3 normalFactor = mix(vec3(0., 0., 1.0), textureNormal, NormalMapStrength);
    vec3 N = normalize(vec3(    vTangent * normalFactor.x + 
                                vBinormal * normalFactor.y +
                                vNormal * normalFactor.z));
    vec3 V = normalize(vViewDirection);    
    vec3 R = reflect(V, N);
    lowp vec4 cubeMap = textureCube(TextureCube, R, roughness*RoughnessStrength) * CubemapColor;  
    
    lowp vec4 color = vColor + cubeMap;

    gl_FragColor.rgba = color * BlendIntensity;
}
