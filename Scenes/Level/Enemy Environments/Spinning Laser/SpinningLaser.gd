extends StaticBody2D

onready var rotationNode = $RotationNode
onready var laserGen = $LaserGenerator
export (float) var rotationSpeed = 45.0;
var amountOfFrames = 1.0
var frameRange = 360.0
export (float) var laserRange = 200.0

export (ColorEnum.colors) var currentColor
var setuped = false

func MakeReady():
	amountOfFrames = laserGen.frames.get_frame_count("SpinningLaser")
	frameRange = 360.0 / amountOfFrames
	for child in rotationNode.get_children():
		if child.has_method("SetupColor"):
			child.SetupColor(currentColor)
		if child.get("laserRange") != null:
			child.laserRange = laserRange
	#print("FrameRange: ", frameRange)
	setuped = true

func _process(delta):
	if setuped:
		rotationNode.rotation_degrees += 1 * delta * rotationSpeed
		if rotationSpeed > 0:
			if rotationNode.rotation_degrees >= (360):
				rotationNode.rotation_degrees -= 360 
		else:
			if rotationNode.rotation_degrees <= (0):
				rotationNode.rotation_degrees += 360
		
		#print(rotationNode.rotation_degrees)
		RotateLaser()
		#print(laserGen.frame)


func RotateLaser():
	if rotationSpeed > 0:
		if rotationNode.rotation_degrees <= (360):
			laserGen.frame = int((rotationNode.rotation_degrees) / frameRange)
		else:
			laserGen.frame = 0
		
	elif rotationSpeed < 0:
		if rotationNode.rotation_degrees <= (0):
			laserGen.frame = int((rotationNode.rotation_degrees) / frameRange)
		else:
			laserGen.frame = 0
