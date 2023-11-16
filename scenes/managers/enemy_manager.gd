extends Node

const SPAWN_RADIUS = 340

@export var grey_rat_scene: PackedScene
@export var wizard_scene: PackedScene
@export var bat_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer: Timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()
var enemies_to_spawn: int = 1


func _ready():
	enemy_table.add_item(grey_rat_scene, 10)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position(offset: float) -> Vector2:
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return Vector2.ZERO
	
		# TAU = 2 * PI, or 360 degrees
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position: Vector2 = Vector2.ZERO
	
	# If spawn_position it outside of walls, ray will intersect
	# Rotate ray 90 degrees until we find an angle that isnt colliding with terrian
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var additional_check_offset = random_direction * offset
		
		# 1 << 0, points to bit 0 (physics layer 1) using bit shift operator
		# if we wanted bit 19 (physics layer 20) we could do 1 << 19
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, \
		spawn_position + additional_check_offset, 1 << 0)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
	
		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position


func on_timer_timeout():
	timer.start()
	
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return
	
	for i in enemies_to_spawn:
		var enemy_scene = enemy_table.pick_item()
		var enemy_instance = enemy_scene.instantiate()
		get_tree().get_first_node_in_group('entities_layer').add_child(enemy_instance)
		enemy_instance.global_position = get_spawn_position(enemy_instance.get_collision_shape_offset())


func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (0.1 / 12) * arena_difficulty
	time_off = min(time_off, 0.7)
	timer.wait_time = base_spawn_time - time_off
	
	if arena_difficulty % 6 == 0:
		enemies_to_spawn += 1
	
	if arena_difficulty == 6:
		enemy_table.add_item(wizard_scene, 10)
	elif arena_difficulty == 12:
		enemy_table.add_item(bat_scene, 10)
		pass
