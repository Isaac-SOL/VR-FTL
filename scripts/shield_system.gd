class_name ShieldSystem extends Node3D

signal shield_renegerated(amount: int)

@export var shield: Shield

@export_group("Materials")
@export var load_off: Material
@export var load_on: Material

var loaded: bool = true
var energy_cell: PickableEnergyCell

func _ready() -> void:
	shield.amount_changed.connect(_on_shield_amount_changed)
	update_text()

func update_text() -> void:
	%AmountLabel.text = str(shield.hp) + " / " + str(shield.max_hp)

func _on_shield_amount_changed(_new_amount: int):
	update_text()

func _on_cylinder_slider_top_reached() -> void:
	loaded = true
	%LoadIndicator.set_surface_override_material(0, load_on)

func _on_cylinder_slider_bottom_reached() -> void:
	if loaded and energy_cell and energy_cell.energy >= 1 and not shield.is_maxed():
		shield.add_one()
		shield_renegerated.emit(1)
		%LoadIndicator.set_surface_override_material(0, load_off)
		loaded = false
		energy_cell.energy -= 1

func _on_cell_snap_zone_has_dropped() -> void:
	energy_cell = null

func _on_cell_snap_zone_has_picked_up(what: Variant) -> void:
	var cell := what as PickableEnergyCell
	if cell:
		energy_cell = cell
