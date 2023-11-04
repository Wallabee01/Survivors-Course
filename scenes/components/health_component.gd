extends Node
class_name HealthComponent

signal died
signal health_changed

@export var max_health: float = 2

var current_health


func _ready():
	current_health = max_health


func damage(damage_value: float):
	current_health = max(current_health - damage_value, 0)
	health_changed.emit()
	#Need to call_deferred() because of collision error issues
	Callable(check_death).call_deferred()


func get_health_percent():
	if max_health <= 0:
		return 0
	
	return min(current_health / max_health, 1)


func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()
