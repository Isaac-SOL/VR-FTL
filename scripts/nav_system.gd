class_name NavigationSystem extends Node3D

signal started_moving(degrees: float, length: float)
signal stopped_moving

@export var degrees_per_second: float = 45.0
@export var enemy_viewer_scene: PackedScene
@export_group("Materials")
@export var idle_material: Material
@export var moving_material: Material

var energy_cell: PickableEnergyCell
var reset_tween: Tween
var moving: bool = false
var enemy_viewers: Dictionary = {}

func _process(_delta: float) -> void:
	for enemy in enemy_viewers.keys():
		enemy_viewers[enemy].position = enemy_position_transform(enemy.global_position)
	%EnemiesOrigin.rotation.y = -Singletons.ship.global_rotation.y

func enemy_position_transform(global_pos: Vector3) -> Vector3:
	var local_pos: Vector3 = global_pos / 100.0
	local_pos = local_pos.rotated(Vector3.UP, PI)
	local_pos.y = 0
	return local_pos

func spawn_enemy_viewer(pos: Vector3) -> Node3D:
	var viewer: Node3D = enemy_viewer_scene.instantiate()
	viewer.position = enemy_position_transform(pos)
	%EnemiesOrigin.add_child(viewer)
	return viewer

func _on_cell_snap_zone_has_dropped() -> void:
	energy_cell = null

func _on_cell_snap_zone_has_picked_up(what: Variant) -> void:
	var cell := what as PickableEnergyCell
	if cell:
		energy_cell = cell

func _on_big_red_button_button_pressed(_button: Variant) -> void:
	if moving: return
	if %OrientableHinge.hinge_position == 0: return
	if energy_cell and energy_cell.energy >= 1:
		energy_cell.energy -= 1
		moving = true
		%OrientableHinge.set_interactable(false)
		%MovingIndicator.set_surface_override_material(0, moving_material)
		var length := absf(%OrientableHinge.hinge_position) / degrees_per_second
		reset_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		reset_tween.tween_property(%OrientableHinge, "hinge_position", 0, length)
		started_moving.emit(%OrientableHinge.hinge_position, length)
		
		await reset_tween.finished
		
		moving = false
		%OrientableHinge.set_interactable(true)
		%MovingIndicator.set_surface_override_material(0, idle_material)
		stopped_moving.emit()

func _on_enemy_spawned(enemy: EnemyBase) -> void:
	enemy.destroyed.connect(_on_enemy_destroyed.bind(enemy))
	var viewer := spawn_enemy_viewer(enemy.global_position)
	enemy_viewers[enemy] = viewer

func _on_enemy_destroyed(enemy: EnemyBase) -> void:
	enemy_viewers[enemy].queue_free()
	enemy_viewers.erase(enemy)
