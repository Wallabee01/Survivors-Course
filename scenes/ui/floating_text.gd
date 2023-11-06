extends Node2D

@export var initial_distance: float = 16
@export var initial_duration: float = 0.3
@export var final_distance: float = 48
@export var final_duration: float = 0.4
@export var scale_multiplier: float = 1.5
@export var scale_duration: float = 0.15


func _ready():
	pass


func start(text: String):
	$Label.text = text
	var tween = create_tween()
	tween.set_parallel()
	
	tween.tween_property(self, 'global_position', global_position + (Vector2.UP * initial_distance), initial_duration)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.chain()
	
	tween.tween_property(self, 'global_position', global_position + (Vector2.UP * final_distance), final_duration)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, 'scale', Vector2.ZERO, final_duration)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.chain()
	
	tween.tween_callback(queue_free)
	
	var scale_tween = create_tween()
	scale_tween.tween_property(self, 'scale', Vector2.ONE * scale_multiplier, scale_duration)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property(self, 'scale', Vector2.ONE, scale_duration)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
