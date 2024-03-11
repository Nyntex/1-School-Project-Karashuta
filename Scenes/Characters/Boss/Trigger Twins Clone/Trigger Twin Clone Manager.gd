extends Node2D

export (ColorEnum.colors) var currentColor;

export (PackedScene) var machineGun;
var activeMachineGun;
export (PackedScene) var shotGun;
var activeShotGun;
export (PackedScene) var jumpGun;
var activeJumpGun;

func Setup(var player):
	if get_node_or_null("AdvancedAI") == null:
		return;
		
	$AdvancedAI.currentColor = currentColor;
	$AdvancedAI.Setup(player);
	
	activeMachineGun = machineGun.instance();
	$AdvancedAI.add_child(activeMachineGun);
	activeMachineGun.global_position = $AdvancedAI.global_position;
	activeMachineGun.currentColor = $AdvancedAI.currentColor;
	
	activeShotGun = shotGun.instance();
	$AdvancedAI.add_child(activeShotGun);
	activeShotGun.global_position = $AdvancedAI.global_position;
	activeShotGun.currentColor = $AdvancedAI.currentColor;
	
	activeJumpGun = jumpGun.instance();
	$AdvancedAI.add_child(activeJumpGun);
	activeJumpGun.global_position = $AdvancedAI.global_position;
	activeJumpGun.currentColor = $AdvancedAI.currentColor;

	$MachineGun/MachineGunCooldown.RandomizeStart(0.25);
	$Charge/ChargeCoolDown.RandomizeStart(0.25);
	$Shotgun/ShotgunCooldown.RandomizeStart(0.25);
	$Jump/JumpCoolDown.RandomizeStart(0.25);

func _on_ChargeCoolDown_timeout():
	if get_node_or_null("AdvancedAI") == null:
		return;
	
	if !IsSpecialAttackRunning():
		$Charge/ChargeDuration.start();
		
		$AdvancedAI.movementSpeed = 0;
		$AdvancedAI.weapon = null;
		yield(get_tree().create_timer($Jump/JumpDuration.wait_time * 0.8), "timeout")
		
		$AdvancedAI.weapon = $AdvancedAI.baseWeapon;
		$AdvancedAI.movementSpeed = $AdvancedAI.baseMovementSpeed * 2.5;
		$AdvancedAI.safeDistance = 100;
		$AdvancedAI.weapon.fireRate = $AdvancedAI.weapon.baseFireRate * 3;
	else:
		$Charge/ChargeCoolDown.start($Charge/ChargeCoolDown.baseDuration * rand_range(0.2, 0.2))

func _on_ChargeDuration_timeout():
	if get_node_or_null("AdvancedAI") == null:
		return;
	
	$Charge/ChargeCoolDown.ImprovedStart();
	
	$AdvancedAI.movementSpeed = $AdvancedAI.baseMovementSpeed;
	$AdvancedAI.safeDistance = $AdvancedAI.baseSafeDistance;
	$AdvancedAI.weapon.fireRate = $AdvancedAI.weapon.baseFireRate;


func _on_MachineGunCooldown_timeout():
	if get_node_or_null("AdvancedAI") == null:
		return;
	
	if !IsSpecialAttackRunning():
		$MachineGun/MachineGunDuration.start();
		$AdvancedAI.movementSpeed = 0;
		$AdvancedAI.weapon = activeMachineGun;
	else:
		$MachineGun/MachineGunCooldown.start($MachineGun/MachineGunCooldown.baseDuration * rand_range(0.2, 0.2))

func _on_MachineGunDuration_timeout():
	if get_node_or_null("AdvancedAI") == null:
		return;
	
	$MachineGun/MachineGunCooldown.ImprovedStart();
	$AdvancedAI.movementSpeed = $AdvancedAI.baseMovementSpeed;
	$AdvancedAI.weapon = $AdvancedAI.baseWeapon;


func _on_ShotgunCooldown_timeout():
	if get_node_or_null("AdvancedAI") == null:
		return;
	
	if !IsSpecialAttackRunning():
		$Shotgun/ShotgunDuration.start();
		$AdvancedAI.weapon = activeShotGun;
	else:
		$Shotgun/ShotgunCooldown.start($Shotgun/ShotgunCooldown.baseDuration * rand_range(0.2, 0.2))


