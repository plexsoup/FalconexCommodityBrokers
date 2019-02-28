extends Node

# Declare member variables here. Examples:
onready var global = get_node("/root/global")
var GameViewport
var CurrentScene

onready var LevelScenes = [ "res://Levels/Level1.tscn", "res://Levels/Level2.tscn" ]
# Called when the node enters the scene tree for the first time.
func _ready():
	global.setPlayerController($PlayerController)
	
	GameViewport = $WindowTiler/LeftMarginSplit/RightMarginSplit/ViewportContainer/Viewport
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
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_start_level_pressed(level):
	launchLevel(level)
	
