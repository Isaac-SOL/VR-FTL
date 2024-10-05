class_name EnemySpawner extends Node3D

signal enemy_spawned(enemy: EnemyBase)

@export var enemies: Array[PackedScene]
@export var weapons: Array[PackedScene]

@export var distance_min: float = 5.0
@export var distance_max: float = 7.0

func spawn_enemy() -> EnemyBase:
	var new_enemy = enemies.pick_random().instantiate() as EnemyBase
	new_enemy.position = Vector3.FORWARD.rotated(Vector3.UP, randf_range(0, TAU)) * randf_range(distance_min, distance_max)
	add_child(new_enemy)
	if new_enemy.attach_weapons:
		new_enemy.attach_weapon(weapons.pick_random())
	enemy_spawned.emit(new_enemy)
	return new_enemy