func _on_ShotgunDuration_timeout():
	if get_node_or_null("AdvancedAI") == null:
		return;
	
	$Shotgun/ShotgunCooldown.ImprovedStart();
	$AdvancedAI.weapon = $AdvancedAI.baseWeapon;


func _on_JumpDuration_timeout():
	if get_node_or_null("AdvancedAI") == null:
		return;
	
	$Jump/JumpCoolDown.ImprovedStart()
	$AdvancedAI.movementSpeed = $AdvancedAI.baseMovementSpeed;
	$AdvancedAI.weapon = $AdvancedAI.baseWeapon;
	
func _on_JumpCoolDown_timeout():
	if get_node_or_null("AdvancedAI") == null:
		return;
	
	if !IsSpecialAttackRunning():
		$Jump/JumpDuration.start();
		$AdvancedAI.movementSpeed = 0;
		$AdvancedAI.weapon = null;
		yield(get_tree().create_timer($Jump/JumpDuration.wait_time * 0.8), "timeout")
		if is_instance_valid(activeJumpGun):
			$AdvancedAI.weapon = activeJumpGun;
	else:
		$Jump/JumpCoolDown.start($Jump/JumpCoolDown.baseDuration * rand_range(0.2, 0.2))
		
func IsSpecialAttackRunning():
	return $Charge/ChargeDuration.time_left > 0 || $MachineGun/MachineGunDuration.time_left > 0 || $Shotgun/ShotgunDuration.time_left > 0 || $Jump/JumpDuration.time_left > 0;

func BeginRage():
	if $AdvancedAI.health < $AdvancedAI.maxHealth * 0.5:
		$AdvancedAI.health = $AdvancedAI.maxHealth * 0.5;
		$AdvancedAI.TakeDamage(ColorEnum.colors.NEUTRAL, 0, self);
		
	$Charge/ChargeCoolDown.wait_time = $Charge/ChargeCoolDown.wait_time * 0.75;
	$Charge/ChargeCoolDown.baseDuration = $Charge/ChargeCoolDown.wait_time ;
		
	$MachineGun/MachineGunCooldown.wait_time = $MachineGun/MachineGunCooldown.wait_time * 0.75;
	$MachineGun/MachineGunCooldown.baseDuration = $MachineGun/MachineGunCooldown.wait_time ;
		
	$Shotgun/ShotgunCooldown.wait_time = $Shotgun/ShotgunCooldown.wait_time * 0.75;
	$Shotgun/ShotgunCooldown.baseDuration = $Shotgun/ShotgunCooldown.wait_time;
		
	$Jump/JumpCoolDown.wait_time = $Jump/JumpCoolDown.wait_time * 0.75;
	$Jump/JumpCoolDown.baseDuration =  $Jump/JumpCoolDown.wait_time;
		
	$AdvancedAI.baseMovementSpeed *= 1.25;
	$AdvancedAI.movementSpeed *= 1.25;
		
	$AdvancedAI.baseWeapon.fireRate *= 0.8;
	
	$RageWeaponColorSwitchTimer.start();

func _on_RageWeaponColorSwitchTimer_timeout():
	if get_node_or_null("AdvancedAI") != null:
		if $AdvancedAI.baseWeapon.currentColor == ColorEnum.colors.BLUE:
			$AdvancedAI.baseWeapon.currentColor = ColorEnum.colors.RED;
			activeJumpGun.currentColor = ColorEnum.colors.RED;
			activeMachineGun.currentColor = ColorEnum.colors.RED;
			activeShotGun.currentColor = ColorEnum.colors.RED;
		else:
			$AdvancedAI.baseWeapon.currentColor = ColorEnum.colors.BLUE;
			activeJumpGun.currentColor = ColorEnum.colors.BLUE;
			activeMachineGun.currentColor = ColorEnum.colors.BLUE;
			activeShotGun.currentColor = ColorEnum.colors.BLUE;
		
		$RageWeaponColorSwitchTimer.start();

