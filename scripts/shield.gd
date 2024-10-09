class_name Shield extends Area3D

signal amount_changed(new_amount: int)

@export var max_hp: int = 5

var leak := preload("res://objects/oxygen_leak.tscn")

@onready var hp: int = max_hp:
	set(new_value):
		hp = new_value
		amount_changed.emit(hp)

func _on_body_entered(body: Node3D) -> void:
	var projectile := body as Projectile
	
	if not projectile or not projectile.is_in_group("EnemyProjectile"): return
	
	projectile.destroy(true, false)
	
	hp -= 1
	
	if projectile.causes_leaks:
		var new_leak = leak.instantiate() as OxygenLeak
		new_leak.position = projectile.global_position
		Singletons.damages.add_child(new_leak)
	
	%HitSound.global_position = projectile.global_position
	%HitSound.play()
	if hp <= 0:
		%DownSound.play()
		set_deferred("monitoring", false)
		%AnimationPlayer.play("down")
	else:
		if %AnimationPlayer.current_animation == "up":
			%AnimationPlayer.queue("hit")
		else:
			%AnimationPlayer.play("hit")

func is_maxed() -> bool:
	return hp >= max_hp

func is_empty() -> bool:
	return hp == 0

func add_one() -> void:
	if is_maxed(): return
	if hp <= 0:
		%AnimationPlayer.play("up")
	hp += 1
	set_deferred("monitoring", true)

func regenerate() -> void:
	if hp <= 0:
		%AnimationPlayer.play("up")
	hp = max_hp
	set_deferred("monitoring", true)
