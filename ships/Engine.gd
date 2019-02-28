extends Node2D

onready var global = get_node("/root/global")
export var SubscribedKeys = ["up"]
export var Player = "player1"
var Controller

var ParentShip
var Thrust : float = 0.0
export var MaxThrust : float = 20.0
export var ThrustIncrement : float = 2.0
var ThrustRequested : bool = false
var CurrentForce = 0

var BaseRot

var Ticks :int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if Player == "player1":
		Controller = global.getPlayerController()
		
		for key in SubscribedKeys:
			Controller.subscribe(key, self)
		
	else:
		Controller = null # change this to whatever the AI will be.

	ParentShip = $"../.."
	if ParentShip is RigidBody2D:
		pass
	else:
		print("Error ==>", self.name , ".ParentShip is not RigidBody2D" )

	BaseRot = get_rotation()

func _physics_process(delta):
	Ticks += 1	
	
	if ThrustRequested:
		$Sprite.show()
		var thrustPercent = Thrust/MaxThrust
		var flickerScale = randf()/5 - 0.1
		var flickerRot = randf()/10 - 0.05
		#set_global_scale(Vector2(CurrentForce * MaxThrust/400 + flickerScale, 1))
		#set_rotation( BaseRot + flickerRot )

		if CurrentForce < MaxThrust:
			ParentShip.add_force(get_global_position(), Vector2(ThrustIncrement * delta, 0).rotated(rotation))
			CurrentForce += ThrustIncrement * delta

	else:
		$Sprite.hide()
		Thrust = 0


func _on_thrust_requested():
	ThrustRequested = true
	
func _on_thrust_released():
	ThrustRequested = false
	