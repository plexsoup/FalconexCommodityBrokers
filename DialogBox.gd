"""
DialogBox displays a succession of text strings from an array.
Individual letters are revealed with keystroke audio on a timer timeout.

SceneTree should look like this:
	DialogBox : Node2D
	DialogTextBox : TextEdit
	KeypressNoise : AudioStream
	DialogTextLabel : Label
		LetterTimer : Timer


"""

extends Control

# Declare member variables here. Examples:

export var DialogText : Array  = [""]

onready var LetterTimer = $Panel/MarginContainer/LetterTimer
onready var DialogBox = $Panel/MarginContainer/DialogTextBox
onready var KeypressAudio = $Panel/MarginContainer/KeypressNoise

var CurrentLine = 0
var DisplayedText = ""
var CurrentLineText = ""
var NumLettersDisplayed : int = 0
var GUID : String
var RequestedBy
var BoxTitle : String

#var NodeToFollow

signal initialized
signal completed(boxName, requestedBy)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func start(boxTitle : String, textArray : Array, parentScene, requestedBy):
	BoxTitle = boxTitle
	DialogText = textArray
	RequestedBy = requestedBy
	#GUID = getCallbackIndex()
		
	#connect("initialized", global.getCurrentPlayer(), "_on_dialogBox_initialized")
	connect("completed", parentScene, "_on_DialogBox_completed")

	DisplayedText = ""
	if DialogText.size() > 0:
		CurrentLineText = DialogText[0]
	else:
		end() # quit if there's no text to show
	LetterTimer.start()
	#NodeToFollow = nodeToFollow
	#DialogBox.set_wrap_enabled(true)
	DialogBox.set_bbcode(CurrentLineText)
	DialogBox.set_visible_characters(0)
	#DialogBox.set_position(newPosition)

	#emit_signal("initialized")
	return GUID

#func arr2str(arr):
#	var returnStr = ""
#	for i in arr:
#		returnStr += i
#	return returnStr

# this works, but it's not needed
#func getCallbackIndex():
#	var textStr = "a,b,c,d,e,f,1,2,3,4,5,6,7,8,a,b,c,d,e,f,1,2,3,4,5,6,7,8"
#	var textArr = Array(textStr.split(","))
#	textArr.shuffle()
#	var GUIDStr = arr2str(textArr)
#	print(self.name, " GID == ", GUIDStr)
#	return GUIDStr
	
func end():
	emit_signal("completed", BoxTitle, RequestedBy)

	queue_free()

func showNextLine():
	CurrentLine += 1
	NumLettersDisplayed = 0
	if CurrentLine >= DialogText.size():
		end()
	else:
		CurrentLineText = DialogText[CurrentLine]
		DialogBox.set_bbcode(CurrentLineText)
		DialogBox.set_visible_characters(NumLettersDisplayed)
		LetterTimer.start()
		


func showNextLetter():
	if NumLettersDisplayed < CurrentLineText.length():
		LetterTimer.start()


		NumLettersDisplayed += 1
		KeypressAudio.play()
		
		
	DialogBox.set_visible_characters(NumLettersDisplayed)
	#DialogBox.set_text(CurrentLineText.left(NumLettersDisplayed))

func revealAllLettersOrShowNextLine():
	if NumLettersDisplayed < CurrentLineText.length(): # show the whole message
		NumLettersDisplayed = CurrentLineText.length()
	else: # show the next line
		showNextLine()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		end()
	
#	if is_instance_valid(NodeToFollow):
#		set_global_position(NodeToFollow.get_global_position() + Vector2(0, -200))
	if Input.is_action_just_pressed("ui_accept"):
		revealAllLettersOrShowNextLine()

	if Input.is_action_just_pressed("shoot"):
		revealAllLettersOrShowNextLine()



func _on_LetterTimer_timeout():
	showNextLetter()



# allow the user to left-click on the dialog box to proceed.
# (but not mouse-wheel!)
#func _on_ColorRect_gui_input(event):
#	if event is InputEventMouseButton and event.is_pressed():
#		if event.button_index == BUTTON_LEFT:
#			revealAllLettersOrShowNextLine()


func _on_DialogTextBox_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			revealAllLettersOrShowNextLine()
			

func _on_DialogTextBox_meta_clicked(meta):
	#HMM. The gui_input click to skip through text seems to interfere with the meta-clicked
	print(self.name, " clicked on URL", meta)
	pass
	#OS.shell_open(meta);
	#OS.shell_execute("https://www.github.com/plexsoup");


func _on_Panel_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			revealAllLettersOrShowNextLine()