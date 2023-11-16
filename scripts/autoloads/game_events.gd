extends Node

signal exp_collected(value: int)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged()

@onready var options_menu: PackedScene = preload("res://scenes/ui/menus/options_menu.tscn")


func emit_exp_collected(value: int):
	exp_collected.emit(value)


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)


func emit_player_damaged():
	player_damaged.emit()
