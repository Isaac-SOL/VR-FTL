@tool
extends Indicator

var max_hp: int

func set_weapon_active(active: bool):
	$LabelWeapon.visible = active
	%Load.visible = active

func set_special_active(active: bool):
	$LabelSpecial.visible = active
	%SpecialLoad.visible = active

func set_reload(reload: float):
	%Load.degrees = reload * 80

func set_special_reload(reload: float):
	%SpecialLoad.degrees = reload * 80

func set_angle(_angle: float):
	pass

func set_max_hp(hp: int):
	max_hp = hp
	%HP.material_override.set_shader_parameter("max_segments", max_hp)

func set_hp(hp: int):
	%HP.material_override.set_shader_parameter("visible_segments", hp)

func set_shield(amount: int):
	%Shield.material_override.set_shader_parameter("visible_segments", amount)
	%Shield.visible = amount > 0

func set_ion(ratio: float):
	if ratio > 0 and not %LabelIon.visible:
		%LabelIon.visible = true
		%Ion.visible = true
	elif ratio == 0 and %LabelIon.visible:
		%LabelIon.visible = false
		%Ion.visible = false
	%Ion.degrees = ratio * 80
