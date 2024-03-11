extends Control

var level = 0;

func SetUp():
	Load();
	UpdateLocks();

func LevelUp():
	level += 1;
	UpdateLocks();
	Save();

func Save():
	var save = Saver.new();
	save.LoadSave();
	save.playerSavingStats.bossDoorProgression = level;
	save.WriteSave();

func Load():
	var save = Saver.new();
	save.LoadSave();
	level = save.playerSavingStats.bossDoorProgression;

func UpdateLocks():
	for i in range(get_child_count()):
		if i < level && get_child(i).has_method("UnLock"):
			get_child(i).UnLock();
		elif get_child(i).has_meta("Lock"):
			get_child(i).Lock();
