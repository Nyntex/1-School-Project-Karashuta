extends CanvasLayer

func UpdateLocks(var level):
	for i in range($Locks.get_child_count()):
		if i < level && $Locks.get_child(i).has_method("UnLock"):
			$Locks.get_child(i).UnLock();
		elif $Locks.get_child(i).has_method("Lock"):
			$Locks.get_child(i).Lock();
