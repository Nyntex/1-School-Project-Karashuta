extends CanvasLayer

var timer;

func SetUp(var timer_):
	visible = true;
	timer = timer_;

func Appear():
	visible = true;

func _process(_delta):
	UpdateTime();

func UpdateTime():
	if !is_instance_valid(timer) || timer.is_stopped():
		return;

	$Time.UpdateTime(timer.time_left)

func ActivateNotification():
	$Notification.activate();


func _on_ReturnToHub_pressed():
	$ButtonClickSound.ImprovedPlay();

func _on_ReturnToHub_mouse_entered():
	$HoverSound.ImprovedPlay();
