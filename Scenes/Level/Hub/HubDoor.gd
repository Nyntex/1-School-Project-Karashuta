extends AnimatedSprite

var open = false;
var locked = false;
var bossClose = false;

signal Open

func Open(var forced = false, body = null):
	if locked:
		return;
		
	if !open || forced :
		if body != null:
			body.set_process(false)
			body.set_physics_process(false)
			
		play("Open");
		open = true;
		emit_signal("Open")
		yield(get_tree().create_timer(8),"timeout")
		
		if body != null:
			body.set_process(true)
			body.set_physics_process(true)
	
	

func Close(var forced = false):
	if locked:
		return;
		
	if open || forced:
		play("Close");
		open = false;

func OnAnimationFinished():
	if open:
		$KinematicBody2D.set_collision_mask_bit(0, false)
		$KinematicBody2D.set_collision_mask_bit(2, false)
		$KinematicBody2D.set_collision_layer_bit(2, false);
		play("Opened");
	else:
		$KinematicBody2D.set_collision_mask_bit(0, true)
		$KinematicBody2D.set_collision_mask_bit(2, true)
		$KinematicBody2D.set_collision_layer_bit(2, true);
		play("Closed");


func _process(_delta):
	if $Interactable.visible || $ControllerSelected.visible:
		if Input.is_action_just_pressed("SELECT") || Input.is_action_just_pressed("Interact"):
			$Notification.Appear();

	if bossClose:
		frame -= 1;
		if frame <= 0:
			bossClose = false;
			OnAnimationFinished();

func _on_NotificationTrigger_body_entered(_body):
	if !open && !locked:
		if !controller:
			$Interactable.visible = true;
		else:
			$ControllerSelected.visible = true;

func _on_NotificationTrigger_body_exited(_body):
	$Interactable.visible = false;
	$ControllerSelected.visible = false;
	$Notification.Disappear();

func BossDoorClose():
	if !open:
		return;
	
	bossClose = true;
	playing = false;
	animation = "Open";
	frame = 240;
	open = false;
	
	$KinematicBody2D.set_collision_mask_bit(0, true)
	$KinematicBody2D.set_collision_mask_bit(2, true)
	$KinematicBody2D.set_collision_layer_bit(2, true);

#Controller Support
var controller = false;

func _input(event):
	if visible:
		controller = event is InputEventJoypadButton || event is InputEventJoypadMotion;
		if controller:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
