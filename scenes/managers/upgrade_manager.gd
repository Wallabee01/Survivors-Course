extends Node

const UPGRADES_TO_DISPLAY: int = 2

@export var exp_manager: Node
@export var upgrade_screen: PackedScene

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

var axe_ability = preload("res://resources/upgrades/axe_ability.tres")
var axe_damage_upgrade = preload("res://resources/upgrades/axe_damage.tres")
var sword_speed_upgrade = preload("res://resources/upgrades/sword_speed.tres")
var sword_damage_upgrade = preload("res://resources/upgrades/sword_damage.tres")
var move_speed_upgrade = preload("res://resources/upgrades/move_speed.tres")

func _ready():
	upgrade_pool.add_item(axe_ability, 10)
	upgrade_pool.add_item(sword_speed_upgrade, 10)
	upgrade_pool.add_item(sword_damage_upgrade, 10)
	upgrade_pool.add_item(move_speed_upgrade, 5)
	
	exp_manager.level_up.connect(on_level_up)


func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	if chosen_upgrade.id == axe_ability.id:
		upgrade_pool.add_item(axe_damage_upgrade, 10)


func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	for i in UPGRADES_TO_DISPLAY:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		
		var chosen_upgrade = upgrade_pool.pick_item()
		
		chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades


func on_level_up(current_level: int):
	var upgrade_screen_instance = upgrade_screen.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
