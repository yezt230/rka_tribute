shader_type canvas_item;

uniform vec4 cover_color : source_color = vec4(0.35, 0.05, 0.55, 1.0);
uniform float progress : hint_range(0.0, 1.0) = 0.0;

uniform vec2 corner_offset_pixels = vec2(100.0, 100.0);

void fragment() {
	// Convert the 100-pixel offset into normalized screen coordinates.
	vec2 offset_uv = corner_offset_pixels * SCREEN_PIXEL_SIZE;

	// Bottom-right corner, shifted left and upward.
	vec2 iris_center = vec2(
		1.0 - offset_uv.x,
		1.0 - offset_uv.y
	);

	// Correct for the screen's aspect ratio so the iris remains circular.
	vec2 pixel_position = SCREEN_UV / SCREEN_PIXEL_SIZE;
	vec2 pixel_center = iris_center / SCREEN_PIXEL_SIZE;

	float distance_from_center = distance(pixel_position, pixel_center);

	// Find the distance from the iris center to the farthest screen corner.
	float screen_width = 1.0 / SCREEN_PIXEL_SIZE.x;
	float screen_height = 1.0 / SCREEN_PIXEL_SIZE.y;

	float maximum_radius = max(
		max(
			distance(pixel_center, vec2(0.0, 0.0)),
			distance(pixel_center, vec2(screen_width, 0.0))
		),
		max(
			distance(pixel_center, vec2(0.0, screen_height)),
			distance(pixel_center, vec2(screen_width, screen_height))
		)
	);

	float current_radius = maximum_radius * progress;

	// Slightly soften the circle's edge.
	float edge_softness = 2.0;
	float iris_mask = 1.0 - smoothstep(
		current_radius - edge_softness,
		current_radius + edge_softness,
		distance_from_center
	);

	COLOR = vec4(cover_color.rgb, cover_color.a * iris_mask);
}