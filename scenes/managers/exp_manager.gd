extends Node

signal exp_updated(current_exp: float, target_exp: float)
signal level_up(new_level: int)

const TARGET_EXP_GROWTH = 10

var current_exp: float = 0
var target_exp: float = 10
var current_level: int = 0


func _ready():
	GameEvents.exp_collected.connect(on_exp_collected)


func increment_exp(value: int):
	current_exp += value
	exp_updated.emit(current_exp, target_exp)
	if current_exp >= target_exp:
		current_level += 1
		current_exp = current_exp - target_exp
		target_exp += TARGET_EXP_GROWTH
		exp_updated.emit(current_exp, target_exp)
		level_up.emit(current_level)


func on_exp_collected(value: int):
	increment_exp(value)
