class_name OxygenLeak extends Area3D

@export var oxygen_per_second: float = 2.0

var next_leak: float
var fix_amount: float = 0.0:
	set(new_value):
		fix_amount = new_value
		if fix_amount >= 1:
			queue_free()

func _ready() -> void:
	next_leak = 1 / (oxygen_per_second * Parameters.game_speed)

func reset_lookat():
	look_at(Indicator.SHIELD_CENTER)

func _process(delta: float) -> void:
	next_leak -= delta
	while next_leak < 0:
		Singletons.main.oxygen -= 1
		next_leak += 1 / (oxygen_per_second * Parameters.game_speed)
