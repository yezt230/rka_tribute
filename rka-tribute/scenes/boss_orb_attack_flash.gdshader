shader_type canvas_item;

uniform float flash_interval = 0.1;
uniform float white_strength = 0.8;

uniform vec4 red_color = vec4(1.0, 0.0, 0.0, 1.0);

/*
    UV radius notes:
    - center is UV 0.5, 0.5
    - edge of a perfect circle sprite is about 0.5
*/
uniform float inner_red_radius = 0.24;
uniform float outer_red_start = 0.36;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    float phase = floor(TIME / flash_interval);
    bool flash_white = mod(phase, 2.0) == 1.0;

    if (flash_white) {
        vec2 center = vec2(0.5, 0.5);
        float dist_from_center = distance(UV, center);

        bool in_inner_red_circle = dist_from_center <= inner_red_radius;
        bool in_outer_red_ring = dist_from_center >= outer_red_start;

        if (in_inner_red_circle || in_outer_red_ring) {
            COLOR = vec4(red_color.rgb, tex_color.a * red_color.a);
        } else {
            vec3 whitened_rgb = mix(tex_color.rgb, vec3(1.0), white_strength);
            COLOR = vec4(whitened_rgb, tex_color.a);
        }
    } else {
        COLOR = tex_color;
    }
}