extends Node2D

onready var topChecker = $TopChecker
onready var downChecker = $DownChecker
onready var leftChecker = $LeftChecker
onready var rightChecker = $RightChecker

export (float) var wallCheckRange = 50.0
var left
var right
var top
var bottom

func _ready():
	
	pass

func CheckForWalls():
	left = wallCheckRange * -1.0
	right = wallCheckRange
	top = wallCheckRange * -1.0
	bottom = wallCheckRange
	
	for rays in get_children():
		if rays.get_collider() != null:
			match rays:
				topChecker:
					top = 0.0
					
				downChecker:
					bottom = 0.0
					
				leftChecker:
					left = 0.0
					
				rightChecker:
					right = 0.0
	
	#print("finished raycasts")
	return {"left": left, "right": right, "top": top, "bottom": bottom}
