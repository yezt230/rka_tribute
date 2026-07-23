shader_type canvas_item;

uniform float edge_softness : hint_range(0.0, 0.2) = 0.02;

/*
    Controls how quickly the particle stops being white.

    0.0 = white transition begins immediately
    1.0 = remains white for almost its entire lifetime
*/
uniform float white_transition_end : hint_range(0.0, 1.0) = 1.0;

varying float particle_lifetime_progress;

void vertex() {
    particle_lifetime_progress = INSTANCE_CUSTOM.y;
}

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    vec2 center = vec2(0.5, 0.5);
    float dist_from_center = distance(UV, center);

    float progress = particle_lifetime_progress;

    // Expand the transparent hole over the particle's lifetime.
    float hole_radius = progress * 0.5;

    float alpha_mask = smoothstep(
        hole_radius,
        hole_radius + edge_softness,
        dist_from_center
    );

    /*
        At progress 0.0:
            color_mix = 0.0
            particle is white

        At white_transition_end:
            color_mix = 1.0
            particle has its original texture color
    */
    float color_mix = smoothstep(
        0.0,
        white_transition_end,
        progress
    );

    vec3 particle_color = mix(
        vec3(1.0),
        tex_color.rgb,
        color_mix
    );

    COLOR = vec4(
        particle_color,
        tex_color.a * alpha_mask
    );
}