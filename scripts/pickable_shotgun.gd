@tool
class_name PickableShotgun extends XRToolsPickable

@export var warmup: float = 0.7

var charge: float = 0:
	set(new_value):
		charge = new_value
		if not Engine.is_editor_hint():
			%LoadBar.modulate = Color.GREEN if charge >= warmup else Color.RED
			%LoadBar.scale.x = (charge / warmup) * base_scale

@onready var base_scale: float = %LoadBar.scale.x
var is_action_pressed: bool = false
var cell: PickableEnergyCell
var targets: Array[Projectile] = []

func _process(delta: float) -> void:
	if cell and cell.energy >= 3 and is_action_pressed:
		charge += delta
		if charge >= warmup:
			charge = warmup
	else:
		charge -= delta * 2
		if charge <= 0:
			charge = 0

func shoot():
	%ShootAudio.play()
	%ShootParticles.emitting = true
	for projectile: Projectile in targets:
		if is_instance_valid(projectile):
			projectile.destroy()
	targets = []

func _on_action_pressed(_pickable: Variant) -> void:
	is_action_pressed = true

func _on_action_released(_pickable: Variant) -> void:
	is_action_pressed = false
	if charge >= warmup and cell.energy >= 3:
		charge = 0
		cell.energy -= 3
		shoot()
	else:
		%EmptyAudio.play()

func _on_snap_zone_has_picked_up(what: Variant) -> void:
	cell = what as PickableEnergyCell

func _on_snap_zone_has_dropped() -> void:
	cell = null

func _on_damage_detector_body_entered(body: Node3D) -> void:
	var projectile := body as Projectile
	if projectile and projectile.is_in_group("EnemyProjectile") and projectile.destructible_by_physical:
		targets.append(projectile)

func _on_damage_detector_body_exited(body: Node3D) -> void:
	var projectile := body as Projectile
	if projectile and projectile in targets:
		targets.erase(projectile)
