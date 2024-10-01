class_name ShipCore extends RigidBody3D

signal hp_changed(new_hp: int)

@export var max_hp: int = 10

@onready var hp: int = max_hp

func _ready() -> void:
	Singletons.core = self

func check_hp():
	if hp <= 0:
		hp = 0
		print("Perduent!")
		queue_free()
	hp_changed.emit(hp)

func update_label():
	if hp <= 0:
		%LabelHP.text = "Perduent!"
	else:
		%LabelHP.text = str(hp) + " / " + str(max_hp)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("EnemyProjectile"):
		body.queue_free()
		hp -= 1
		check_hp()
