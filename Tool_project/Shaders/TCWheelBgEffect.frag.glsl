precision mediump float;

uniform sampler2D Texture;

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
	
	const float BLOOM_FACTOR = 0.6;
	
	const float DEF_RAD = 0.1;
	
	const float POWER = 5.0;

	vec2 uv = vTexCoord;
	
	vec4 baseColor = texture2D(Texture, uv);
	
	vec2 uvSq = pow(uv, vec2(POWER));
	float radSq = pow(kzSlipPercent, POWER);
	
	//vec2 uvFuckIDK = pow(uv, vec2(0.35));

	//float coeffEdgeDecreaseX = smoothstep(0.0, 0.5, uvFuckIDK.x);
	//float coeffEdgeDecreaseY = smoothstep(0.0, 0.5, uvFuckIDK.y);
	//float coeffEdgeDecrease = coeffEdgeDecreaseX * coeffEdgeDecreaseY;
	
    float coeff = (uv.x > kzSlipPercent) ? 0.0: ((uv.x > kzSlipPercent - DEF_RAD) ? BLOOM_FACTOR - smoothstep(kzSlipPercent - DEF_RAD, kzSlipPercent, uv.x): BLOOM_FACTOR);
    
    vec3 dominantColor = (kzSlipPercent < TRACTION_CRITICAL_LIMIT) ? YELLOW: RED;
    dominantColor = (kzSlipPercent < TRACTION_BAD_LIMIT) ? GREEN: YELLOW;
    
    vec3 colorOK = mix(GREEN, YELLOW, smoothstep(TRACTION_BAD_LIMIT, TRACTION_CRITICAL_LIMIT, kzSlipPercent));
    vec3 colorBAD = mix(YELLOW, RED, smoothstep(TRACTION_CRITICAL_LIMIT, TRACTION_TOP_LIMIT, kzSlipPercent));
    
    vec3 color = (kzSlipPercent < TRACTION_CRITICAL_LIMIT) ? colorOK: colorBAD;
    
    gl_FragColor = vec4(color * coeff, coeff);
}