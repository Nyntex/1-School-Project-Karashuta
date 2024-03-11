extends Control

func Activate():
	visible = true;
	$AnimationPlayer.play("Open");
	
	highlighted = true;
	UpdateControllerSelectedSign();

func _on_Return_pressed():
	$AnimationPlayer.play_backwards("Open");

# Controller Support
enum rightButtons {Return, Colorbar, Borderless, Fullscreen}
enum leftButtons {Return, Sound, Music}
enum side {left, right}

var currentButton = leftButtons.Music;
var currentSide = side.left;
var highlighted = false;
var controller = false;
var sliderTimer = 0;

func _process(delta):
	if !controller || !highlighted:
		return;
	
	if Input.is_action_just_pressed("DOWN"):
		currentButton -= 1;
		if currentSide == side.left && currentButton < 0:
			currentButton = leftButtons.Music;
		elif currentSide == side.right && currentButton < 0:
			currentButton = rightButtons.Fullscreen;
		
		UpdateControllerSelectedSign();
			
	if Input.is_action_just_pressed("UP"):
		currentButton += 1;
		if currentSide == side.left && currentButton > 2:
			currentButton = leftButtons.Return;
		
		elif currentSide == side.right && currentButton > 3:
			currentButton = rightButtons.Return;
	
	if Input.is_action_just_pressed("LEFT") || Input.is_action_just_pressed("RIGHT"):
		if currentSide == side.left:
			currentSide = side.right;
			currentButton = rightButtons.Fullscreen;
		else:
			currentSide = side.left;
			currentButton = leftButtons.Music;

	if Input.is_action_just_pressed("SELECT"):
		if currentSide == side.right:
			SimulateMouseClick();
		elif currentButton == leftButtons.Return:
			SimulateMouseClick();
	
	HandleSliders(delta);

func _input(event):
	controller = event is InputEventJoypadButton || event is InputEventJoypadMotion;
	if controller:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		ResetLastButton()

	UpdateControllerSelectedSign();

func UpdateControllerSelectedSign():
	$Window/OtherSettings/SoundSettings/MusicSetting/ControllerSelected.visible = false;
	$Window/OtherSettings/SoundSettings/EffectSetting/ControllerSelected.visible = false;
	$Window/OtherSettings/Borderless/ControllerSelected.visible = false;
	$Window/OtherSettings/SmallColorBar/ControllerSelected.visible = false;
	$Window/OtherSettings/fullscreen/ControllerSelected.visible = false;
	$Window/Return/ControllerSelected.visible = false;
	
	if currentSide == side.left && controller:
		match currentButton:
			leftButtons.Music:
				$Window/OtherSettings/SoundSettings/MusicSetting/ControllerSelected.visible = true;
				
			leftButtons.Sound:
				$Window/OtherSettings/SoundSettings/EffectSetting/ControllerSelected.visible = true;
				
			leftButtons.Return:
				$Window/Return/ControllerSelected.visible = true;
				SimulateMousePosition($Window/Return);
				
	elif currentSide == side.right && controller:
		match currentButton:
			rightButtons.Borderless:
				$Window/OtherSettings/Borderless/ControllerSelected.visible = true;
				SimulateMousePosition($Window/OtherSettings/Borderless/TextureButton);
				
			rightButtons.Fullscreen:
				$Window/OtherSettings/fullscreen/ControllerSelected.visible = true;
				SimulateMousePosition($Window/OtherSettings/fullscreen/TextureButton);
				
			rightButtons.Colorbar:
				$Window/OtherSettings/SmallColorBar/ControllerSelected.visible = true;
				SimulateMousePosition($Window/OtherSettings/SmallColorBar/TextureButton);
			
			rightButtons.Return:
				$Window/Return/ControllerSelected.visible = true;
				SimulateMousePosition($Window/Return);
			
var lastSimulatedMousePosition = Vector2(0,0);

func HandleSliders(var delta):
	if Input.is_action_pressed("SLIDE_UP"):
		if currentSide == side.left:
			sliderTimer += delta;
			if sliderTimer > 0.05:
				sliderTimer = 0;
				
				if currentButton == leftButtons.Music:
					$Window/OtherSettings/SoundSettings/MusicSetting/MusicSlider.value = clamp($Window/OtherSettings/SoundSettings/MusicSetting/MusicSlider.value + 1, $Window/OtherSettings/SoundSettings/MusicSetting/MusicSlider.min_value ,$Window/OtherSettings/SoundSettings/MusicSetting/MusicSlider.max_value);
				elif currentButton == leftButtons.Sound:
					$Window/OtherSettings/SoundSettings/EffectSetting/EffectSlider.value = clamp($Window/OtherSettings/SoundSettings/EffectSetting/EffectSlider.value + 1, $Window/OtherSettings/SoundSettings/MusicSetting/MusicSlider.min_value ,$Window/OtherSettings/SoundSettings/EffectSetting/EffectSlider.max_value);
		
	if Input.is_action_pressed("SLIDE_DOWN"):
		if currentSide == side.left:
			sliderTimer += delta;
			if sliderTimer > 0.05:
				sliderTimer = 0;
				
				if currentButton == leftButtons.Music:
					$Window/OtherSettings/SoundSettings/MusicSetting/MusicSlider.value = clamp($Window/OtherSettings/SoundSettings/MusicSetting/MusicSlider.value - 1, $Window/OtherSettings/SoundSettings/MusicSetting/MusicSlider.min_value ,$Window/OtherSettings/SoundSettings/MusicSetting/MusicSlider.max_value);
				elif currentButton == leftButtons.Sound:
					$Window/OtherSettings/SoundSettings/EffectSetting/EffectSlider.value = clamp($Window/OtherSettings/SoundSettings/EffectSetting/EffectSlider.value - 1, $Window/OtherSettings/SoundSettings/MusicSetting/MusicSlider.min_value ,$Window/OtherSettings/SoundSettings/EffectSetting/EffectSlider.max_value);


var lastButton = null;
var lastNormal = null;
func SimulateMousePosition(var button):
	if !highlighted || button == null || button == lastButton:
		return;
	
	ResetLastButton();
	
	lastButton = button;
	lastNormal = button.texture_normal;
	
	button.texture_normal = button.texture_hover;
	button.emit_signal("mouse_entered")


func SimulateMouseClick():
	if !highlighted || lastButton == null || lastButton.disabled:
		return;
	
	lastButton.emit_signal("pressed")

func ResetLastButton():
	if lastButton != null && lastNormal != null:
		lastButton.emit_signal("mouse_exited");
		lastButton.texture_normal = lastNormal;
