extends Node2D

export (NodePath) var blue;
export (NodePath) var red;
export (NodePath) var yellow;
export (NodePath) var neutral;


func change_Color(var color, var _direction):
	if get_node_or_null(blue) != null:
		get_node(blue).visible = false;
	if get_node_or_null(red) != null:
		get_node(red).visible = false;
	if get_node_or_null(yellow) != null:
		get_node(yellow).visible = false;
	if get_node_or_null(neutral) != null:
		get_node(neutral).visible = false;
	
	match color:
		ColorEnum.colors.RED:
			if get_node_or_null(red) != null:
				get_node(red).visible = true;
		ColorEnum.colors.BLUE:
			if get_node_or_null(blue) != null:
				get_node(blue).visible = true;
		ColorEnum.colors.YELLOW:
			if get_node_or_null(yellow) != null:
				get_node(yellow).visible = true;
		ColorEnum.colors.NEUTRAL:
			if get_node_or_null(neutral) != null:
				get_node(neutral).visible = true;
