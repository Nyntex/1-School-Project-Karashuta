extends Node2D

export (NodePath) var blue;
export (NodePath) var red;
export (NodePath) var yellow;
export (NodePath) var neutral;

func changeColor(var color):
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
			get_node(red).visible = true;
		ColorEnum.colors.BLUE:
			get_node(blue).visible = true;
		ColorEnum.colors.YELLOW:
			get_node(yellow).visible = true;
		ColorEnum.colors.NEUTRAL:
			get_node(neutral).visible = true;

func ChangeDirection(var targetPos):
	if get_node_or_null(blue) != null:
		get_node(blue).RotateSpriteTowards(targetPos);
	if get_node_or_null(red) != null:
		get_node(red).RotateSpriteTowards(targetPos);
	if get_node_or_null(yellow) != null:
		get_node(yellow).RotateSpriteTowards(targetPos);
	if get_node_or_null(neutral) != null:
		get_node(neutral).RotateSpriteTowards(targetPos);
