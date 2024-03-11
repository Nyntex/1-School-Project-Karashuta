class_name SettingsSave
extends Resource

var musicVolume = 0.0
var sfxVolume = 0.0
var controlType = 1;

var fullscreen = true
var borderless = true
var smallColorBars = true

func get_data():
	return {
				"musicVolume": musicVolume,
				"sfxVolume": sfxVolume,
				"controlType": controlType,
				
				"fullscreen": fullscreen,
				"borderless": borderless,
				"smallColorBars": smallColorBars,
			}

func set_data(data):
	if data.has("musicVolume"):
		musicVolume = data.musicVolume
	if data.has("sfxVolume"):
		sfxVolume = data.sfxVolume
	if data.has("controlType"):
		controlType = data.controlType
	
	if data.has("fullscreen"):
		fullscreen = data.fullscreen
	if data.has("borderless"):
		borderless = data.borderless
	if data.has("smallColorBars"):
		smallColorBars = data.smallColorBars
