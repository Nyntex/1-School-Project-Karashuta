extends TextureRect

func _ready():
	$Window.visible = false;

func _on_Hint_mouse_entered():
	$Window.visible = true;

func _on_Hint_mouse_exited():
	$Window.visible = false;
