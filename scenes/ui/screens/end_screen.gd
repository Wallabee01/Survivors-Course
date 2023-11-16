extends CanvasLayer

@onready var panel_container = %PanelContainer



func _ready():
	panel_container.pivot_offset = panel_container.size / 2
	
	var tween = create_tween()
	tween.tween_property(panel_container, 'scale', Vector2.ZERO, 0)
	tween.tween_property(panel_container, 'scale', Vector2.ONE, 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	get_tree().paused = true
	%ContinueButton.pressed.connect(on_continue_button_pressed)
	%QuitButton.pressed.connect(on_quit_button_pressed)


func set_defeat():
	play_jingle(true)
	%TitleLabel.text = 'Defeat'
	%DescriptionLabel.text = 'You Lose!'


func play_jingle(defeat: bool = false):
	if defeat:
		$DefeatStreamPlayer.play_random()
	else:
		$VictoryStreamPlayer.play_random()


func on_continue_button_pressed():
	SceneTransition.transition_to_scene("res://scenes/ui/menus/meta_menu.tscn")
	MetaProgression.save()


func on_quit_button_pressed():
	SceneTransition.transition_to_scene("res://scenes/ui/menus/main_menu.tscn")
	MetaProgression.save()
