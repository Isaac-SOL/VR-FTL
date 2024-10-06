class_name ShipCore extends RigidBody3D

signal hp_changed(new_hp: int)
signal hit(by: Projectile)

@export var max_hp: int = 10

@onready var hp: int = max_hp:
	set(new_value):
		hp = new_value
		hp_changed.emit(hp)

func _ready() -> void:
	Singletons.core = self

func check_hp():
	if hp <= 0:
		hp = 0
		print("Perduent!")
		queue_free()

func update_label():
	if hp <= 0:
		%LabelHP.text = "Perduent!"
	else:
		%LabelHP.text = str(hp) + " / " + str(max_hp)

func _on_body_entered(body: Node) -> void:
	var projectile := body as Projectile
	if projectile and projectile.is_in_group("EnemyProjectile"):
		projectile.destroy()
		hp -= 1
		%HitAudio.play()
		check_hp()
		hit.emit(projectile)
