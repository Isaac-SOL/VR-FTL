@tool
class_name PickableRepairer extends XRToolsPickable

@export var repair_per_second: float = 0.1
@export var label_color: Gradient

var is_action_pressed: bool = false
var repair_targets: Array[OxygenLeak] = []
var current_target: OxygenLeak:
	set(new_value):
		current_target = new_value
		if current_target:
			%LabelFix.visible = true
		else:
			%LabelFix.visible = false

func _process(delta: float) -> void:
	if current_target:
		if action_pressed:
			current_target.fix_amount += delta * repair_per_second * Parameters.game_speed
		%LabelFix.text = str(floori(current_target.fix_amount * 100)) + "%"
		%LabelFix.modulate = label_color.sample(current_target.fix_amount)

func set_current_target():
	if repair_targets.is_empty():
		current_target = null
	else:
		current_target = repair_targets[0]
		var length = (global_position - current_target.global_position).length()
		for i in range(1, repair_targets.size()):
			if (global_position - repair_targets[i].global_position).length() < length:
				current_target = repair_targets[i]
				length = (global_position - repair_targets[i].global_position).length()

func _on_action_pressed(_pickable: Variant) -> void:
	is_action_pressed = true
	%ShootParticles.emitting = true
	%RepairingAudio.playing = true

func _on_action_released(pickable: Variant) -> void:
	is_action_pressed = false
	%ShootParticles.emitting = false
	%RepairingAudio.playing = false

func _on_damage_detector_area_entered(area: Area3D) -> void:
	var leak = area as OxygenLeak
	if leak and leak not in repair_targets:
		repair_targets.append(leak)
		if not current_target \
			or (global_position - current_target.global_position).length() \
				> (global_position - leak.global_position).length():
			current_target = leak

func _on_damage_detector_area_exited(area: Area3D) -> void:
	var leak = area as OxygenLeak
	if leak and leak in repair_targets:
		repair_targets.erase(leak)
		if leak == current_target:
			set_current_target()
