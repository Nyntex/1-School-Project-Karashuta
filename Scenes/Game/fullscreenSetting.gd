extends Control

export (Texture) var active;
export (Texture) var normal;
var saver = Saver.new()

func _ready():
	saver.LoadSave()
	OS.window_fullscreen = saver.settingsSave.fullscreen
	UpdateVisuals();

func _on_TextureButton_pressed():
	OS.window_fullscreen = !OS.window_fullscreen;
	
	saver.LoadSave();
	saver.settingsSave.fullscreen = OS.window_fullscreen
	saver.WriteSave()
	
	UpdateVisuals();

func UpdateVisuals():
	if OS.window_fullscreen:
		$TextureButton.texture_normal = active;
		$TextureButton.texture_hover = active;
		$TextureButton.texture_pressed = active;
	else:
		$TextureButton.texture_normal = normal;
		$TextureButton.texture_hover = normal;
		$TextureButton.texture_pressed = normal;
