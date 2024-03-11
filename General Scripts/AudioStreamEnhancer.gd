extends AudioStreamPlayer2D

export (float) var pitchVariance;
export (float) var volumeVariance;

var basePitch = 0;
var baseVolume = 0;

func _ready():
	basePitch = pitch_scale
	baseVolume = volume_db;

func ImprovedPlay():
	pitch_scale = basePitch + rand_range(-pitchVariance, pitchVariance);
	volume_db = baseVolume + rand_range(-volumeVariance, volumeVariance);
	play();

func _on_ImpactSound_finished():
	queue_free()

func FadeOut():
	ImprovedPlay();
	if get_node_or_null("AnimationPlayer") != null:
		$AnimationPlayer.play("FadeOut");
	yield(get_tree().create_timer(2.0), "timeout")
	stop();

func FadeIn():
	ImprovedPlay();
	if get_node_or_null("AnimationPlayer") != null:
		$AnimationPlayer.play("FadeIn");

func StickToNode(var target):
	get_parent().remove_child(self);
	target.add_child(self)
	global_position = target.global_position;


func _on_Music_finished():
	ImprovedPlay();
