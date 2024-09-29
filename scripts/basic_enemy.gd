extends Area3D

@export var projectile_scene: PackedScene
@export var shoot_impulse: float = 100
@export var move_speed: float = PI / 20
@export var max_hp: int = 3

@onready var angle: float = get_angle()
@onready var dist: float = global_position.distance_to(Vector3(0, 1.7, 0))
@onready var hp = max_hp

func _ready() -> void:
	%Indicator.set_max_hp(max_hp)

func _process(delta: float) -> void:
	move(delta)
	update_indicator()

func get_angle():
	var theta := (global_position - Vector3(0, 1.7, 0)).signed_angle_to(Vector3.FORWARD, Vector3.UP)
	if theta < 0: theta += TAU
	return theta

func move(delta: float):
	angle += move_speed * delta
	global_position = (Vector3.FORWARD * dist).rotated(Vector3.UP, angle) + Vector3(0, 1.7, 0)
	look_at(Vector3(0, 1.7, 0), Vector3.UP, true)

func shoot():
	var direction: Vector3 = %ShootSource.global_basis.x.normalized()
	direction = direction.rotated(%ShootSource.global_basis.y.normalized(), randf() * TAU)
	
	var projectile: RigidBody3D = projectile_scene.instantiate()
	projectile.target = Singletons.core
	get_parent().add_child(projectile)
	projectile.global_position = %ShootSource.global_position
	projectile.apply_central_impulse(direction * shoot_impulse)
	%ShootAudio.play()

func update_indicator():
	var reload: int = floori((1 - %ShootTimer.time_left / %ShootTimer.wait_time) * 150)
	%Indicator.set_reload(reload)
	%Indicator.set_angle(get_angle())

func _on_timer_timeout() -> void:
	shoot()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("PlayerProjectile"):
		body.queue_free()
		hp -= 1
		%Indicator.set_hp(hp)
		if hp <= 0:
			queue_free()
