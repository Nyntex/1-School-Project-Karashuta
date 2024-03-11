extends TextureRect

export (Texture) var normalLock;
export (Texture) var unlockedLock;

func Lock():
	texture = normalLock;

func UnLock():
	texture = unlockedLock;
