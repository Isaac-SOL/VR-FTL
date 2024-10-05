class_name EnemyBase extends Area3D

signal destroyed

@export var max_hp: int = 3:
	set(new_value):
		max_hp = new_value
		%Indicator.set_max_hp(max_hp)
@export var attach_weapons: bool = true

const max_shield = 5

@onready var angle: float = get_angle()
@onready var dist: float = global_position.distance_to(Vector3(0, 1.7, 0))
@onready var hp: int = max_hp:
	set(new_value):
		hp = new_value
		%Indicator.set_hp(hp)
@onready var shield: int = 0:
	set(new_value):
		shield = new_value
		%Indicator.set_shield(new_value)

var weapon: WeaponBase:
	set(new_value):
		weapon = new_value
		if weapon: weapon.indicator = %Indicator
		%Indicator.set_weapon_active(is_instance_valid(weapon))

func _ready() -> void:
	%Indicator.set_max_hp(max_hp)
	%Indicator.set_hp(hp)
	if %WeaponAttachPoint.get_child_count() > 0:
		weapon = %WeaponAttachPoint.get_child(0)
	else:
		%Indicator.set_weapon_active(false)

func _process(delta: float) -> void:
	frame(delta)
	look_at(Vector3(0, 1.7, 0), Vector3.UP, true)
	update_indicator()

func get_angle():
	var theta := (global_position - Vector3(0, 1.7, 0)).signed_angle_to(Vector3.FORWARD, Vector3.UP)
	if theta < 0: theta += TAU
	return theta

func frame(_delta: float):
	pass

func update_indicator():
	%Indicator.set_angle(get_angle())
	if weapon: weapon.update_indicator()

func attach_weapon(wpn: PackedScene):
	weapon = wpn.instantiate() as WeaponBase
	%WeaponAttachPoint.add_child(weapon)

func destroy(effect: bool = true) -> void:
	destroyed.emit()
	if effect:
		weapon.stop()
		%DestroyedAudio.play()
		$MeshInstance3D.visible = false
		%ExplosionParticles.emitting = true
		await %ExplosionParticles.finished
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("PlayerProjectile") and hp > 0:
		body.destroy()
		if shield > 0:
			shield -= 1
			%HitShieldAudio.play()
		else:
			hp -= 1
			%HitAudio.play()
		if hp <= 0:
			destroy()
