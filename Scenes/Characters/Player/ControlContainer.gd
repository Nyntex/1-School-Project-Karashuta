extends Node2D

signal SwitchColor(color);
signal TryFire(direction);

enum InputDevice {KEYBOARD, CONTROLLER};
var currentDevice = InputDevice.KEYBOARD;

var movementSpeed = 0;
var baseMovementSpeed = 0;
var bonusSpeed = 0;
export (float) var berserkSpeedPercent = 20.0

var controlScheme = 1;

func _process(delta):
	HandleColorSwapInput();
	HandleAttackInput();

func SetUp(var maxMovementSpeed):
	movementSpeed = maxMovementSpeed;
	baseMovementSpeed = maxMovementSpeed;
	
	InputMap.action_set_deadzone("JOY_AIM_RIGHT", 0);
	InputMap.action_set_deadzone("JOY_AIM_LEFT", 0);
	InputMap.action_set_deadzone("JOY_AIM_DOWN", 0);
	InputMap.action_set_deadzone("JOY_AIM_UP", 0);
	
func GetMovement():
	var velocity = Vector2();
	
	velocity.x = Input.get_action_strength("RIGHT") - Input.get_action_strength("LEFT")
	velocity.y = Input.get_action_strength("DOWN") - Input.get_action_strength("UP")
	
	return velocity.normalized() * (movementSpeed + bonusSpeed);

func HandleAttackInput():
	if currentDevice == InputDevice.KEYBOARD:
		match controlScheme:
			0:
				if Input.is_action_pressed("FIRE"):
					emit_signal("TryFire", GetAim());
				elif Input.is_action_pressed("ALT_FIRE"):
					emit_signal("TryFire", GetAim());
			1:
				if Input.is_action_pressed("FIRE"):
					emit_signal("TryFire", GetAim());
			2:
				if Input.is_action_pressed("FIRE"):
					emit_signal("TryFire", GetAim());
	
	elif currentDevice == InputDevice.CONTROLLER:
		if Input.is_action_pressed("FIRE") || Input.is_action_pressed("BLUE_FIRE") || Input.is_action_pressed("RED_FIRE"):
			emit_signal("TryFire", GetAim());


func HandleColorSwapInput():
	if currentDevice == InputDevice.KEYBOARD:
		match controlScheme:
			0:
				if Input.is_action_pressed("FIRE"):
					emit_signal("SwitchColor", ColorEnum.colors.BLUE);
				elif Input.is_action_pressed("ALT_FIRE"):
					emit_signal("SwitchColor", ColorEnum.colors.RED);
			1:
				if Input.is_action_just_pressed("CYCLE_COLORS"):
					emit_signal("SwitchColor", ColorEnum.colors.YELLOW);
			2:
				if Input.is_action_just_pressed("CYCLE_COLORS"):
					emit_signal("SwitchColor", ColorEnum.colors.YELLOW);
	
	elif currentDevice == InputDevice.CONTROLLER:
			if Input.is_action_just_pressed("CYCLE_COLORS"):
				emit_signal("SwitchColor", ColorEnum.colors.YELLOW);
			elif Input.is_action_just_pressed("BLUE_FIRE"):
				emit_signal("SwitchColor", ColorEnum.colors.BLUE);
			elif Input.is_action_just_pressed("RED_FIRE"):
				emit_signal("SwitchColor", ColorEnum.colors.RED);

var lastDirection = Vector2();

func GetAim():
	var direction = Vector2();
	
	match currentDevice:
		InputDevice.KEYBOARD:
			direction =  get_global_mouse_position() - global_position;

		InputDevice.CONTROLLER:
			direction.x = Input.get_action_strength("JOY_AIM_RIGHT") - Input.get_action_strength("JOY_AIM_LEFT")
			direction.y = Input.get_action_strength("JOY_AIM_DOWN") - Input.get_action_strength("JOY_AIM_UP")
			
			direction *= 1000;
			
	if direction == Vector2():
		direction = lastDirection;
	
	lastDirection = direction;
	
	return direction;
	
func ActivateBerserkSpeed(var active):
	if active:
		bonusSpeed += ((berserkSpeedPercent / 100) + 1) * movementSpeed - movementSpeed
	else:
		bonusSpeed -= clamp(((berserkSpeedPercent / 100) + 1) * movementSpeed - movementSpeed,0,INF);

func _input(event):
	if event is InputEventKey || event is InputEventMouse:
		currentDevice = InputDevice.KEYBOARD;
	elif event is InputEventJoypadButton || event is InputEventJoypadMotion:
		currentDevice = InputDevice.CONTROLLER;
