extends Node2D

var textBoxArray = []
export (int) var textBoxNumber = 0

signal Finished
var saver = Saver.new()

func _ready():
	textBoxNumber = 0
	textBoxArray = $TextBoxes.get_children()
	for item in textBoxArray:
		item.visible = false
	if textBoxArray != []:
		textBoxArray[textBoxNumber].visible = true
		set_process(false)

func _process(delta):
	if visible:
		if textBoxArray != []:
			if Input.is_action_just_pressed("Interact") || Input.is_action_just_pressed("SELECT"):
				if textBoxArray[textBoxNumber].currentText == "":
					textBoxArray[textBoxNumber].StartTextBoxWriting()
				elif textBoxArray[textBoxNumber].currentText == textBoxArray[textBoxNumber].finishedText:
					NextTextBox()
				elif textBoxArray[textBoxNumber].currentText != "":
					textBoxArray[textBoxNumber].SkipToFullText()

func ActivateBoxes():
	visible = false
	saver.LoadSave()
	if saver.playerSavingStats.startedForFirstTime == true:
		saver.playerSavingStats.startedForFirstTime = false
		saver.WriteSave()
		if textBoxArray == []:
			Finished()
			return
		set_process(true)
		$AnimationPlayer.play("FadeIn")
	else:
		yield(get_tree().create_timer(0.05),"timeout")
		emit_signal("Finished")

func NextTextBox():
	if textBoxNumber + 1 >= textBoxArray.size():
		Finished()
		return
	textBoxArray[textBoxNumber].visible = false
	textBoxNumber += 1
	textBoxArray[textBoxNumber].visible = true
	textBoxArray[textBoxNumber].StartTextBoxWriting()

func Finished():
	$AnimationPlayer.play("FadeOut")

#Stats ControllerSupport
func _input(event):
	if visible:
		$Control/ControllerSelected.visible = event is InputEventJoypadButton || event is InputEventJoypadMotion;
