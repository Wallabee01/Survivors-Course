extends Node2D

@export var health_component: Node
@export var sprite: Sprite2D


func _ready():
	health_component.died.connect(on_died)
	$GPUParticles2D.texture = sprite.texture


func on_died():
	if owner == null || not owner is Node2D:
		return
	
	var spawn_position = owner.global_position
	
	# Once you remove self from scene tree using remove_child you won't be able to call get_tree()
	# So need to make any calls for get_tree() before calling remove_child
	var entities = get_tree().get_first_node_in_group('entities_layer')
	get_parent().remove_child(self)
	entities.add_child(self)
	global_position = spawn_position
	$AnimationPlayer.play('default')
	$HitAudioPlayerComponent.play_random()
