extends Camera2D



func _ready():
	make_current()


func _process(_delta):
	var player = get_tree().get_first_node_in_group('player') as CharacterBody2D
	global_position = player.global_position
