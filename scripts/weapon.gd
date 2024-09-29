extends AnimatableBody3D

@export var targetor: Targetor:
	set(new_value):
		targetor = new_value
		target = targetor.get_true_target()

@export var projectile_scene: PackedScene
@export var projectile_impulse: float = 100

var target: Node3D

func _ready() -> void:
	target = targetor.get_true_target()

func _process(_delta: float) -> void:
	look_at(target.global_position)

func shoot():
	%ShootAudio.play()
	%Flash.visible = true
	
	var projectile: RigidBody3D = projectile_scene.instantiate()
	get_parent_node_3d().add_child(projectile)
	projectile.global_position = %Flash.global_position
	projectile.apply_impulse(-global_basis.z * projectile_impulse)
	
	await get_tree().create_timer(0.1).timeout
	%Flash.visible = false
