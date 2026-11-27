shader_type spatial;

uniform sampler2D texture1 : source_color, filter_nearest_mipmap;
uniform vec2 texture_repeat;
uniform vec3 normal_factor;

void vertex() {
	NORMAL *= normal_factor;
}

void fragment() {
	ALBEDO = texture(texture1, UV * texture_repeat).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
