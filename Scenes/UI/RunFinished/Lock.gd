extends TextureButton

signal OnUnlock();
export (Texture) var unlockedTexture;

func _on_Lock_pressed():
	if texture_normal != unlockedTexture:
		Unlock();
		emit_signal("OnUnlock");

func Unlock():
	texture_normal = unlockedTexture;
	disabled = false;
	$ControllerSelected.visible = false;

#Controller Support
var controller = false;

func _input(event):
	if visible && texture_normal != unlockedTexture && !disabled:
		controller = event is InputEventJoypadButton || event is InputEventJoypadMotion;
		
		$ControllerSelected.visible = controller && !disabled && texture_normal != unlockedTexture;
		
		if controller:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;

func _process(delta):
	if controller && Input.is_action_just_pressed("SELECT"):
		_on_Lock_pressed();
