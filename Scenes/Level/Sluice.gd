extends YSort
signal OnLevelStart();
signal OnLevelEnd();

var leftOpen = false;
var rightOpen = false;

func _ready():
	$Doors/Right.stop();
	$Doors/Left.stop();

func _on_LeftDoorCloseTrigger_body_entered(_body):
	if leftOpen:
		HideLeftDoor(false);
		HideRightDoor(true);

func _on_RightDoorCloseTrigger_body_entered(_body):
	if rightOpen:
		HideRightDoor(false);
		HideLeftDoor(true);
		emit_signal("OnLevelStart");

func HideLeftDoor(var v):
	leftOpen = v;
	if v:
		$Doors/Left.Open();
	else:
		$Doors/Left.Close();

func HideRightDoor(var v):
	rightOpen = v;
	if v:
		$Doors/Right.Open();
	else:
		$Doors/Right.Close();

func _on_LevelSwitchTrigger_body_entered(_body):
	emit_signal("OnLevelEnd");
