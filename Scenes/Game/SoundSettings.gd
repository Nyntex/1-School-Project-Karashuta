extends Control

var saver = Saver.new()
var musicVolume = -30.0
var effectVolume = -30.0


func _ready():
	saver.LoadSave()
	musicVolume = saver.settingsSave.musicVolume
	effectVolume = saver.settingsSave.sfxVolume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), effectVolume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), musicVolume)
	$MusicSetting/MusicSlider.value = musicVolume
	$EffectSetting/EffectSlider.value = effectVolume


func _on_AnySlider_value_changed(value):
	saver.settingsSave.musicVolume = $MusicSetting/MusicSlider.value
	saver.settingsSave.sfxVolume = $EffectSetting/EffectSlider.value
	saver.WriteSave()
