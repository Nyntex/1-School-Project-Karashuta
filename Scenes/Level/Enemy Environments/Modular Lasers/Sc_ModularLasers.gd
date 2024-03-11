extends StaticBody2D

export (String) var __ = "Editable"
export (Array, NodePath) var laserTargets = []
export (ColorEnum.colors) var currentColor


export (String) var ___ = ""
export (String) var ____ = "DO NOT EDIT"
export (PackedScene) var laserScene

var laserArray = []
var targetArray = []
onready var laserSpawnpoint = $LaserSpawnpoint


func _physics_process(delta):
	for target in targetArray.size():
		if targetArray[target] != null:
			laserArray[target].rotation_degrees = 0
			if !targetArray[target].get("laserSpawnpoint"):
				laserArray[target].rotation_degrees = rad2deg(laserArray[target].get_angle_to(targetArray[target].global_position))
				laserArray[target].laserRange = laserArray[target].global_position.distance_to(targetArray[target].global_position)
			if targetArray[target].get("laserSpawnpoint"):
				laserArray[target].rotation_degrees = rad2deg(laserArray[target].get_angle_to(targetArray[target].laserSpawnpoint.global_position))
				laserArray[target].laserRange = laserArray[target].global_position.distance_to(targetArray[target].laserSpawnpoint.global_position)
			#print(to_local(targetArray[target].global_position), " | ", currentLaser.cast_to)

func MakeReady():
	if laserTargets.size() > 0:
		for i in laserTargets:
			var laserInst = laserScene.instance()
			laserSpawnpoint.add_child(laserInst)
			if laserInst.has_method("SetupColor"):
				laserInst.SetupColor(currentColor)
			laserInst.z_index = 1
			laserArray.append(laserInst)
			targetArray.append(get_node(i))
	
	#print(targetArray)
