extends CharacterBody2D

const MAX_SPEED = 50

@onready var health_component: HealthComponent = $HealthComponent


func _process(delta):
	#Movement
	var direction = get_direction_to_player()
	velocity = direction * MAX_SPEED
	move_and_slide()


func get_direction_to_player() -> Vector2:
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return Vector2.ZERO
	
	return (player.global_position - global_position).normalized()
