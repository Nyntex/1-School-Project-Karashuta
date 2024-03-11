extends StaticBody2D

var player = null

export (ColorEnum.colors) var currentColor
onready var spriteHolder = $ColorAndSpriteHolder

#current Weapon of the Enemy changeable in inspector
export (PackedScene) var weaponScene
var weapon = null

func Setup(_player):
	player = _player
	
	ChangeColor(currentColor)

func _ready():
	#Add the weapon to the Enemy
	weapon = weaponScene.instance()
	weapon.currentColor = currentColor
	add_child(weapon)
	weapon.look_at(Vector2.LEFT + global_position)
	

func _physics_process(_delta):
	#if player != null: #Nur wenn der Spieler existiert soll der Gegner sich Bewegen etc.
		ShootWeapon()
	
func ShootWeapon():
	if weapon != null && player != null:
		weapon.TryFire(Vector2.LEFT, self)

func ChangeColor(color):
	spriteHolder.changeColor(color)
