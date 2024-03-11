extends Node2D

var origin:KinematicBody2D = null
var player:KinematicBody2D = null

var keepDistance = true
var direction = Vector2.ZERO

var disabled = true
var fleeNavCoolodwn = 0.5

func _physics_process(delta):
	if !disabled:
		fleeNavCoolodwn -= delta
		if player == null || origin == null:
			if player == null:
				#push_error(str(self)+": ERROR 404: PLAYER NOT FOUND")
				pass
			if origin == null:
				#push_error(str(self)+": ERROR 404: ORIGIN NOT FOUND")
				pass
			return
		
		if origin.RayCastAtPlayer():
			if origin.global_position.distance_to(player.global_position) > origin.safeDistance:
				direction = player.global_position - origin.global_position
				origin.direction = direction
				var _velocity = origin.move_and_slide(direction.normalized() * origin.movementSpeed)
				origin.ShootWeapon(player.global_position - origin.global_position)
				origin.LookInWalkingDirection()
			elif origin.global_position.distance_to(player.global_position) > origin.minDistanceToPlayer:
				origin.ShootWeapon(player.global_position - origin.global_position)
				origin.walkingDirection.look_at(player.global_position)
			elif keepDistance:
				if fleeNavCoolodwn <= 0.0:
					fleeNavCoolodwn = rand_range(0.25,0.5)
					origin.Flee(player.global_position)
				origin.ShootWeapon(player.global_position - origin.global_position)
				var _velocity = origin.move_and_slide(origin.direction.normalized() * origin.movementSpeed, Vector2.UP)
		else:
			#if origin.global_position.distance_to(player.global_position) > origin.safeDistance:
			origin.FindDirectionToTarget(player.global_position)
			direction = origin.global_position.direction_to(origin.navigationAgent.get_next_location())
			origin.direction = direction
			var _velocity = origin.move_and_slide(direction.normalized() * origin.movementSpeed)
			origin.LookInWalkingDirection()

func FindOriginTarget(targetLocation):
	if origin == null:
		#push_error("EngagingMovement could't find origin. func FindOriginTarget()")
		return
	origin.navigationAgent.set_target_location(targetLocation)
