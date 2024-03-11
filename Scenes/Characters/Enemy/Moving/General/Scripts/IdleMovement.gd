extends Node2D

var origin:KinematicBody2D = null
var player:KinematicBody2D = null
var startingPosition = Vector2.ZERO

export (float) var maxDistanceFromOrigin = 350.0
export (float) var walkRangeMultiplier = 2.0

var direction = Vector2.ZERO

var disabled = false

func _physics_process(_delta):
	if !disabled:
		if player != null && origin != null:
			direction = origin.global_position.direction_to(origin.navigationAgent.get_next_location())
			origin.direction = direction
			if !origin.navigationAgent.is_navigation_finished():
				# warning-ignore:return_value_discarded
				origin.move_and_slide(direction.normalized() * origin.movementSpeed)
				origin.LookInWalkingDirection()

func IdleWallCheck():
	#Er soll nur in die Richtung laufen in welcher nicht direkt eine Wand ist, dafür reichen 4 Richtungen
	#Daher verwende ich einen WallChecker um zu schauen ob in einer der Richtungen eine Wand ist
	#je nachdem ob die Raycasts eine Wand treffen wird der randomizer angepasst, 
	#der bestimmt wohin er schlussendlich gehen soll
	if origin == null:
		#push_error("IdleMovement could't find origin. func IdleWallCheck()")
		return
	
	var directions = $WallChecker.CheckForWalls()
	
	#print("left: ", directions.left," | right: ", directions.right, " | top: ", directions.top, " | bottom: ", directions.bottom)
	var targetPos = global_position + (Vector2(rand_range(directions.left, directions.right), rand_range(directions.top, directions.bottom)) * walkRangeMultiplier)
	if startingPosition.distance_to(targetPos) > maxDistanceFromOrigin:
		targetPos = startingPosition + (Vector2(rand_range(directions.left, directions.right), rand_range(directions.top, directions.bottom)) * walkRangeMultiplier)
		origin.navigationAgent.set_target_location(targetPos) 
	else:
		origin.navigationAgent.set_target_location(targetPos) 
	
	#print(targetPos, " | ", startingPosition)
