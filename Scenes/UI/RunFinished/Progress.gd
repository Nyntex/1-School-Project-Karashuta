extends Control

func SetProgress(var bosslevel):
	for i in get_child_count():
		if i <  clamp(bosslevel,0,INF):
			get_child(i).Unlock();
		elif i == clamp(bosslevel,0,INF):
			get_child(i).disabled = false;
		else:
			get_child(i).disabled = true;
