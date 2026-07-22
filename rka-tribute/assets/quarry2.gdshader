shader_type canvas_item;

uniform float hue_shift : hint_range(-1.0, 1.0, 0.01) = 0.0;
uniform float saturation : hint_range(0.0, 2.0, 0.01) = 1.0;
uniform float brightness : hint_range(-1.0, 1.0, 0.01) = 0.0;
uniform float contrast : hint_range(0.0, 2.0, 0.01) = 1.0;
uniform float invert_amount : hint_range(0.0, 1.0, 0.01) = 0.0;


vec3 rgb_to_hsv(vec3 color) {
	vec4 k = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(
		vec4(color.bg, k.wz),
		vec4(color.gb, k.xy),
		step(color.b, color.g)
	);

	vec4 q = mix(
		vec4(p.xyw, color.r),
		vec4(color.r, p.yzx),
		step(p.x, color.r)
	);

	float difference = q.x - min(q.w, q.y);
	float epsilon = 1.0e-10;

	return vec3(
		abs(q.z + (q.w - q.y) / (6.0 * difference + epsilon)),
		difference / (q.x + epsilon),
		q.x
	);
}


vec3 hsv_to_rgb(vec3 color) {
	vec3 p = abs(
		fract(color.xxx + vec3(0.0, 2.0 / 3.0, 1.0 / 3.0))
		* 6.0 - 3.0
	);

	return color.z * mix(
		vec3(1.0),
		clamp(p - 1.0, 0.0, 1.0),
		color.y
	);
}


void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	vec3 color = texture_color.rgb;

	// Hue and saturation.
	vec3 hsv = rgb_to_hsv(color);
	hsv.x = fract(hsv.x + hue_shift);
	hsv.y = clamp(hsv.y * saturation, 0.0, 1.0);
	color = hsv_to_rgb(hsv);

	// Contrast around the midpoint.
	color = (color - vec3(0.5)) * contrast + vec3(0.5);

	// Brightness.
	color += vec3(brightness);

	// Optional inversion.
	color = mix(color, vec3(1.0) - color, invert_amount);

	COLOR = vec4(clamp(color, 0.0, 1.0), texture_color.a);
}