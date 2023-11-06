extends Node

const MAX_RANGE = 150
const BASE_WAIT_TIME = 1.5
const SPEED_UPGRADE_STRENGTH = 0.1
const MAX_SPEED_UPGRADE = 0.9

@export var axe_ability: PackedScene

var base_damage = 2
var damage_upgrade = 0


func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


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
	axe_ability_instance.hitbox_component.damage = base_damage + damage_upgrade


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == 'axe_speed':
		var percent_reduction = current_upgrades['axe_speed']['quantity'] * SPEED_UPGRADE_STRENGTH
		if percent_reduction > MAX_SPEED_UPGRADE:
			percent_reduction = MAX_SPEED_UPGRADE
		$Timer.wait_time = BASE_WAIT_TIME * (1 - percent_reduction)
		#wait_time can't be changed on a running timer, start() resets wait_time to new wait_time
		$Timer.start()
	elif upgrade.id == 'axe_damage':
		damage_upgrade = current_upgrades['axe_damage']['quantity']
