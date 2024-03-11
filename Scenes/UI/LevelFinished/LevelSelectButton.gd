extends Control

signal OnPressed(level)
var level = 0;


func OnButtonPressed():
	emit_signal("OnPressed", level);

func Disable():
	$Button.disabled = true;

func Enable():
	$Button.disabled = false;
