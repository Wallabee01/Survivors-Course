extends Node

const SPAWN_RADIUS = 340

@export var grey_rat: PackedScene
@export var arena_time_manager: Node

@onready var timer: Timer = $Timer

var base_spawn_time = 0


func _ready():
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spawn_position() -> Vector2:
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
		
		# 1 << 0, points to bit 0 (physics layer 1) using bit shift operator
		# if we wanted bit 19 (physics layer 20) we could do 1 << 19
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1 << 0)
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
	
	var enemy_instance = grey_rat.instantiate()
	get_tree().get_first_node_in_group('entities_layer').add_child(enemy_instance)
	enemy_instance.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (0.1 / 12) * arena_difficulty
	time_off = min(time_off, 0.7)
	timer.wait_time = base_spawn_time - time_off
