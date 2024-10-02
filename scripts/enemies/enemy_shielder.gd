class_name EnemyShielder extends EnemyBase

@export var max_shield_level: int = 1
@export var shield_cooldown: float = 5.0

func _ready() -> void:
	super()
	%ShieldTimer.wait_time = shield_cooldown
	%ShieldTimer.start()
	%Indicator.set_special_active(true)

func update_indicator() -> void:
	super.update_indicator()
	var reload: float = 1 - %ShieldTimer.time_left / %ShieldTimer.wait_time
	%Indicator.set_special_reload(reload)

func _on_shield_timer_timeout() -> void:
	var applied: bool = false
	for enemy: EnemyBase in get_tree().get_nodes_in_group("Enemy"):
		if enemy.shield < max_shield_level:
			enemy.shield += 1
			applied = true
	if applied:
		%ShieldAudio.play()
