extends Node2D

# class member variables go here, for example:
var ShipRigidBodyNode
var PilotNode
var CurrentThrust = 0.0

var LocalTransform
var EngineOffset = Vector2(0.0, 0.0)
var EngineRotation = 0.0
var ParentRotation
var ThrustSpriteDefaultScale
var InitialParticleAmount

var THRUST_REQUESTED = false

# Note Carefully: Godot 3.1 doesn't export Arrays correctly.
	# each instance of a scene will share the same array values.
	# Therefore, we'll export three strings, then turn them into an array
var SubscribedKeys = [] 

export (String) var SubscribedKeyOne
export (String) var SubscribedKeyTwo
export (String) var SubscribedKeyThree

export (float) var ThrustFactor = 10.0
export (float) var MaxThrust = 50.0
#export (String) var SubscribedKey = "forward" # forward, reverse, port, starboard
export (float) var ThrustSizeAndVolume = 1.0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Don't use this. use start instead. call it explicitly when you spawn ships
	ThrustSpriteDefaultScale = $ThrustSprite.get_scale()

func buildSubscribedKeysArray():
	if SubscribedKeyOne != null and SubscribedKeyOne != "":
		SubscribedKeys.push_back(SubscribedKeyOne)
	if SubscribedKeyTwo != null and SubscribedKeyTwo != "":
		SubscribedKeys.push_back(SubscribedKeyTwo)
	if SubscribedKeyThree != null and SubscribedKeyThree != "":
		SubscribedKeys.push_back(SubscribedKeyThree)

func start(pilotNode):
	PilotNode = pilotNode
	
	ShipRigidBodyNode = get_parent().get_parent()
	ShipRigidBodyNode.set_linear_damp(0.05)
	
	CurrentThrust = 0.0
	
	LocalTransform = get_relative_transform_to_parent(ShipRigidBodyNode)
	EngineOffset = LocalTransform.get_origin()
	EngineRotation = LocalTransform.get_rotation()
	
#	if self.has_node("Particles2D"):
#		InitialParticleAmount = $Particles2D.get_amount()
	
	buildSubscribedKeysArray()
	
	for key in SubscribedKeys:
		pilotNode.connect(key+"_requested", self, "_on_"+key+"_requested")
		pilotNode.connect(key+"_released", self, "_on_"+key+"_released")

	
	
func _physics_process(delta):
	var fudgeFactor = 25.0
#	# Called every frame. Delta is time since last frame.
	if THRUST_REQUESTED == true:
		var thrustVector = Vector2(ThrustFactor * fudgeFactor * delta * global.GameSpeed, 0)
		#var thrustVector = Vector2(ThrustFactor, 0)
		
		var shipRotation = ShipRigidBodyNode.get_rotation()
		ShipRigidBodyNode.apply_impulse(EngineOffset.rotated(shipRotation), thrustVector.rotated(EngineRotation).rotated(shipRotation))

		CurrentThrust += ThrustFactor * fudgeFactor * delta * global.GameSpeed
		CurrentThrust = clamp(CurrentThrust, 0, MaxThrust)

	if self.has_node("ThrustSprite"):
		$ThrustSprite.set_scale(ThrustSpriteDefaultScale * (CurrentThrust/MaxThrust) * ThrustSizeAndVolume)
	if self.has_node("AudioStreamPlayer2D"):
		$AudioStreamPlayer2D.set_volume_db(12.0 * (CurrentThrust/MaxThrust) * ThrustSizeAndVolume - 24)
#	if self.has_node("Particles2D"):
#		$Particles2D.set_amount(InitialParticleAmount)

"""
moved to PlayerInputController.gd
"""
# This works for player ships, not AI ships.
# **** This belongs in a player input controller, which would pass signals
		# to the engines
#func _process(delta):
#	if Input.is_action_just_pressed("applyThrust"):
##		print(self.name, " forward_requested")
##		print(self.name, " SubscribedKeys == ", SubscribedKeys)
#		_on_forward_requested()
#	elif Input.is_action_just_released("applyThrust"):
#		_on_forward_released()
#
#	if Input.is_action_just_pressed("reverse"):
#		_on_reverse_requested()
#	elif Input.is_action_just_released("reverse"):
#		_on_reverse_released()
#
#	if Input.is_action_just_pressed("turnLeft"):
#		_on_port_requested()
#	elif Input.is_action_just_released("turnLeft"):
#		_on_port_released()
#
#	if Input.is_action_just_pressed("turnRight"):
#		_on_starboard_requested()
#	elif Input.is_action_just_released("turnRight"):
#		_on_starboard_released()
#
#	if Input.is_action_just_pressed("strafePort"):
#		_on_strafePort_requested()
#	elif Input.is_action_just_released("strafePort"):
#		_on_strafePort_released()
#
#	if Input.is_action_just_pressed("strafeStarboard"):
#		_on_strafeStarboard_requested()
#	elif Input.is_action_just_released("strafeStarboard"):
#		_on_strafeStarboard_released()
	
	
	
		
func getSubscribedKeys():
	return SubscribedKeys

func applyThrust():
	CurrentThrust += ThrustFactor
	if self.has_node("AudioStreamPlayer2D"):
		$AudioStreamPlayer2D.play()
#	if self.has_node("Particles2D"):
#		$Particles2D.set_emitting(true)
	THRUST_REQUESTED = true

func releaseThrust():
	THRUST_REQUESTED = false
	if self.has_node("AudioStreamPlayer2D"):
		$AudioStreamPlayer2D.stop()
#	if self.has_node("Particles2D"):
#		$Particles2D.set_emitting(false)
	CurrentThrust = 0.0

func _on_engine_upgrade_requested(level):
	
	ThrustFactor *= 1.5
	MaxThrust *= 1.5
	ThrustSizeAndVolume *= 1.5
	# **** TODO change out the sprite or the color or something
	if level == 1:
		$ThrustSprite.set_self_modulate(Color.lightgreen)
	elif level == 2:
		$ThrustSprite.set_self_modulate(Color.aquamarine)

func _on_forward_requested():
	if SubscribedKeys.has("forward"):
		applyThrust()
	
func _on_forward_released():
	if SubscribedKeys.has("forward"):
		releaseThrust()

func _on_reverse_requested():
	if SubscribedKeys.has("reverse"):
		applyThrust()
	
func _on_reverse_released():
	if SubscribedKeys.has("reverse"):
		releaseThrust()
	
func _on_port_requested():
	if SubscribedKeys.has("port"):
		applyThrust()

func _on_port_released():
	if SubscribedKeys.has("port"):
		releaseThrust()
	
func _on_starboard_requested():
	if SubscribedKeys.has("starboard"):
		applyThrust()

func _on_starboard_released():
	if SubscribedKeys.has("starboard"):
		releaseThrust()

func _on_strafePort_requested():
	if SubscribedKeys.has("strafePort"):
		applyThrust()

func _on_strafePort_released():
	if SubscribedKeys.has("strafePort"):
		releaseThrust()
		
func _on_strafeStarboard_requested():
	if SubscribedKeys.has("strafeStarboard"):
		applyThrust()

func _on_strafeStarboard_released():
	if SubscribedKeys.has("strafeStarboard"):
		releaseThrust()
