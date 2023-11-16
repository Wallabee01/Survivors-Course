extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container = %GridContainer

var meta_upgrade_card_scene: PackedScene = preload("res://scenes/ui/cards/meta_upgrade_card.tscn")


func _ready():
	%BackButton.pressed.connect(on_back_pressed)
	
	for child in grid_container.get_children():
		child.queue_free()

	for upgrade in upgrades:
		var meta_upgrade_card_instance = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_meta_upgrade(upgrade)


func on_back_pressed():
	SceneTransition.transition_to_scene("res://scenes/ui/menus/main_menu.tscn")
