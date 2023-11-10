extends CharacterBody2D

@onready var velocity_component: Node = $VelocityComponent
@onready var visuals = $Visuals
@onready var random_sfx_component = $RandomSFX2DComponent

var is_moving: bool = false


func _ready():
	$HurtboxComponent.hit.connect(on_hit)


func _process(delta):
	#Creates a start and stop shuffle effect for enemy movement
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
	
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func set_is_moving(moving: bool):
	is_moving = moving


func on_hit():
	random_sfx_component.play_random()
