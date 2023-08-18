shader_type spatial;

uniform sampler2D terrain;
varying float normal_y;


void fragment() {
	float vert_height = normal_y;
	// Albedo value
	vec3 grass = texture(terrain, UV*4.0).rgb;
	// Weight
	float grass_weight = normal_y;
	
	ALBEDO = grass;
}


void vertex() {
	normal_y = VERTEX.y;
}