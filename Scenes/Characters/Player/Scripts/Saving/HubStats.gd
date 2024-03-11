class_name HubStats
extends Resource

export (float) var EasyLevels = 0.0
export (float) var MidLevels = 0.0
export (float) var HardLevels = 0.0

export (float) var EasyXPLeft = 0.0
export (float) var MidXPLeft = 0.0
export (float) var HardXPLeft = 0.0

func get_data():
	return {
				"EasyLevels": EasyLevels,
				"MidLevels": MidLevels,
				"HardLevels": HardLevels,
				
				"EasyXPLeft": EasyXPLeft,
				"MidXPLeft": MidXPLeft,
				"HardXPLeft": HardXPLeft,
			}

func set_data(data):
	if data.has("EasyLevels"):
		EasyLevels = data.EasyLevels
	if data.has("MidLevels"):
		MidLevels = data.MidLevels
	if data.has("HardLevels"):
		HardLevels = data.HardLevels
	
	if data.has("EasyXPLeft"):
		EasyXPLeft = data.EasyXPLeft
	if data.has("MidXPLeft"):
		MidXPLeft = data.MidXPLeft
	if data.has("HardXPLeft"):
		HardXPLeft = data.HardXPLeft
