extends Node2D

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite = $Sprite2D
@onready var random_sfx_component = $RandomSFX2DComponent

var exp_value:int = 1


func _ready():
	$Area2D.area_entered.connect(on_area_entered)


func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return
	
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(get_process_delta_time() * -2))


func collect():
	GameEvents.emit_exp_collected(exp_value)
	await get_tree().create_timer(0.15).timeout
	queue_free()


func disable_collision():
	collision_shape_2d.disabled = true


func on_area_entered(area: Area2D):
	Callable(disable_collision).call_deferred()
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 1)\
	.set_ease(tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	tween.tween_property(sprite, 'scale', Vector2.ZERO, .10).set_delay(.90)
	tween.chain()
	tween.tween_callback(play_pickup_sfx)
	tween.tween_callback(collect)


func play_pickup_sfx():
	random_sfx_component.play_random()
