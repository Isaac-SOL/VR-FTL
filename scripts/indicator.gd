@tool
class_name Indicator extends Node3D

const SHIELD_CENTER := Vector3(0, 1.7, 0)

@export var visible_on_ready: bool = true
@export var editor_preview: bool = false

func _ready() -> void:
	if not Engine.is_editor_hint():
		if visible_on_ready: visible = true

func _process(_delta: float) -> void:
	if editor_preview or not Engine.is_editor_hint():
		var parent := get_parent_node_3d()
		if parent:
			var norm: Vector3 = (parent.global_position - SHIELD_CENTER).normalized()
			global_position = SHIELD_CENTER + norm * 2.5
		if global_position.x != 0 or global_position.z != 0:
			look_at(SHIELD_CENTER)
