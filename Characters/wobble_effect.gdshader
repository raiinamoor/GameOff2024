shader_type spatial;

const float NOISE_VALUE = 0.015;
const float REPEAT_VALUE = 1.2;
uniform sampler2D sprite_texture : source_color, filter_nearest;
uniform vec3 billboard;

float rand(float x) { return fract(sin(x) * 43758.5453);}

void vertex() {
	float time_snap = floor(TIME * REPEAT_VALUE);
	vec2 noise = vec2( rand(VERTEX.x * time_snap), rand(VERTEX.y * time_snap)) * NOISE_VALUE;
	VERTEX.xy += noise;
	
    vec3 billboard_offset = VERTEX - billboard;
    VERTEX.xz = normalize(INV_VIEW_MATRIX[0].xz) * billboard_offset.x + normalize(INV_VIEW_MATRIX[2].xz) * billboard_offset.z;
    VERTEX.y = billboard_offset.y;
}

void fragment() {
	vec4 color = texture(sprite_texture, UV);
	ALBEDO = color.rgb;
	ALPHA = color.a;
}