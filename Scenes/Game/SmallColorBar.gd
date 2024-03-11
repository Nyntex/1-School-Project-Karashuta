extends Control

export (Texture) var active;
export (Texture) var normal;
var player;
var isVisible = true;

var saver = Saver.new()


func _ready():
	saver.LoadSave()
	isVisible = saver.settingsSave.smallColorBars
	UpdateVisuals();

func SetUp(var player_):
	player = player_;
	UpdateVisuals();
	
	player.get_node("Containers").HideSmall(!isVisible);

func _on_TextureButton_pressed():
	isVisible = !isVisible;
	
	saver.LoadSave();
	saver.settingsSave.smallColorBars = isVisible
	saver.WriteSave()
	
	if player != null:
		player.get_node("Containers").HideSmall(!isVisible);
		
	UpdateVisuals();

func UpdateVisuals():
	if isVisible:
		$TextureButton.texture_normal = active;
		$TextureButton.texture_hover = active;
		$TextureButton.texture_pressed = active;
		
	else:
		$TextureButton.texture_normal = normal;
		$TextureButton.texture_hover = normal;
		$TextureButton.texture_pressed = normal;
