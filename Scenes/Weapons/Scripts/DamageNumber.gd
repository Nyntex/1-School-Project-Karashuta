extends Control

func OnAnimationEnd():
	queue_free();

func SetText(var text):
	$Label.text = text;
