extends Node

const MAX_RANGE = 150
const BASE_WAIT_TIME = 1.5
const SPEED_UPGRADE_STRENGTH = 0.1
const MAX_SPEED_UPGRADE = 0.9

@export var sword_ability: PackedScene

var base_damage = 1
var damage_upgrade = 0


func _ready():
	$Timer.wait_time = BASE_WAIT_TIME
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group('enemy')
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	var sword_instance = sword_ability.instantiate() as SwordAbility
	get_tree().get_first_node_in_group('foreground_layer').add_child(sword_instance)
	sword_instance.hitbox_component.damage = base_damage + damage_upgrade
	
	sword_instance.global_position = enemies[0].global_position
	#TAU = 2 * PI, times 6 pixel radius
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 6
	
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == 'sword_speed':
		var percent_reduction = current_upgrades['sword_speed']['quantity'] * SPEED_UPGRADE_STRENGTH
		if percent_reduction > MAX_SPEED_UPGRADE:
			percent_reduction = MAX_SPEED_UPGRADE
		$Timer.wait_time = BASE_WAIT_TIME * (1 - percent_reduction)
		#wait_time can't be changed on a running timer, start() resets wait_time to new wait_time
		$Timer.start()
	elif upgrade.id == 'sword_damage':
		damage_upgrade += 1
