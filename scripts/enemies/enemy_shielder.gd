class_name EnemyShielder extends EnemyBase

@export var max_shield_level: int = 1
@export var shield_cooldown: float = 5.0

func _ready() -> void:
	super()
	%ShieldTimer.wait_time = shield_cooldown / Parameters.game_speed
	%ShieldTimer.start()
	%Indicator.set_special_active(true)
	started_ion.connect(_on_started_ion)
	stopped_ion.connect(_on_stopped_ion)

func update_indicator() -> void:
	super.update_indicator()
	var reload: float = 1 - %ShieldTimer.time_left / %ShieldTimer.wait_time
	%Indicator.set_special_reload(reload)

func _on_shield_timer_timeout() -> void:
	var applied: bool = false
	for enemy: EnemyBase in get_tree().get_nodes_in_group("Enemy"):
		if not enemy.is_ionized() and enemy.shield < max_shield_level:
			enemy.shield += 1
			applied = true
	if applied:
		%ShieldAudio.play()

func _on_started_ion():
	%ShieldTimer.paused = true

func _on_stopped_ion():
	%ShieldTimer.paused = false
