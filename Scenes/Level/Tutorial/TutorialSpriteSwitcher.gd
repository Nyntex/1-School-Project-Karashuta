extends TextureRect

export (Array, Texture) var textures;
export (bool) var loop = false;
var reverse = false;

var index = 0;

func _on_Timer_timeout():
	texture = textures[index];
	
	if !reverse:
		index += 1;
		if index > textures.size() - 1:
			index = 0;
			if loop:
				reverse = true;
				index = textures.size() - 1;
	else:
		index -= 1;
		if index <= 0:
			index = 1;
			reverse = false;
