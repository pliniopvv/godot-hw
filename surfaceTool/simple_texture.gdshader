shader_type spatial;

uniform sampler2D terrain;
uniform sampler2D terrain2;
uniform sampler2D mNoise;

varying float normal_x;
varying float normal_z;
uniform float uvscale = 5.0;

void fragment() {
	vec3 grama = texture(terrain, UV*uvscale*5.0).rgb;
	vec3 deserto = texture(terrain2, UV*uvscale*5.0).rgb;
	vec3 _n = texture(mNoise, UV*uvscale/5.0).rgb;
	
	vec3 misturado = mix(grama, deserto, _n);
	ALBEDO = misturado;
}


void vertex() {
	normal_x = VERTEX.x;
	normal_z = VERTEX.z;
}