extends Node2D

signal finished();
var red = false;
var blue = false;

var player;
func Start(var player_):
	player = player_;
	$CanvasLayer.visible = true;
	visible = true;

func OnSpecialAbilityUsed():
	if blue || red:
		$CanvasLayer/Text/Label.text = "Completely filling your color bar now causes you to use a special ability. Try out both! (1/2)"

func OnRedUse():
	red = true;
	
	if blue && visible:
		visible = false;
		emit_signal("finished");
		$CanvasLayer.visible = false;

func OnBlueUse():
	blue = true;
	
	if red && visible:
		visible = false;
		emit_signal("finished");
		$CanvasLayer.visible = false;
