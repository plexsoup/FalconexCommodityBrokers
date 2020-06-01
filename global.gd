extends Node

# Declare member variables here. Examples:

var Main
var CurrentScene
var CurrentPlayerController
var CurrentPlayerShip : RigidBody2D = null
var CurrentCamera
var CurrentLevel
var CurrentGalaxy
var BaseFont
var GameSpeed : float = 1.0 # 1.0 is normal

enum STATES { paused, active }
var CurrentState = STATES.active
var TicksPaused = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func getState():
	return CurrentState

func pauseGame():
	CurrentState = STATES.paused
	get_tree().paused = true
	TicksPaused = 0

func resumeGame():
	CurrentState = STATES.active
	get_tree().paused = false

func quitGame():
	get_tree().quit()

func setMain(scene):
	Main = scene
	
func getMain():
	return Main

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
func _process(delta):
	# listen for the unpause action
	if CurrentState == STATES.paused:
		TicksPaused += 1
		print("paused at " + TicksPaused)
		if TicksPaused > 3 and Input.is_action_just_pressed("pause"):
			print("global sensed a keypress")
			resumeGame()
		


func _on_PausePanel_resume_pressed():
	resumeGame()

func _on_PausePanel_quit_pressed():
	quitGame()

func _on_PausePanel_pause_requested():
	pauseGame()
	
#func _on_pause_requested():
#	pauseGame()
	
