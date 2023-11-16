extends Node

@export_range(0, 1) var drop_percent: float = 0.5
@export var exp_drop_scene: PackedScene
@export var health_component: HealthComponent


func _ready():
	health_component.died.connect(on_died)


func on_died():
	var adjusted_drop_percent = drop_percent
	var exp_upgrade_quantity = MetaProgression.get_upgrade_quantity('exp_gain')
	
	if exp_upgrade_quantity > 0:
		adjusted_drop_percent += (exp_upgrade_quantity * 0.1)
	
	if randf() > drop_percent:
		return
	
	if exp_drop_scene == null:
		return
	
	if not owner is Node2D:
		return
	
	var exp_drop_instance = exp_drop_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group('entities_layer').get_parent().add_child(exp_drop_instance)
	var spawn_position = (owner as Node2D).global_position
	exp_drop_instance.global_position = spawn_position
