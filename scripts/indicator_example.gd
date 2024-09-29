@tool
extends Indicator

var max_hp: int

func set_reload(reload: int):
	%LabelReload.text = str(reload) + " / 150"

func set_angle(angle: float):
	%LabelAngle.text = str(floori(rad_to_deg(angle))) + "°"

func set_max_hp(hp: int):
	max_hp = hp
	%LabelHP.text = str(max_hp) + " / " + str(max_hp)

func set_hp(hp: int):
	%LabelHP.text = str(hp) + " / " + str(max_hp)
