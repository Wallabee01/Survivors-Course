extends CanvasLayer

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scene: PackedScene

@onready var card_container: HBoxContainer = %CardContainer


func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	get_tree().paused = true
	
	var delay = 0
	for upgrade in upgrades:
		var card_instance = upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.play_bounce_in(delay)
		#bind attaches additional variables into the connected func
		card_instance.selected.connect(on_upgrade_selected.bind(upgrade))
		delay += 0.2


func on_upgrade_selected(upgrade: AbilityUpgrade):
	upgrade_selected.emit(upgrade)
	$AnimationPlayer.play('out')
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	queue_free()
