shader_type spatial;
render_mode depth_prepass_alpha;

uniform sampler2D m_texture : filter_nearest_mipmap;
uniform float wave_speed;
uniform float wave_strength;
uniform vec3 color : source_color;
uniform vec3 normal_factor;

float hash11(float p) {
    p = fract(p * 0.1031);
    p *= p + 33.33;
    p *= p + p;
    return fract(p);
}


void vertex() {
	vec3 current_vertex = VERTEX;
	float h1 = hash11(float(INSTANCE_ID));
	vec2 dir = normalize(vec2(h1 + 0.346, h1));
    float wave = sin((TIME * wave_speed + current_vertex.x + current_vertex.z) * h1);
	vec2 wind_offset = dir * wave * wave_strength;
    current_vertex.xz += wind_offset;

    vec3 world_pos = MODEL_MATRIX[3].xyz;
    vec3 cam_pos = INV_VIEW_MATRIX[3].xyz;
    vec3 mdir = cam_pos - world_pos;
    mdir.y = 0.0;
    mdir = normalize(mdir);

    //float yaw = atan(mdir.x, mdir.z);
    //float c = cos(yaw);
   // float s = sin(yaw);
	float s = mdir.x;
	float c = mdir.z;

    mat3 rotY;
     rotY[0] = vec3(c, 0.0, -s);
     rotY[1] = vec3(0.0, 1.0, 0.0);
     rotY[2] = vec3(s, 0.0, c);

    vec3 rotated = rotY * current_vertex.xyz;
    vec3 final_world = world_pos + rotated;
    POSITION = PROJECTION_MATRIX * VIEW_MATRIX * vec4(final_world, 1.0);
    NORMAL *= normal_factor;
}

void fragment() {
   float mask = texture(m_texture, UV).a;
	ALBEDO = color;
	ALPHA = mask;
}

void light() {
    float NdotL = clamp(max(dot(NORMAL, LIGHT), 0.0), 0.0, 1.0);
	float attenuation = ATTENUATION + 0.08f;
	vec3 albedo = ALBEDO;
    DIFFUSE_LIGHT += (albedo + LIGHT_COLOR) * NdotL * attenuation * 0.3;

    //vec3 view_dir = normalize(VIEW);
    //vec3 half_dir = normalize(LIGHT + view_dir);
    //float spec = pow(max(dot(NORMAL, half_dir), 0.0), 32.0);
    //SPECULAR_LIGHT += LIGHT_COLOR * SPECULAR_AMOUNT * attenuation * spec * 0.08;
}