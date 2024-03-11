extends Sprite

var difficulty = 0;
var player;

func SetUp(var player_):
	player = player_;

func IncreaseDifficuly(var amount):
	difficulty += amount;

func _process(delta):
	if difficulty > 0:
		$Weapons.TryToFireWeapons(difficulty, player)
