class_name Targetor extends RayCast3D

@export var min_rotation: Vector2 = Vector2(-PI/4, -PI/4)
@export var max_rotation: Vector2 = Vector2(PI/4, PI/4)
@export var swap_x: bool = false
@export var swap_y: bool = false
@export var swap_axes: bool = false

var base_rotation: Vector3

func _ready() -> void:
	base_rotation = rotation

func set_norm_position(pos: Vector2):
	var rot :=  pos * (max_rotation - min_rotation) + min_rotation
	rotation = base_rotation
	# Yes this is swapped on purpose, translation on X axis "maps" to rotation on Y axis
	var rot_x = rot.x if swap_axes else rot.y
	var rot_y = rot.y if swap_axes else rot.x
	if swap_x: rot_x = -rot_x
	if swap_y: rot_y = -rot_y
	rotate_x(rot_x)
	rotate_y(rot_y)

func _process(_delta: float) -> void:
	if is_colliding():
		%TrueTarget.global_position = get_collision_point()
	else:
		%TrueTarget.global_position = %TargetOrigin.global_position

func get_true_target() -> Node3D:
	return %TrueTarget
