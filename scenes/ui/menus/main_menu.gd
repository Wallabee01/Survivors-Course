extends CanvasLayer


func _ready():
	%PlayButton.pressed.connect(on_play_pressed)
	%UpgradesButton.pressed.connect(on_upgrades_pressed)
	%OptionsButton.pressed.connect(on_options_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)


func on_play_pressed():
	SceneTransition.transition_to_scene("res://scenes/main/main.tscn")


func on_upgrades_pressed():
	SceneTransition.transition_to_scene("res://scenes/ui/menus/meta_menu.tscn")


func on_options_pressed():
	SceneTransition.transition()
	await SceneTransition.transitioned_halfway
	var options_menu = GameEvents.options_menu.instantiate()
	add_child(options_menu)


func on_quit_pressed():
	get_tree().quit()
