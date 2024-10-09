@tool
class_name PickableSolarCell extends PickableEnergyCell

@export var recharge_interval: float = 10.0

var recharge_material1: ShaderMaterial
var recharge_material2: ShaderMaterial

func _ready() -> void:
	super._ready()
	%SolarTimer.wait_time = recharge_interval / Parameters.game_speed
	recharge_material1 = $RechargeIndicator1.material_override
	recharge_material2 = $RechargeIndicator2.material_override

func _process(_delta: float) -> void:
	if %SolarTimer.is_stopped():
		recharge_material1.set_shader_parameter("segment_spacing", 1)
		recharge_material2.set_shader_parameter("segment_spacing", 1)
	else:
		recharge_material1.set_shader_parameter("segment_spacing", %SolarTimer.time_left / %SolarTimer.wait_time)
		recharge_material2.set_shader_parameter("segment_spacing", %SolarTimer.time_left / %SolarTimer.wait_time)

func _on_solar_timer_timeout() -> void:
	if energy < max_energy:
		energy += 1
	if energy == max_energy:
		%SolarTimer.stop()

func _on_energy_changed(new_value: int) -> void:
	if not Engine.is_editor_hint():
		if new_value < max_energy and %SolarTimer.is_stopped():
			%SolarTimer.start()
