extends Node2D

signal onAbilityUse();
signal onRedAbilityUse();
signal onBlueAbilityUse();

signal OnAbsorb();

export (float) var ConversionRate = 1.0;

export (PackedScene) var absorbSound

func SetUp(var player):
	$Red.SetUp(player);
	$Blue.SetUp(player);

func Absorb(var color, var damage):
	emit_signal("OnAbsorb");
	PlayAbsorbSound();
	
	match color:
		ColorEnum.colors.BLUE:
			$Blue.fill(damage * ConversionRate);
		ColorEnum.colors.RED:
			$Red.fill(damage * ConversionRate);

func GetBonusDamage(var color):
	match color:
		ColorEnum.colors.RED:
			return $Red.GetBonusDamage();
		ColorEnum.colors.BLUE:
			return $Blue.GetBonusDamage();

func GetBonusSize(var color):
	match color:
		ColorEnum.colors.RED:
			return $Red.GetBonusDamage() / 70;
		ColorEnum.colors.BLUE:
			return $Blue.GetBonusDamage() / 70;

func PlayAbsorbSound():
	var absorbSoundInst = absorbSound.instance()
	absorbSoundInst.connect("finished", absorbSoundInst, "queue_free")
	add_child(absorbSoundInst)
	
	if absorbSoundInst.has_method("ImprovedPlay"):
		absorbSoundInst.ImprovedPlay()
	else:
		absorbSoundInst.play()


func Hide():
	visible = false;
	$Big.visible = false;

func Show():
	visible = true;
	$Big.visible = true;

func HideSmall():
	$Small.visible = false;

func ShowSmall():
	$Small.visible = true;


func ReduceMaxValue(var amount):
	$Blue.fillLimit = clamp($Blue.max_value - amount,0, INF);
	$Red.fillLimit = clamp($Red.max_value - amount,0, INF);
	
func IncreaseMaxValue(var amount):
	$Blue.fillLimit = $Blue.max_value + amount;
	$Red.fillLimit = $Red.max_value + amount;

func _on_Blue_OnSpecial():
	emit_signal("onBlueAbilityUse");
	emit_signal("onAbilityUse");

func _on_Red_OnSpecial():
	emit_signal("onRedAbilityUse");
	emit_signal("onAbilityUse");

func StartHighLight():
	$Big.StartHighLight();

func EndHighLight():
	$Big.EndHighLight();

func Reset():
	$Red.value = 0;
	$Red.targetAmount = 0;
	$Blue.value = 0;
	$Blue.targetAmount = 0;
	
	_on_Red_OnValueChanged();
	_on_Blue_OnValueChanged();

func _on_Red_OnValueChanged():
	$Small.UpdateValue($Red.value, ColorEnum.colors.RED);
	$Big.UpdateValue($Red.value, ColorEnum.colors.RED)
	$Big.UpdateBonusdamage($Red.GetBonusDamage(), ColorEnum.colors.RED);
	
func _on_Blue_OnValueChanged():
	$Small.UpdateValue($Blue.value, ColorEnum.colors.BLUE)
	$Big.UpdateValue($Blue.value, ColorEnum.colors.BLUE)
	$Big.UpdateBonusdamage($Blue.GetBonusDamage(), ColorEnum.colors.BLUE);

