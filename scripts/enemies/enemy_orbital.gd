class_name EnemyOrbital extends EnemyBase

@export var degrees_per_second: float = 10.0

func frame(delta: float):
	angle += deg_to_rad(degrees_per_second) * delta
	global_position = (Vector3.FORWARD * dist).rotated(Vector3.UP, angle) + Vector3(0, 1.7, 0)
