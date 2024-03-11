extends AnimatedSprite

func PlayDeath():
	visible = true
	play("Death")
	yield(self, "animation_finished")
	stop()
	frame = frames.get_frame_count("Death")
	yield(get_tree().create_timer(5),"timeout")
	visible = false
	return

func Revive():
	visible = true
	play("Revive")
	yield(self, "animation_finished")
	stop()
	frame = frames.get_frame_count("Revive")
	return
