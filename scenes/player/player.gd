extends CharacterBody2D

const MAX_SPEED = 200

func _ready():
	pass


func _process(_delta):
	#Movement
	var direction = get_movement_vector()
	velocity = direction * MAX_SPEED
	move_and_slide()


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement).normalized()
