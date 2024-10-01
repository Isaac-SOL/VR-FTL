shader_type spatial;
render_mode unshaded, shadows_disabled;

uniform vec3 color: source_color = vec3(0.0f, 0.6f, 0.0f);
uniform int max_segments = 3;
uniform int visible_segments = 3;
uniform float segment_spacing = 0.1f;
uniform bool last_space = false;
uniform bool reverse_order = false;

void fragment() {
	ALBEDO = color;

	int visible_spaces = last_space ? max_segments : max_segments - 1;
	float total_segment_spacing = segment_spacing * float(visible_spaces);
	float total_visible = 1.0f - total_segment_spacing;
	float segment_length = total_visible / float(max_segments);
	float offset = segment_length + segment_spacing;

	ALPHA = 0.0;
	float curr_offset = reverse_order ? offset * float(max_segments - 1) : 0.0f;
	for (int i = 0; i < visible_segments; ++i) {
		if (UV.x > curr_offset && UV.x < curr_offset + segment_length) {
			ALPHA = 1.0;
		}
		curr_offset += reverse_order ? -offset : offset;
	}
}
