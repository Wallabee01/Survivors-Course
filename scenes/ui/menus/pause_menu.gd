extends CanvasLayer

@onready var panel_container = %PanelContainer

var is_closing: bool = false

func _ready():
	panel_container.pivot_offset = panel_container.size / 2
	
	%ResumeButton.pressed.connect(on_resume_button_pressed)
	%OptionsButton.pressed.connect(on_options_button_pressed)
	%QuitButton.pressed.connect(on_quit_button_pressed)


func pause():
	get_tree().paused = true
	visible = true
	
	$AnimationPlayer.play('default')
	
	var tween = create_tween()
	tween.tween_property(panel_container, 'scale', Vector2.ZERO, 0)
	tween.tween_property(panel_container, 'scale', Vector2.ONE, 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func on_resume_button_pressed():
	is_closing = true
	$AnimationPlayer.play_backwards('default')
	
	var tween = create_tween()
	tween.tween_property(panel_container, 'scale', Vector2.ONE, 0)
	tween.tween_property(panel_container, 'scale', Vector2.ZERO, 0.3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	get_tree().paused = false
	visible = false
	is_closing = false


func on_options_button_pressed():
	SceneTransition.transition()
	await SceneTransition.transitioned_halfway
	var options_menu = GameEvents.options_menu.instantiate()
	add_child(options_menu)


func on_quit_button_pressed():
	SceneTransition.transition_to_scene("res://scenes/ui//menus/main_menu.tscn")
	MetaProgression.save()
