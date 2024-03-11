extends HSlider

func _on_EffectSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), value)
