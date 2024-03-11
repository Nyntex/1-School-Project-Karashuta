extends Node2D

onready var activeParticle = $Particle_1
onready var inactiveParticle = $Particle_2
export (float) var maxParticles = 1.0
var newAmount = 1.0

func _ready():
	$Timer.wait_time = activeParticle.lifetime

func SetNewAmount(value, max_value):
	newAmount = clamp(maxParticles * (value / max_value), 1, maxParticles)

func UpdateParticleAmount():
	inactiveParticle.amount = newAmount
	inactiveParticle.speed_scale = (newAmount / maxParticles) * 3 + 1 #Can be removed at will
	inactiveParticle.emitting = true
	activeParticle.emitting = false
	var shortLivedInstance = activeParticle
	activeParticle = inactiveParticle
	inactiveParticle = shortLivedInstance

