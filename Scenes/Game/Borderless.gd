extends Control

export (Texture) var active;
export (Texture) var normal;
var saver = Saver.new()

func _ready():
	saver.LoadSave()
	OS.window_borderless = saver.settingsSave.borderless
	UpdateVisuals();

func _on_TextureButton_pressed():
	OS.window_borderless = !OS.window_borderless;
	
	saver.LoadSave();
	saver.settingsSave.borderless = OS.window_borderless
	saver.WriteSave()
	
	UpdateVisuals();

func UpdateVisuals():
	if OS.window_borderless:
		$TextureButton.texture_normal = active;
		$TextureButton.texture_hover = active;
		$TextureButton.texture_pressed = active;
		
	else:
		$TextureButton.texture_normal = normal;
		$TextureButton.texture_hover = normal;
		$TextureButton.texture_pressed = normal;
