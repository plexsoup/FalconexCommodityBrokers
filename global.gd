extends Node

# Declare member variables here. Examples:

var CurrentScene
var CurrentPlayerController
var CurrentPlayerShip : RigidBody2D = null
var CurrentCamera
var CurrentLevel
var CurrentGalaxy
var BaseFont
var GameSpeed : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func getPlayerShip():
	return CurrentPlayerShip
	
func setPlayerShip(playerNode):
	CurrentPlayerShip = playerNode

func setPlayerController(controller):
	CurrentPlayerController = controller
	
func getPlayerController():
	return CurrentPlayerController

func getCurrentLevel():
	#print(self.name, " returning ", CurrentLevel, " for getCurrentLevel()"  )
	return CurrentLevel

func setCurrentLevel(levelNode):
	CurrentLevel = levelNode
	#print(self.name, " CurrentLevel == ", CurrentLevel )

func setGalaxy(galaxy):
	CurrentGalaxy = galaxy

func getGalaxy():
	return CurrentGalaxy

func setGameSpeed(speed):
	GameSpeed = speed

func getGameSpeed():
	return GameSpeed
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
