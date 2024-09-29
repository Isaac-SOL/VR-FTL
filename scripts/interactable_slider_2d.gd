@tool
class_name XRToolsInteractableSlider2D
extends XRToolsInteractableHandleDriven


## XR Tools Interactable Slider script
##
## The interactable slider is a slider transform node controlled by the
## player through [XRToolsInteractableHandle] instances.
##
## The slider translates itelf along its local X axis, and so should be
## placed as a child of a node to translate and rotate as appropriate.
##
## The interactable slider is not a [RigidBody3D], and as such will not react
## to any collisions.


## Signal for slider moved
signal slider_moved(position: Vector2, norm_position: Vector2)


## Slider minimum limit
@export var slider_limit_min : Vector2 = Vector2.ZERO

## Slider maximum limit
@export var slider_limit_max : Vector2 = Vector2.ONE

## Slider step size (zero for no steps)
@export var slider_steps : Vector2 = Vector2.ZERO

## Slider position
@export var slider_position : Vector2 = Vector2.ZERO: set = _set_slider_position

## Default position
@export var default_position : Vector2 = Vector2.ZERO

## If true, the slider moves to the default position when released
@export var default_on_release : bool = false


# Add support for is_xr_class on XRTools classes
func is_xr_class(name : String) -> bool:
	return name == "XRToolsInteractableSlider" or super(name)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# In Godot 4 we must now manually call our super class ready function
	super()

	# Set the initial position to match the initial slider position value
	transform = Transform3D(
		Basis.IDENTITY,
		Vector3(slider_position.x, slider_position.y, 0.0)
	)

	# Connect signals
	if released.connect(_on_slider_released):
		push_error("Cannot connect slider released signal")


# Called every frame when one or more handles are held by the player
func _process(_delta: float) -> void:
	# Get the total handle offsets
	var offset_sum := Vector3.ZERO
	for item in grabbed_handles:
		var handle := item as XRToolsInteractableHandle
		offset_sum += handle.global_transform.origin - handle.handle_origin.global_transform.origin

	# Rotate the offset sum vector from global into local coordinate space
	offset_sum = offset_sum * global_transform.basis

	# Get the average displacement in the X and Y axes
	var offset := Vector2(offset_sum.x, offset_sum.y) / grabbed_handles.size()

	# Move the slider by the requested offset
	move_slider(slider_position + offset)

func norm_slider_position() -> Vector2:
	return (slider_position - slider_limit_min) / (slider_limit_max - slider_limit_min)

# Move the slider to the specified position
func move_slider(pos: Vector2) -> void:
	# Do the slider move
	pos = _do_move_slider(pos)
	if pos == slider_position:
		return

	# Update the current position
	slider_position = pos

	# Emit the moved signal
	slider_moved.emit(pos, norm_slider_position())


# Handle release of slider
func _on_slider_released(_interactable: XRToolsInteractableSlider2D):
	if default_on_release:
		move_slider(default_position)


# Called when the slider position is set externally
func _set_slider_position(pos: Vector2) -> void:
	pos = _do_move_slider(pos)
	slider_position = pos


# Do the slider move
func _do_move_slider(pos: Vector2) -> Vector2:
	# Apply slider step-quantization
	if slider_steps:
		pos = ((pos / slider_steps) * slider_steps).round()

	# Apply slider limits
	pos = pos.clamp(slider_limit_min, slider_limit_max)

	# Move if necessary
	if pos != slider_position:
		transform.origin.x = pos.x
		transform.origin.y = pos.y

	# Return the updated position
	return pos
