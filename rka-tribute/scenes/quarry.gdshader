shader_type canvas_item;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);

	vec3 inverted_color = vec3(1.0) - original_color.rgb;

	COLOR = vec4(inverted_color, original_color.a);
}