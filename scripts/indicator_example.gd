@tool
extends Indicator

var max_hp: int

func set_reload(reload: int):
	var ratio := reload / 150.0
	%Load.degrees = ratio * 80

func set_angle(angle: float):
	%LabelAngle.text = str(floori(rad_to_deg(angle))) + "°"

func set_max_hp(hp: int):
	max_hp = hp
	%HP.material_override.set_shader_parameter("max_segments", max_hp)

func set_hp(hp: int):
	%HP.material_override.set_shader_parameter("visible_segments", max_hp)
