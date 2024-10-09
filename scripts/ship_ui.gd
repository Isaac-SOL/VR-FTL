class_name ShipUI extends CanvasLayer

signal regenerate_shield_pressed
signal spawn_enemy
signal slow_toggled(on: bool)

func _ready() -> void:
	await get_tree().process_frame
	regenerate_shield_pressed.connect(Singletons.main._on_regenerate_shield)
	spawn_enemy.connect(Singletons.main._on_spawn_enemy_pressed)
	slow_toggled.connect(Singletons.main._on_slow_pressed)

func output_message(msg: String) -> void:
	%LabelMessage.text = msg

func set_scrap(amount: int) -> void:
	%LabelScrap.text = str(amount) + " Scrap"

func _on_button_1_pressed() -> void:
	output_message("Button 1 pressed!")

func _on_button_2_pressed() -> void:
	output_message("Button 2 pressed!")

func _on_button_shield_pressed() -> void:
	regenerate_shield_pressed.emit()

func _on_button_spawn_pressed() -> void:
	spawn_enemy.emit()

func _on_button_slow_toggled(toggled_on: bool) -> void:
	slow_toggled.emit(toggled_on)
