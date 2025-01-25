shader_type canvas_item;

uniform vec4 color1 : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Color of the first checker
uniform vec4 color2 : source_color = vec4(0.0, 0.0, 0.0, 1.0); // Color of the second checker
uniform float size = 50.0; // Size of each square in the checkerboard
uniform vec2 camera_offset = vec2(0.0, 0.0); // Camera position offset (updated in the script)

void fragment() {
    // Adjust fragment position by camera offset
    vec2 world_pos = (FRAGCOORD.xy + camera_offset) / size;

    // Determine whether the square is "odd" or "even"
    float checker_value = mod(floor(world_pos.x) + floor(world_pos.y), 2.0);

    // Interpolate between the two colors based on checker_value
    COLOR = mix(color1, color2, checker_value);
}
