extends CanvasLayer

@onready var sfx_slider = %SFXSlider
@onready var music_slider = %MusicSlider
@onready var back_button = %BackButton


func _ready():
	back_button.pressed.connect(on_back_pressed)
	%WindowedButton.pressed.connect(on_windowed_button_pressed)
	%FullScreenButton.pressed.connect(on_full_screen_button_pressed)
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind('sfx'))
	music_slider.value_changed.connect(on_audio_slider_changed.bind('music'))
	update_display()


func update_display():
	sfx_slider.value = get_bus_volume_percent('sfx')
	music_slider.value = get_bus_volume_percent('music')


func get_bus_volume_percent(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func set_bus_volume_percent(bus_name: String, percent: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func on_windowed_button_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func on_full_screen_button_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func on_audio_slider_changed(value: float, bus_name: String):
	set_bus_volume_percent(bus_name, value)


func on_back_pressed():
	SceneTransition.transition()
	await SceneTransition.transitioned_halfway
	visible = false
