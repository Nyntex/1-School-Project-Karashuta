extends TextureProgress

var target = 0;
export (float) var fillDuration = 0.5;

var startingValue = 0;
var pastTime;

func SetUp(var health):
	max_value = health * 100;
	value = health * 100;
	target = value;

func ChangeHealthBar(var new):
	target = new * 100;
	startingValue = value;
	pastTime = 0;

func ChangeHealthImmediately(var new):
	target = new * 100;
	value = target;

func _process(delta):
	if pastTime != null:
		pastTime = clamp(pastTime + delta, 0, fillDuration);
		value = lerp(startingValue, target, pastTime / fillDuration)

