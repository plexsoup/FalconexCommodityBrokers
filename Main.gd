extends Node

# Declare member variables here. Examples:
onready var global = get_node("/root/global")
var GameViewport
var CurrentScene
var CurrentSceneIndex : int = 0
var ActiveDialogBoxes = []

enum STATES { initializing, playing, paused }
var CurrentState = STATES.playing

onready var LevelScenes = [ "res://Levels/intro.tscn", "res://Levels/Level1.tscn", "res://Levels/Level2.tscn" ]
onready var Panels = get_node("CanvasLayer/Panels")

signal DialogBox_completed_relay(boxTitle)
signal pause_requested()
signal open_panel(panelName)
signal close_panel(panelName)

# Called when the node enters the scene tree for the first time.
func _ready():
	global.setMain(self)
	global.setPlayerController($PlayerController)
	
	GameViewport = $Levels
	setBaseFont()
	
	
func setBaseFont():
	var label = Label.new()
	add_child(label)
	global.BaseFont = label.get_font("")
	remove_child(label)
	label.queue_free()

func launchLevel(level):
	var newScene = LevelScenes[level]
	if CurrentScene != null:
		GameViewport.remove_child(CurrentScene)
		CurrentScene.queue_free()
	GameViewport.add_child(newScene)
	CurrentScene = newScene

func launchNextLevel():
	CurrentSceneIndex += 1
	if CurrentSceneIndex == LevelScenes.size():
		CurrentSceneIndex = 0
	launchLevel(LevelScenes[CurrentSceneIndex])
	
	
func spawnDialogBox(boxTitle, textArr, requestedBy):
	var dialogBox = preload("res://DialogBox.tscn")
	var newDialogBox = dialogBox.instance()
	var dialogBoxContainer = find_node("DialogBoxes")
	dialogBoxContainer.add_child(newDialogBox)
	var GUID = newDialogBox.start(boxTitle, textArr, self, requestedBy)
	ActiveDialogBoxes.push_back(GUID)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_start_level_pressed(level):
	launchLevel(level)
	

func _on_dialog_box_requested(boxTitle, textArr, requestedBy):
	spawnDialogBox(boxTitle, textArr, requestedBy)

func _on_DialogBox_completed(boxTitle, requestedBy):
	connect("DialogBox_completed_relay", requestedBy, "_on_DialogBox_completed")
	emit_signal("DialogBox_completed_relay", boxTitle)
	disconnect("DialogBox_completed_relay", requestedBy, "_on_DialogBox_completed")
	
	print(self.name, " dialogBox completed", boxTitle, requestedBy)
	pass
	
func _on_Level_pause_requested():
	var PausePanel = find_node("PausePanel")
	connect("open_panel", Panels, "_on_open_panel_requested")
	emit_signal("open_panel", "bottom")
	disconnect("open_panel", Panels, "_on_open_panel_requested")
	
	connect("pause_requested", PausePanel, "_on_main_pause_requested")
	emit_signal("pause_requested")
	disconnect("pause_requested", PausePanel, "_on_main_pause_requested")
	
	#PausePanel.unhidePanel()
	
	
#func _on_PausePanel_game_resumed():
#	var PausePanel = $"CanvasLayer/WindowTiler/LeftMarginSplit/RightMarginSplit/spacer-forMainScene/PausePanel"
#	PausePanel.hide()
#	CurrentState = STATES.playing
	
	
func _on_ship_shopping_requested(): # happens when you have > 1000 cash
	# **** this should be a signal. Why are you accessing functions directly?
	var LeftButton = find_node("LeftPanelButton")
	var LeftMarginSplit = find_node("LeftSplitContainer")
	if LeftButton.pressed == false:
		LeftButton.pressed = true
		LeftMarginSplit._on_PanelButton_toggled(true)

func _on_PausePanel_resume_pressed(): # close the bottom panel
	connect("close_panel", Panels, "_on_close_panel_requested")
	emit_signal("close_panel", "bottom")
	disconnect("close_panel", Panels, "_on_close_panel_requested")
