shader_type canvas_item;

uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // The color to tint with.

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Calculate the intensity of the current pixel (assuming grayscale sprite).
    float intensity = tex_color.r; // Grayscale assumption: r = g = b
    
    // Interpolate between the tint color (for black) and white (for white areas).
    vec4 final_color = mix(tint_color, vec4(1.0), intensity);
    
    // Preserve alpha from the texture.
    final_color.a = tex_color.a;

	// Set color to red
	// COLOR = vec4(1.0, 0.0, 0.0, 1.0);
    COLOR = final_color;
}
