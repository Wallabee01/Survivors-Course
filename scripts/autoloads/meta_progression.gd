extends Node

const SAVE_FILE_PATH = 'user://game.save'
var save_data: Dictionary = {
	'meta_upgrade_currency': 0,
	'meta_upgrades': {}
}


func _ready():
	GameEvents.exp_collected.connect(on_exp_collected)
	add_meta_upgrade(load("res://resources/meta_upgrades/exp_gain.tres"))
	load_save_file()


func load_save_file():
	if !FileAccess.file_exists(SAVE_FILE_PATH): return
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()


func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)


func add_meta_upgrade(upgrade: MetaUpgrade):
	if !save_data['meta_upgrades'].has(upgrade.id):
		#If save_data doesn't have a key with upgrade.id, create 1 and set its quantity to 0
		save_data['meta_upgrades'][upgrade.id] = {
			'quantity': 0
		}
	#Increase quantity by 1 at upgrade.id in meta_upgrades
	save_data['meta_upgrades'][upgrade.id]['quantity'] += 1

func on_exp_collected(value: float):
	save_data['meta_upgrade_currency'] += value
