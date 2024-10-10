@tool
class_name BandCircleMesh extends MeshInstance3D

signal redrawn

@export var segments: int = 96:
	set(new_value):
		segments = new_value
		redraw_mesh()
@export var radius: float = 1.0:
	set(new_value):
		radius = new_value
		redraw_mesh()
@export var thickness: float = 0.2:
	set(new_value):
		thickness = new_value
		redraw_mesh()
@export var degrees: float = 360:
	set(new_value):
		degrees = new_value
		redraw_mesh()
@export var reverse: bool = false:
	set(new_value):
		reverse = new_value
		redraw_mesh()
@export var swap_uv: bool = false:
	set(new_value):
		swap_uv = new_value
		redraw_mesh()

func _ready() -> void:
	redraw_mesh()

func redraw_mesh():
	if segments <= 0: return
	var im_mesh := mesh as ImmediateMesh
	
	im_mesh.clear_surfaces()
	im_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	im_mesh.surface_set_normal(Vector3(0, 0, 1))
	
	var total_angle: float = deg_to_rad(degrees)
	var vert_pairs: int = segments + 1
	for i in range(vert_pairs):
		var ti = i if reverse else segments - i
		var fi: float = float(ti)
		var curr_angle: float = (total_angle / segments) * ti
		var vert_pos := Vector3.ZERO
		
		vert_pos.x = sin(curr_angle) * radius
		vert_pos.y = thickness / 2
		vert_pos.z = cos(curr_angle) * radius
		im_mesh.surface_set_uv(Vector2(1, fi / segments) if swap_uv
							   else Vector2(fi / segments, 1))
		im_mesh.surface_add_vertex(vert_pos)
		
		vert_pos.y = -thickness / 2
		im_mesh.surface_set_uv(Vector2(0, fi / segments) if swap_uv
							   else Vector2(fi / segments, 0))
		im_mesh.surface_add_vertex(vert_pos)
	
	im_mesh.surface_end()
	
	redrawn.emit()
