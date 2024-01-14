precision mediump float;

uniform sampler2D TextureASS;

uniform float kzSlipPercent;

varying vec2 vTexCoord;

void main()
{
	const vec3 WHITE = vec3(1.0);
	const vec3 RED = vec3(0.871, 0.0, 0.0);
	const vec3 YELLOW = vec3(1, 0.976, 0);
	const vec3 GREEN = vec3(0, 0.82, 0.169);
	
	const float TRACTION_BAD_LIMIT = 0.2;
	const float TRACTION_CRITICAL_LIMIT = 0.6;
	const float TRACTION_TOP_LIMIT = 1.0;
	
	float ass = kzSlipPercent * kzSlipPercent;
	
	vec4 baseColor = texture2D(TextureASS, vTexCoord);
	
	baseColor *= vec4(RED, 1.0);
    
    gl_FragColor = vec4(baseColor.xyz * kzSlipPercent, baseColor.a * kzSlipPercent);
}