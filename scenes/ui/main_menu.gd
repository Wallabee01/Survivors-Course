extends CanvasLayer


func _ready():
	%PlayButton.pressed.connect(on_play_pressed)
	%OptionsButton.pressed.connect(on_options_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)


func on_play_pressed():
	SceneTransition.transition()
	await SceneTransition.transitioned_halfway
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_options_pressed():
	SceneTransition.transition()
	await SceneTransition.transitioned_halfway
	%OptionsMenu.visible = true


func on_quit_pressed():
	get_tree().quit()
