extends Node2D

func _ready():
	$BossUI.visible = false;

func Setup(var player):
	$BossUI.visible = true;
	$Boss1.Setup(player);
	$Boss2.Setup(player);
	
	$BossUI/Healthbars/Boss1.SetUp($Boss1/AdvancedAI.health);
	$BossUI/Healthbars/Boss2.SetUp($Boss2/AdvancedAI.health);
	
	$Boss1/AdvancedAI.connect("OnTakeDamage", self, "UpdateHealthBars")
	$Boss2/AdvancedAI.connect("OnTakeDamage", self, "UpdateHealthBars")
	
	$Boss1/AdvancedAI.connect("OnDeath", self, "StartRageMode");
	$Boss2/AdvancedAI.connect("OnDeath", self, "StartRageMode");
	
func UpdateHealthBars(var _damageTaken):
	if get_node_or_null("Boss1/AdvancedAI") != null:
		$BossUI/Healthbars/Boss1.ChangeHealthBar($Boss1/AdvancedAI.health);
	if get_node_or_null("Boss2/AdvancedAI") != null:
		$BossUI/Healthbars/Boss2.ChangeHealthBar($Boss2/AdvancedAI.health);

func StartRageMode():
	yield(get_tree().create_timer(0), "timeout")
	if get_node_or_null("Boss1/AdvancedAI") != null:
		$Boss1.BeginRage();
	elif get_node_or_null("Boss2/AdvancedAI") != null:
		$Boss2.BeginRage();
	else:
		queue_free();
