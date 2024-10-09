shader_type spatial;

uniform float fill_ratio: hint_range(0.0, 1.0) = 1.0;
uniform vec4 color_filled: source_color = vec4(0.0f, 1.0f, 0.0f, 1.0f);
uniform vec4 color_empty: source_color = vec4(1.0f, 0.0f, 0.0f, 1.0f);
uniform bool reverse = false;
uniform float emission = 0.0f;

void fragment() {
	bool condition = reverse ? UV.x > fill_ratio : (1.0f - UV.x) > fill_ratio;
	ALPHA = condition ? color_empty.a : color_filled.a;
	ALBEDO = condition ? color_empty.rgb : color_filled.rgb;
	if (emission > 0.0f) {
		EMISSION = (condition ? color_empty.rgb : color_filled.rgb) * emission;
	}
}
