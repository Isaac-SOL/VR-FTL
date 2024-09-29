@tool
class_name IndicatorProjectile extends Indicator

@export var distance_fade_in_start: float = 2.5
@export var distance_fade_in_end: float = 2.0
@export var color_over_distance: Gradient
@export var color_change_start: float = 2.0
@export var color_change_end: float = 0.5

func distance_to_transparency(distance: float) -> float:
	var far: float = smoothstep(distance_fade_in_end, distance_fade_in_start, distance)
	var close: float = 1 - smoothstep(-0.5, 0.0, distance)
	return far + close

func distance_to_color(distance: float) -> Color:
	var pos: float = smoothstep(color_change_end, color_change_start, distance)
	return color_over_distance.sample(pos)

func distance_display(distance: float) -> String:
	var res: String = str(floori(distance * 100) / 10.0)
	if "." not in res: res += ".0"
	return res

func set_distance(distance: float):
	%LabelDistance.text = distance_display(distance)
	var alpha := distance_to_transparency(distance)
	%Crosshair.transparency = alpha
	%LabelDistance.transparency = alpha if distance > 0 else 1.0
	var color := distance_to_color(distance)
	%Crosshair.modulate = color
	%LabelDistance.modulate = color
