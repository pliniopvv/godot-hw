shader_type spatial;

// Tutorial seguido:
// https://www.youtube.com/watch?v=Hgv9iAdazKg&t=300s

global uniform sampler2D heightmap;
global uniform sampler2D normalmap;
global uniform float amplitude;

varying vec2 texture_position;

void vertex(){
	vec3 world_vertex = VERTEX + MODEL_MATRIX[3].xyz;
	texture_position = world_vertex.xy/float(textureSize(heightmap,0).x);
	VERTEX.y = texture(heightmap, texture_position).r * amplitude;
}

void fragment() {
	NORMAL_MAP = texture(normalmap, texture_position).rgb;
}
