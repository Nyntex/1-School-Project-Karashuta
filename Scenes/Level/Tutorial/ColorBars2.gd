extends Node2D

signal finished();

var player;
func Start(var player_):
	player = player_;
	visible = true;
	$CanvasLayer.visible = true;

func _on_One_body_entered(_body):
	if visible:
		if player == null:
			printerr("ColorBars2.gd: Missing Player!")
			return
			
		player.get_node("Containers/ColorContainer").IncreaseMaxValue(10);
		$Checkmark.queue_free();
		$CanvasLayer.visible = false;
		emit_signal("finished");
