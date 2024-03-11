extends StaticBody2D

enum Direction{
	N,
	E,
	S,
	W,
}

export (float) var laserRange = 200.0
export (float) var damagePerSecond = 10.0;
export (Direction) var lookDirection = Direction.N
onready var lasers = $Lasers
export (ColorEnum.colors) var currentColor

func _ready():
	MakeReady()

func MatchLookDirection():
	match currentColor:
		ColorEnum.colors.RED:
			$Spriteholder.animation = "red"
		ColorEnum.colors.BLUE:
			$Spriteholder.animation = "blue"
		ColorEnum.colors.YELLOW:
			$Spriteholder.animation = "yellow"
	
	match lookDirection:
		Direction.N:
			$Spriteholder.frame = 3
			$Lasers.rotation_degrees = 270
			$Lasers.position.y = 1
		Direction.E:
			$Spriteholder.frame = 0
			$Lasers.rotation_degrees = 0
			$Lasers.position.y = -11
		Direction.S:
			$Spriteholder.frame = 1
			$Lasers.rotation_degrees = 90
			$Lasers.position.y = -11
		Direction.W:
			$Spriteholder.frame = 2
			$Lasers.rotation_degrees = 180
			$Lasers.position.y = -11

func MakeReady():
	for child in lasers.get_children():
		if child.has_method("SetupColor"):
			child.SetupColor(currentColor)
			child.damagePerSecond = damagePerSecond;
		if child.laserRange:
			child.laserRange = laserRange
	
	MatchLookDirection()
