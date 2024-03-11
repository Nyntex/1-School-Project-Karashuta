extends Camera2D

export (float) var shakeDuration = 0.1;
export (float) var shakeImpact = 0.05;
var shakeStartTime = INF;
var shakeDirection = Vector2();

var baseZoom = Vector2(1,1);
var targetZoom = Vector2(1,1);
var startingZoom = Vector2(1,1);
var zoomDuration = 1;
var zoomStartTime = INF;
var freezeZoom = false;

func _ready():
	baseZoom = zoom;
	targetZoom = baseZoom;

func Shake(var direction):
	shakeDirection = direction * shakeImpact;
	shakeStartTime = 0;

func Zoom(var amount, var duration):
	freezeZoom = false;
	targetZoom = amount;
	zoomStartTime = 0;
	zoomDuration = duration;
	startingZoom = zoom;


func _process(delta):
	shakeStartTime += delta;
	zoomStartTime += delta;

	if shakeStartTime <= shakeDuration * 0.5:
		offset_v = lerp(0,shakeDirection.y, shakeStartTime / (shakeDuration * 0.5));
		offset_h = lerp(0,shakeDirection.x, shakeStartTime / (shakeDuration * 0.5));
	elif shakeStartTime <= shakeDuration:
		offset_v = lerp(shakeDirection.y, 0, (shakeStartTime - shakeDuration *0.5) / (shakeDuration * 0.5));
		offset_h = lerp(shakeDirection.x, 0, (shakeStartTime - shakeDuration *0.5) / (shakeDuration * 0.5));
	else:
		offset_v = 0;
		offset_h = 0;
	
	if !freezeZoom:
		if zoom != targetZoom:
			var newZoom = lerp(startingZoom, targetZoom, float(zoomStartTime) / float(zoomDuration))
			
			if targetZoom < startingZoom:
				newZoom.x = clamp(newZoom.x, targetZoom.x, startingZoom.x)
				newZoom.y = clamp(newZoom.y, targetZoom.y, startingZoom.y)
			else:
				newZoom.x = clamp(newZoom.x, startingZoom.x, targetZoom.x)
				newZoom.y = clamp(newZoom.y, startingZoom.y, targetZoom.y)
				
			zoom = newZoom;
			
		elif zoom != baseZoom && zoomStartTime != 0:
			zoomStartTime = 0;
			targetZoom = baseZoom
			startingZoom = zoom;
			freezeZoom = true;
