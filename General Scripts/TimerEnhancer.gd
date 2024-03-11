extends Timer

export (float) var minVariance;
export (float) var maxVariance;

var baseDuration = null;

func ImprovedStart():
	if baseDuration == null:
		baseDuration = wait_time;
		
	randomize();
	start(baseDuration + rand_range(minVariance, maxVariance));

func RandomizeStart(var range_):
	if baseDuration == null:
		baseDuration = wait_time;
	
	randomize();
	start(baseDuration * (1 - rand_range(0, range_)));
