shader_type spatial;
render_mode unshaded, shadows_disabled;

uniform vec3 color: source_color = vec3(0.0f, 0.6f, 0.0f);
uniform int max_segments = 3;
uniform int visible_segments = 3;
uniform float segment_spacing = 0.1f;

void fragment() {
	ALBEDO = color;

	float total_segment_spacing = segment_spacing * float(max_segments - 1);
	float total_visible = 1.0f - total_segment_spacing;
	float segment_length = total_visible / float(max_segments);
	float offset = segment_length + segment_spacing;

	ALPHA = 0.0;
	float curr_offset = 0.0f;
	for (int i = 0; i < visible_segments; ++i) {
		if (UV.x > curr_offset && UV.x < curr_offset + segment_length) {
			ALPHA = 1.0;
		}
		curr_offset += offset;
	}
}
