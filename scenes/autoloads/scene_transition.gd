extends CanvasLayer

signal transitioned_halfway


func transition():
	$AnimationPlayer.play('in')
	await transitioned_halfway
	$AnimationPlayer.play('out')


func emit_transitioned_halfway():
	transitioned_halfway.emit()
