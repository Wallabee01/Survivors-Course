extends CanvasLayer

signal transitioned_halfway


func transition():
	$AnimationPlayer.play('in')
	await transitioned_halfway
	$AnimationPlayer.play('out')


func emit_transitioned_halfway():
	transitioned_halfway.emit()


func transition_to_scene(scene_path: String):
	transition()
	await transitioned_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_path)
