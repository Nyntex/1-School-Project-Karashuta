extends Particles2D

func Emit():
	if get_node_or_null("Timer") != null:
		emitting = true
		$Timer.start(lifetime)
		$Timer.connect("timeout", self, "TimerFinished")
	else:
		queue_free()

func TimerFinished():
	queue_free()
