class_name WeaponBase extends Node3D

@export var projectile_scene: PackedScene
@export var shoot_impulse: float = 1
@export var weapon_cooldown: float = 4.5
@export var shots: int = 1
@export var shot_interval: float = 0.5
@export var indicator: Indicator

@onready var dist: float = global_position.distance_to(Vector3(0, 1.7, 0))
@onready var ship: EnemyBase = get_parent().get_parent()

func _ready() -> void:
	%ShootTimer.wait_time = weapon_cooldown
	%ShootTimer.start()

func _process(_delta: float) -> void:
	var reload: float = 1 - %ShootTimer.time_left / %ShootTimer.wait_time
	indicator.set_reload(reload)

func shoot():
	var direction: Vector3 = global_basis.x.normalized()
	direction = direction.rotated(global_basis.y.normalized(), randf() * TAU)
	
	var projectile: RigidBody3D = projectile_scene.instantiate()
	projectile.target = Singletons.core
	Singletons.projectiles.add_child(projectile)
	projectile.global_position = global_position
	projectile.apply_central_impulse(direction * shoot_impulse)
	%ShootAudio.play()

func update_indicator():
	var reload: float = 1 - %ShootTimer.time_left / %ShootTimer.wait_time
	indicator.set_reload(reload)

func stop():
	%ShootTimer.stop()

func pause():
	%ShootTimer.paused = true

func unpause():
	%ShootTimer.paused = false

func _on_shoot_timer_timeout() -> void:
	for i in range(shots):
		if not %ShootTimer.is_stopped():
			shoot()
			await get_tree().create_timer(shot_interval).timeout
