@tool
class_name PickableEnergyCell extends XRToolsPickable

@export var max_energy: int = 3
@export var energy: int = 0: set = _set_energy
@export_group("Materials")
@export var on_material: Material
@export var off_material: Material


var energy_lights: Array[MeshInstance3D] = []

func _ready() -> void:
	super._ready()
	for child: MeshInstance3D in %Energy.get_children():
		energy_lights.append(child)

func add_energy() -> bool:
	if energy < max_energy:
		energy += 1
		return true
	return false

func _set_energy(new_value: int):
	energy = new_value
	for i: int in range(energy_lights.size()):
		if i < energy:
			energy_lights[i].material_override = on_material
		else:
			energy_lights[i].material_override = off_material
