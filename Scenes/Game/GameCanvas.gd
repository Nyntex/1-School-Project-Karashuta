extends CanvasLayer

func _process(_delta):
	if Input.is_action_just_pressed("Pause") && !$QuitConfirmation.visible && !$StartScreen.visible:
		if $Settings.visible:
			$Settings._on_Return_pressed();
		elif $PauseScreen.visible:
			$PauseScreen._on_Continue_pressed();
		else:
			$PauseScreen.activate();

func _on_CustomRun_pressed():
	$CustomRun.Activate();
	$PauseScreen.highlighted = false;
	$StartScreen/Main.highlighted = false;

func _on_Settings_pressed():
	yield(get_tree().create_timer(0), "timeout")
	$Settings.Activate();
	$StartScreen/Main.highlighted = false;
	$PauseScreen.highlighted = false;

func _on_Quit_pressed():
	yield(get_tree().create_timer(0), "timeout")
	$QuitConfirmation.Activate();
	$StartScreen/Main.highlighted = false;
	$PauseScreen.highlighted = false;
	$DeathScreen.highlighted = false;

func OnHover():
	$HoverSound.ImprovedPlay();

func OnButtonClick():
	$ButtonClickSound.ImprovedPlay();

func _on_No_pressed():
	if $StartScreen.visible:
		$StartScreen/Main.highlighted = true;

	elif $PauseScreen.visible:
		$PauseScreen.highlighted = true;
	
	elif $DeathScreen.visible:
		$DeathScreen.highlighted = true;

func _on_Settings_Return_pressed():
	$Settings.highlighted = false;
	if $StartScreen.visible:
		$StartScreen/Main.highlighted = true;

	elif $PauseScreen.visible:
		$PauseScreen.highlighted = true;

func _on_Pause_Continue_pressed():
	$PauseScreen.highlighted = false;
