extends Node

const BASE_RANGE = 100

@export var anvil_ability_scene: PackedScene
@export var base_damage = 3

var anvil_count = 1

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group('player')
	if player == null: return
	
	
	for i in anvil_count:
		var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
		var spawn_position = player.global_position + (direction * randf_range(0, BASE_RANGE))
		
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, \
		spawn_position, 1 << 0)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
		if !result.is_empty():
			spawn_position = result['position']
		
		var anvil_ability_instance = anvil_ability_scene.instantiate() as Node2D
		get_tree().get_first_node_in_group('foreground_layer').add_child(anvil_ability_instance)
		anvil_ability_instance.global_position = spawn_position
		anvil_ability_instance.hitbox_component.damage = base_damage


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == 'anvil_count':
		anvil_count = current_upgrades['anvil_count']['quantity'] + 1
