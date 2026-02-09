shader_type canvas_item;

uniform float top_scale : hint_range(0.0, 2.0) = 1.2;
uniform float bottom_scale : hint_range(0.0, 2.0) = 1.0;

void vertex() {
    float t = UV.y; // 0 = top, 1 = bottom
    float scale = mix(top_scale, bottom_scale, t);
    VERTEX.x *= scale;
}