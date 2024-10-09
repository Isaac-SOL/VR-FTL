class_name MainXR extends Node3D

signal oxygen_changed(new_amount: int)

var xr_interface: XRInterface
@onready var sky_material: ShaderMaterial = %WorldEnvironment.environment.sky.sky_material
@onready var ship_ui: ShipUI = %ShipScreenContent.get_node("Viewport/ShipUI")
@onready var prev_core_hp: int = %Core.hp

var scrap: int = 0
var oxygen: int = 100: set = _set_oxygen

func _ready() -> void:
	Singletons.main = self
	Singletons.projectiles = %Projectiles
	Singletons.ship = %Ship
	Singletons.damages = %Damages
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")
		
		# Turn off monitor v-sync
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
		# Change viewport to HMD
		get_viewport().use_xr = true
	else:
		print("OpenXR not initialized, check if headset is connected")
	
	ship_ui.regenerate_shield_pressed.connect(func(): %Shield.hp = %Shield.max_hp)


func _on_navigation_system_started_moving(degrees: float, length: float) -> void:
	var curr_rotation: Vector3 = %Ship.rotation
	var new_rotation = curr_rotation + Vector3(0, deg_to_rad(degrees), 0)
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT).set_parallel()
	tween.tween_property(%Ship, "rotation", new_rotation, length)
	if Parameters.fixed_screen_rotation:
		var turns: float = degrees / 360.0
		var current_rotation: float = sky_material.get_shader_parameter("VerticalRotationA")
		var target_rotation: float = current_rotation + turns
		sky_material.set_shader_parameter("VerticalRotationB", target_rotation)
		tween.tween_method(
			func(rot: float): sky_material.set_shader_parameter("VerticalRotationA", rot),
			current_rotation, target_rotation, length)
		tween.tween_method(
			func(rot: float): sky_material.set_shader_parameter("VerticalRotationB", rot),
			target_rotation, target_rotation + turns, length)
		tween.tween_method(
			func(val: float): sky_material.set_shader_parameter("Blend", val),
			0.0, 1.0, length)
		await tween.finished
		sky_material.set_shader_parameter("VerticalRotationA", target_rotation + turns)
		sky_material.set_shader_parameter("Blend", 0.0)

func _on_core_hp_changed(new_hp: int) -> void:
	%CoreHP.material_override.set_shader_parameter("visible_segments", new_hp)

func _on_regenerate_shield() -> void:
	%Shield.hp = %Shield.max_hp

func _on_spawn_enemy_pressed() -> void:
	var new_enemy: EnemyBase = %EnemySpawner.spawn_enemy()
	new_enemy.destroyed.connect(_on_enemy_destroyed.bind(new_enemy))

func _on_enemy_spawner_enemy_spawned(enemy: EnemyBase) -> void:
	%NavigationSystem._on_enemy_spawned(enemy)

func _on_enemy_destroyed(_enemy: EnemyBase) -> void:
	scrap += 10
	ship_ui.set_scrap(scrap)

func _on_slow_pressed(on: bool) -> void:
	Engine.time_scale = 0.1 if on else 1.0

func _on_core_hit(_by: Projectile) -> void:
	if %Core.hp <= %Core.max_hp / 2 and prev_core_hp > %Core.max_hp / 2:
		%OmniScreenUI.flash_big_warning(OmniScreenUI.WARNING_HULL_50)
	elif %Core.hp <= %Core.max_hp * 0.2 and prev_core_hp > %Core.max_hp * 0.2:
		%OmniScreenUI.flash_big_warning(OmniScreenUI.WARNING_HULL_20)
	prev_core_hp = %Core.hp

func _set_oxygen(new_value: int) -> void:
	%OxygenBar.set_ratio(new_value / 100.0)
	if new_value <= 50 and oxygen > 50:
		%OmniScreenUI.flash_big_warning(OmniScreenUI.WARNING_O2_50)
	elif  new_value <= 25 and oxygen > 25:
		%OmniScreenUI.flash_big_warning(OmniScreenUI.WARNING_O2_25)
	
	oxygen = new_value
	if oxygen <= 0:
		print("Perduent!")
		Engine.time_scale = 0.01
	oxygen_changed.emit(oxygen)
