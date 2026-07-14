shader_type canvas_item;

uniform vec4 cover_color : source_color = vec4(0.45, 0.0, 0.6, 1.0);

// 0.0 = normal screen
// 1.0 = completely purple
uniform float progress : hint_range(0.0, 1.0) = 0.0;

uniform vec2 corner_offset_pixels = vec2(100.0, 100.0);
uniform float edge_softness_pixels : hint_range(0.0, 20.0) = 2.0;

void fragment() {
	vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 pixel_position = SCREEN_UV * screen_size;

	// Focus point: 100 px left and 100 px above the bottom-right corner.
	vec2 iris_center = screen_size - corner_offset_pixels;

	// Determine the distance to the farthest screen corner.
	float maximum_radius = max(
		max(
			distance(iris_center, vec2(0.0, 0.0)),
			distance(iris_center, vec2(screen_size.x, 0.0))
		),
		max(
			distance(iris_center, vec2(0.0, screen_size.y)),
			distance(iris_center, screen_size)
		)
	);

	/*
		Start slightly larger than necessary so no purple is visible
		at progress 0. At progress 1, the transparent circle has
		shrunk completely into the focal point.
	*/
	float starting_radius = maximum_radius + edge_softness_pixels;
	float current_radius = mix(starting_radius, 0.0, progress);

	float distance_from_center = distance(pixel_position, iris_center);

	// Transparent inside the circle; purple outside it.
	float purple_mask = smoothstep(
		current_radius - edge_softness_pixels,
		current_radius + edge_softness_pixels,
		distance_from_center
	);

	COLOR = vec4(
		cover_color.rgb,
		cover_color.a * purple_mask
	);
}