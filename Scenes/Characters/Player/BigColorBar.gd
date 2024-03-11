extends TextureProgress

var targetAmount = 0;
export (PackedScene) var specialWeapon;
var weapon;
var player;

var fillLimit = INF;

signal OnSpecial();

export (NodePath) var powerMeter = null

func SetUp(var player_):
	player = player_;
	
	weapon = specialWeapon.instance()
	player.add_child(weapon)
	weapon.global_position = player.global_position;
	
	value = 0;
	targetAmount = 0;
	$CooldownTimer.stop();
	$HoldTimer.stop();
	
	if get_node_or_null(powerMeter) != null:
		if get_node(powerMeter).has_method("SetNewAmount"):
			get_node(powerMeter).SetNewAmount(value, max_value)
	
func fill(var amount):
	if !$CooldownTimer.is_stopped():
		return;
		
	targetAmount = clamp(clamp(targetAmount + amount,0,max_value),0,fillLimit);
	$HoldTimer.wait_time = 2.0;
	$HoldTimer.start();
	$DecreaseTimer.stop();

func _process(delta):
	$BonusDamage/Label.text = "+" + str(GetBonusDamage())
	
	if !$CooldownTimer.is_stopped():
		value = $CooldownTimer.time_left / $CooldownTimer.wait_time * 100;
		if get_node_or_null(powerMeter) != null:
			if get_node(powerMeter).has_method("SetNewAmount"):
				get_node(powerMeter).SetNewAmount(value, max_value)
		return;
		
	if value < targetAmount:
		value += 100 * delta;
		if value >= max_value:
			UseSpecial();
			
	if value > targetAmount:
		value -= 100 * delta;
	
	if get_node_or_null(powerMeter) != null:
		if get_node(powerMeter).has_method("SetNewAmount"):
			get_node(powerMeter).SetNewAmount(value, max_value)

func UseSpecial():
	weapon.currentColor = player.currentColor;
	weapon.Fire(Vector2(1,0), player);
	
	targetAmount = 0;
	$CooldownTimer.start();
	$HoldTimer.stop();
	$DecreaseTimer.stop();
	
	emit_signal("OnSpecial");

func _on_DecreaseTimer_timeout():
	targetAmount = clamp(targetAmount - 3, 0,max_value);

func _on_HoldTimer_timeout():
	$HoldTimer.stop();
	$DecreaseTimer.start();
	_on_DecreaseTimer_timeout();

func _on_CooldownTimer_timeout():
	$CooldownTimer.stop();

func GetBonusDamage():
	return clamp(int(value / 3), 0, INF);
