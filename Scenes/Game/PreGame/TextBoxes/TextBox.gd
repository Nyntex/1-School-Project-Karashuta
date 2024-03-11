extends Control

var finishedText = ""
var currentText = ""
onready var textLabel = $TextLabel

export (int) var textSpeed = 2

func _ready():
	finishedText = textLabel.text
	textLabel.text = ""

func _process(delta):
	textLabel.text = currentText

func StartTextBoxWriting():
	for character in range(0, finishedText.length(), textSpeed):
		if textLabel.text == finishedText:
			return
		
		
		currentText += str(finishedText[character])
		for i in range(1, textSpeed):
			if character + 2 <=  finishedText.length():
				character += 1
				currentText += str(finishedText[character])
		
		
		yield(get_tree().create_timer(0),"timeout")

func SkipToFullText():
	currentText = finishedText
