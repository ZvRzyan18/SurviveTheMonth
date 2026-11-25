
shader_type canvas_item;

uniform sampler2D next_texture : source_color;
uniform float blend_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 current = texture(TEXTURE, UV);
    vec4 next = texture(next_texture, UV);

    COLOR = mix(current, next, blend_amount);
}
