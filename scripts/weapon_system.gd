class_name WeaponSystem extends Node3D

@export var shoot_energy_cost: int = 3

@export_group("Materials")
@export var load_off: Material
@export var load_on: Material

var loaded: bool = true
var energy_cell: PickableEnergyCell

func _on_cylinder_slider_top_reached() -> void:
	loaded = true
	%LoadIndicator.set_surface_override_material(0, load_on)

func _on_cylinder_slider_bottom_reached() -> void:
	if loaded and energy_cell and energy_cell.energy >= shoot_energy_cost:
		%BigGun.shoot()
		%LoadIndicator.set_surface_override_material(0, load_off)
		loaded = false
		energy_cell.energy -= shoot_energy_cost

func _on_weapon_slider_slider_moved(_pos: Vector2, norm_pos: Vector2) -> void:
	%Targetor.set_norm_position(norm_pos)


func _on_cell_snap_zone_has_dropped() -> void:
	energy_cell = null

func _on_cell_snap_zone_has_picked_up(what: Variant) -> void:
	var cell := what as PickableEnergyCell
	if cell:
		energy_cell = cell
