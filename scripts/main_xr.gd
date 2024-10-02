class_name MainXR extends Node3D

var xr_interface: XRInterface

func _ready() -> void:
	Singletons.main = self
	Singletons.projectiles = %Projectiles
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")
		
		# Turn off monitor v-sync
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
		# Change viewport to HMD
		get_viewport().use_xr = true
	else:
		print("OpenXR not initialized, check if headset is connected")


func _on_navigation_system_started_moving(degrees: float, length: float) -> void:
	var curr_rotation: Vector3 = %Ship.rotation
	var new_rotation = curr_rotation + Vector3(0, deg_to_rad(degrees), 0)
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(%Ship, "rotation", new_rotation, length)

func _on_core_hp_changed(new_hp: int) -> void:
	%CoreHP.material_override.set_shader_parameter("visible_segments", new_hp)

func _on_spawn_enemy_pressed() -> void:
	%EnemySpawner.spawn_enemy()
