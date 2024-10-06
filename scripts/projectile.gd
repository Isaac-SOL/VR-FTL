class_name Projectile extends RigidBody3D

@export var correction_force: float = 10
@export var kill_timer: float = 0
@export var ion: bool = false

var target: Node3D

func _ready() -> void:
	if kill_timer > 0:
		await get_tree().create_timer(kill_timer).timeout
		destroy(true, false)

func _process(_delta: float) -> void:
	if target:
		var distance := (target.global_position - global_position).length()
		%IndicatorProjectile.set_distance(distance - 2.2)

func _physics_process(_delta: float) -> void:
	if target:
		var direction := (target.global_position - global_position).normalized()
		apply_force(direction * correction_force)

func destroy(effect: bool = true, intense: bool = true):
	if effect:
		%MeshInstance3D.visible = false
		%IndicatorProjectile.visible = false
		freeze = true
		set_deferred("collision_layer", 0)
		if not intense:
			%ExplosionParticles.amount_ratio = 0.3
		%ExplosionParticles.emitting = true
		await %ExplosionParticles.finished
	queue_free()

func _on_body_entered(_body: Node) -> void:
	await get_tree().create_timer(10).timeout
	destroy(true, false)
