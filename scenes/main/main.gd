extends Node

@export var end_screen: PackedScene


func _ready():
	%Player.health_component.died.connect(on_player_died)


func _unhandled_input(event):
	if event.is_action_pressed('pause'):
		%PauseMenu.pause()
		get_tree().root.set_input_as_handled()


func on_player_died():
	var end_screen_instance = end_screen.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
	MetaProgression.save()
