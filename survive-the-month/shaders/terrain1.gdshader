shader_type spatial;
//render_mode vertex_lighting, diffuse_lambert, specular_disabled;

uniform sampler2D grass : source_color, filter_nearest_mipmap;
uniform sampler2D dirt_mask : source_color, filter_linear_mipmap;
uniform sampler2D dirt : source_color, filter_nearest_mipmap;
uniform sampler2D dirt_mask1 : source_color, filter_linear_mipmap;
uniform sampler2D dirt1 : source_color, filter_nearest_mipmap;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 repeat_uv = UV * 9.5f;
	vec3 dirt1_color = texture(dirt1, repeat_uv).rgb;
	vec3 dirt_color = mix(texture(dirt, repeat_uv).rgb, dirt1_color, texture(dirt_mask1, UV).a);
	ALBEDO = mix(texture(grass, repeat_uv).rgb, dirt_color, texture(dirt_mask, UV).a);
}

void light() {
   float NdotL = clamp(max(dot(NORMAL, LIGHT), 0.0), 0.0, 1.0);
	float attenuation = ATTENUATION + 0.3f;
	vec3 albedo = ALBEDO;
    DIFFUSE_LIGHT += (albedo + LIGHT_COLOR) * NdotL * attenuation * 0.3;
}
