shader_type canvas_item;

uniform float edge_softness : hint_range(0.0, 0.2) = 0.02;

varying float particle_lifetime_progress;

void vertex() {
    /*
        For GPUParticles2D:
        INSTANCE_CUSTOM.y is the particle lifetime phase.
        0.0 = newly spawned
        1.0 = near end of lifetime
    */
    particle_lifetime_progress = INSTANCE_CUSTOM.y;
}

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    vec2 center = vec2(0.5, 0.5);
    float dist_from_center = distance(UV, center);

    float progress = particle_lifetime_progress;

    /*
        Circle sprite radius is approximately 0.5 in UV space.
        As progress grows, the transparent hole expands from the center.
    */
    float hole_radius = progress * 0.5;

    float alpha_mask = smoothstep(
        hole_radius,
        hole_radius + edge_softness,
        dist_from_center
    );

    COLOR = vec4(tex_color.rgb, tex_color.a * alpha_mask);
}