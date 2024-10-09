class_name EnemyOrbital extends EnemyBase

@export var degrees_per_second: float = 10.0

var paused = false

func _ready() -> void:
	super()
	started_ion.connect(_on_started_ion)
	stopped_ion.connect(_on_stopped_ion)

func frame(delta: float):
	if not paused:
		angle += deg_to_rad(degrees_per_second / Parameters.game_speed) * delta
		global_position = (Vector3.FORWARD * dist).rotated(Vector3.UP, angle) + Vector3(0, 1.7, 0)

func _on_started_ion():
	paused = true

func _on_stopped_ion():
	paused = false
