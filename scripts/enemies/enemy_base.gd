class_name EnemyBase extends Area3D

signal destroyed
signal started_ion
signal stopped_ion

@export var max_hp: int = 3:
	set(new_value):
		max_hp = new_value
		%Indicator.set_max_hp(max_hp)
@export var attach_weapons: bool = true
@export var ion_pause: float = 10.0

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
	%IonTimer.wait_time = ion_pause
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
	%Indicator.set_ion(%IonTimer.time_left / ion_pause)
	if weapon: weapon.update_indicator()

func attach_weapon(wpn: PackedScene):
	weapon = wpn.instantiate() as WeaponBase
	%WeaponAttachPoint.add_child(weapon)

func get_ionized():
	%IonTimer.stop()
	%IonTimer.start()
	if weapon: weapon.pause()
	started_ion.emit()

func is_ionized() -> bool:
	return not %IonTimer.is_stopped()

func destroy(effect: bool = true) -> void:
	destroyed.emit()
	if effect:
		weapon.stop()
		%DestroyedAudio.play()
		$MeshInstance3D.visible = false
		%IonTimer.stop()
		%ExplosionParticles.emitting = true
		await %ExplosionParticles.finished
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	var projectile := body as Projectile
	if projectile and projectile.is_in_group("PlayerProjectile") and hp > 0:
		projectile.destroy()
		if projectile.ion:
			if shield > 0:
				shield -= 1
			%HitShieldAudio.play()
			get_ionized()
		else:
			if shield > 0:
				shield -= 1
				%HitShieldAudio.play()
			else:
				hp -= 1
				%HitAudio.play()
			if hp <= 0:
				destroy()

func _on_ion_timer_timeout() -> void:
	if weapon: weapon.unpause()
	stopped_ion.emit()
