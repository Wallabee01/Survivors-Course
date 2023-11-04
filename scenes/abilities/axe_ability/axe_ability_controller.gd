extends Node

@export var axe_ability: PackedScene

var damage = 2


func _ready():
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return
	
	var foreground_layer = get_tree().get_first_node_in_group('foreground_layer') as Node2D
	if foreground_layer == null:
		return
	
	var axe_ability_instance = axe_ability.instantiate() as Node2D
	foreground_layer.add_child(axe_ability_instance)
	axe_ability_instance.global_position = player.global_position
	axe_ability_instance.hitbox_component.damage = damage
