extends AnimatedSprite

const animationDegree = 45
const animations = 8

func EnableAnimation(rotationOfCharacter):
	visible = true
	var animToPlay = int((rotationOfCharacter + animationDegree / 2) / animationDegree) + 1;
	#animToPlay = clamp(animToPlay,1,8);
	if animToPlay > 8:
		animToPlay -= 8
	animation = str(animToPlay);
	#print(animation)
	playing = true

func DisableAnimation():
	visible = false
	playing = false
