shader_type canvas_item;

uniform float flash_interval = 0.1;
uniform float white_strength = 0.8;

uniform float red_circle_radius = 0.24;
uniform vec4 red_circle_color = vec4(1.0, 0.0, 0.0, 1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    float phase = floor(TIME / flash_interval);
    bool flash_white = mod(phase, 2.0) == 1.0;

    if (flash_white) {
        vec3 whitened_rgb = mix(tex_color.rgb, vec3(1.0), white_strength);
        vec4 flash_color = vec4(whitened_rgb, tex_color.a);

        vec2 center = vec2(0.5, 0.5);
        float dist_from_center = distance(UV, center);

        if (dist_from_center <= red_circle_radius) {
            COLOR = vec4(red_circle_color.rgb, tex_color.a * red_circle_color.a);
        } else {
            COLOR = flash_color;
        }
    } else {
        COLOR = tex_color;
    }
}