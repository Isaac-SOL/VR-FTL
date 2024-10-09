class_name OxygenBar extends Node3D

@export var ok_color: Color = Color.GREEN
@export var bad_color: Color = Color.RED

func set_ratio(ratio: float):
	%OxygenBar.material_override.set_shader_parameter("fill_ratio", ratio);
	%LabelPercentage.text = str(floori(ratio * 100)) + "%\nO2"
	%LabelPercentage.modulate = ok_color if ratio > 0.5 else bad_color
