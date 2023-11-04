extends Node2D

var exp_value:int = 1

func _ready():
	$Area2D.area_entered.connect(on_area_entered)


func on_area_entered(area: Area2D):
	GameEvents.emit_exp_collected(exp_value)
	queue_free()
