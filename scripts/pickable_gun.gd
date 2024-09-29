@tool
class_name PickableGun extends XRToolsPickable

@export var warmup: float = 0.7

@export_group("Materials")
@export var laser_bad_material: Material
@export var laser_good_material: Material

var charge: float = 0
@onready var base_scale = %LoadBar.scale.x

func _process(delta: float) -> void:
	charge += delta
	if charge >= warmup:
		charge = warmup
		%LoadBar.modulate = Color.GREEN
	else:
		%LoadBar.modulate = Color.RED
	%LoadBar.scale.x = (charge / warmup) * base_scale
	
	if %Laser.visible:
		var collider: Node3D = %ShootRayCast.get_collider()
		if collider and collider.is_in_group("EnemyProjectile"):
			%Laser.set_surface_override_material(0, laser_good_material)
		else:
			%Laser.set_surface_override_material(0, laser_bad_material)

func shoot():
	var collider: Node3D = %ShootRayCast.get_collider()
	if collider and collider.is_in_group("EnemyProjectile"):
		collider.queue_free()
		inject_energy()

func inject_energy():
	if %SnapZone.has_snapped_object() and %SnapZone.picked_up_object.has_method("add_energy"):
		%SnapZone.picked_up_object.add_energy()

func _on_action_pressed(_pickable: Variant) -> void:
	if charge >= warmup:
		charge = 0
		%ShootAudio.play()
		%ShootParticles.restart()
		shoot()
	else:
		%EmptyAudio.play()

func _on_grabbed(_pickable: Variant, _by: Variant) -> void:
	%Laser.visible = true

func _on_dropped(_pickable: Variant) -> void:
	%Laser.visible = false
