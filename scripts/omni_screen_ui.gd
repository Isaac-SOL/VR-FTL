class_name OmniScreenUI extends Node3D

const WARNING_HULL_50: String = "WARNING\nHull <50%"
const WARNING_HULL_20: String = "WARNING\nHULL CRITICAL"
const WARNING_O2_50: String = "WARNING\nOXYGEN <50%"
const WARNING_O2_25: String = "WARNING\nOXYGEN CRITICAL"

var big_warning_labels: Array[Label3D] = []

func _ready() -> void:
	for child in %BigWarning.get_children():
		big_warning_labels.append(child as Label3D)

func flash_big_warning(text: String):
	%BigWarningAudio.play()
	for label: Label3D in big_warning_labels:
		label.text = text
	%BigWarning.visible = true
	await get_tree().create_timer(1.0).timeout
	%BigWarning.visible = false
	await get_tree().create_timer(0.2).timeout
	%BigWarning.visible = true
	await get_tree().create_timer(1.0).timeout
	%BigWarning.visible = false
	await get_tree().create_timer(0.2).timeout
	%BigWarning.visible = true
	await get_tree().create_timer(1.0).timeout
	%BigWarning.visible = false
