extends PanelContainer

signal selected

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel

var disabled = false


func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)


func play_bounce_in(delay: float):
	modulate = Color.TRANSPARENT
	#The rest of the game will continue until this times out, then it will come back here
	await get_tree().create_timer(delay).timeout
	#if we set modulate to Color.WHITE here in code, there will be 1 frame where the animation
	#doesn't start, so better to set it in the animation
	#AnimationPlayer.play() starts on the next frame, not current frame
	$AnimationPlayer.play('bounce_in')


func play_discard():
	$AnimationPlayer.play('discard')


func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func select_card():
	disabled = true 
	$AnimationPlayer.play('selected')
	
	for other_card in get_tree().get_nodes_in_group('upgrade_card'):
		if other_card != self:
			other_card.play_discard()
	
	await $AnimationPlayer.animation_finished
	selected.emit()


func on_gui_input(event: InputEvent):
	if event.is_action_pressed('left_click') && !disabled:
		select_card()


func on_mouse_entered():
	if disabled: return
	
	$HoverPlayer.play('mouse_hover')
