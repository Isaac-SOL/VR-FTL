class_name Projectile extends RigidBody3D

@export var correction_force: float = 10

var target: Node3D

func _process(_delta: float) -> void:
	if target:
		var distance := (target.global_position - global_position).length()
		%IndicatorProjectile.set_distance(distance - 2.2)

func _physics_process(_delta: float) -> void:
	if target:
		var direction := (target.global_position - global_position).normalized()
		apply_force(direction * correction_force)

func _on_body_entered(_body: Node) -> void:
	await get_tree().create_timer(10).timeout
	queue_free()
