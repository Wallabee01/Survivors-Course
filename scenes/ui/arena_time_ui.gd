extends CanvasLayer

@export var arena_time_manager: Node

@onready var label = %Label


func _process(delta):
	if arena_time_manager == null:
		return
	
	var time_elapsed = arena_time_manager.get_time_elapsed()
	label.text = format_time_left(time_elapsed)


func format_time_left(time_elapsed: int):
	var minutes = time_elapsed / 60
	var seconds = time_elapsed - (minutes * 60)
	return str(minutes) + ":" + ("%02d" % seconds)
