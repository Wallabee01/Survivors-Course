extends CharacterBody2D

@onready var velocity_component: Node = $VelocityComponent
@onready var visuals = $Visuals
@onready var random_sfx_component = $RandomSFX2DComponent


func _ready():
	$HurtboxComponent.hit.connect(on_hit)


func _process(delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func get_collision_shape_offset():
	return $CollisionShape2D.shape.radius/2


func on_hit():
	random_sfx_component.play_random()
