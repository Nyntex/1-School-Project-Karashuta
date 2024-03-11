extends Node2D

signal OnDeath();
signal onBerserkStart();
signal onBerserkEnd();

var health;
var maxHealth;

func SetUp(var maxHealth_):
	maxHealth = maxHealth_;
	health = maxHealth
	$CanvasLayer/Healthbar.SetUp(health)
	$CanvasLayer/Healthbar.ChangeHealthBar(health);
	

func HealDamage(var healing):
	health = clamp(health + healing, 0, maxHealth);
	$CanvasLayer/Healthbar.ChangeHealthImmediately(health);
	
	if health >= 1.0:
		emit_signal("onBerserkEnd");

func TakeDamage(var damage, var forced = false):
	if !$InvincibilityDuration.is_stopped() && !forced:
		return;
	$InvincibilityDuration.start();
	
	health = clamp(health - damage, 0, maxHealth)
	$CanvasLayer/Healthbar.ChangeHealthBar(health);
	
	$CanvasLayer/TakeDamage/AnimationPlayer.stop();
	$CanvasLayer/TakeDamage/AnimationPlayer.play("TakeDamage");
	$CanvasLayer/TakeDamage/AudioStreamPlayer2D.ImprovedPlay();
	
	if health <= 0:
		emit_signal("OnDeath");
		$CanvasLayer/TakeDamage/AnimationPlayer.stop();
	elif health <= maxHealth / 5:
		emit_signal("onBerserkStart");

func Reset():
	health = maxHealth;
	$CanvasLayer/Healthbar.ChangeHealthImmediately(health)
	$CanvasLayer/TakeDamage/AnimationPlayer.stop();
