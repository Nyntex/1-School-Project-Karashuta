extends Control

var target = 0;

func SetUp(var health):
	$Healthbar.value = health;
	$Healthbar.max_value = health;
	target = health;
	visible = false;

func _process(delta):
	if $Healthbar.value < target:
		$Healthbar.value += 100 * delta;

	if $Healthbar.value > target:
		$Healthbar.value -= 100 * delta;

func changeHealth(newTarget):
	target = newTarget;
	$Healthbar.value = target
	visible = true;
	$Timer.start();
	
func _on_Timer_timeout():
	visible = false;
