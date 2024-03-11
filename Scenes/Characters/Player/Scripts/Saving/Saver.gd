class_name Saver
extends Reference

const SAVE_GAME_PATH = "user://KarashutaSV.json"

var playerSavingStats = PlayerSavingStats.new()
var settingsSave = SettingsSave.new()
var hubStats = HubStats.new()

var file = File.new()

var teststring:String

func SaveExists():
	return file.file_exists(SAVE_GAME_PATH)

func WriteSave():
	var error = file.open(SAVE_GAME_PATH, File.WRITE)
	if error != OK:
		printerr("Could not Load Save File %s. Error Code %s" %
		[SAVE_GAME_PATH, error])
		return
	
	var data = {
		"playerSavingStats":playerSavingStats.get_data(),
		"settingsSave": settingsSave.get_data(),
		"HubStats": hubStats.get_data(),
	}
	
	var json_string = JSON.print(data)
	file.store_string(json_string)
	file.close()
	#print("Successfully Saved!")

func LoadSave():
	var error = file.open(SAVE_GAME_PATH, File.READ)
	if error != OK:
		printerr("Could not Load Save File %s. Error Code %s" %
		[SAVE_GAME_PATH, error])
		return
	
	var content = file.get_as_text()
	file.close()
	
	var data = JSON.parse(content).result
	
	playerSavingStats = PlayerSavingStats.new()
	if data.has("playerSavingStats"):
		playerSavingStats.set_data(data.playerSavingStats)
	
	settingsSave = SettingsSave.new()
	if data.has("settingsSave"):
		settingsSave.set_data(data.settingsSave)
	
	hubStats = HubStats.new()
	if data.has("HubStats"):
		hubStats.set_data(data.HubStats)
