extends Control

signal OnReset();

func GetHealthBar():
	return $CanvasLayer/GameUI/Healthbar;

func GetDamageAnimation():
	return $CanvasLayer/TakeDamage/AnimationPlayer;

func GetDeathScreen():
	return $CanvasLayer/Death;

func _on_ReturnToHub_pressed():
	emit_signal("OnReset");
