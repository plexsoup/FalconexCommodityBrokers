"""
This keeps a dictionary list of which keys are pressed,
which is super unnecessary because Input already does that,
and probably does it better!

"""

extends Node

# class member variables go here, for example:
signal forward_requested()
signal forward_released()
signal reverse_requested()
signal reverse_released()
signal port_requested()
signal port_released()
signal starboard_requested()
signal starboard_released()
signal strafePort_requested()
signal strafePort_released()

signal strafeStarboard_requested()
signal strafeStarboard_released()

signal shoot_weapon_1_requested()
signal shoot_weapon_1_released()
signal shoot_weapon_2_requested()
signal shoot_weapon_2_released()
signal shoot_weapon_3_requested()
signal shoot_weapon_3_released()

signal weapon_change_next_requested()
signal weapon_change_previous_requested()

signal ship_change_next_requested()
signal ship_change_previous_requested()

signal release_gem_requested()

signal next_note_sequence_requested()
signal previous_note_sequence_requested()

#maintain a list of currently pressed keys, so we can signal global.CurrentPlayerShip
	# **** hopefully this will let us provide key combinations
enum KEYS { up, down, left, right, strafeLeft, strafeRight, shoot_1, shoot_2, shoot_3, weapon_next, weapon_prev }
var KeysPressed = [false, false, false, false, false, false, false, false, false, false, false, false, false] # array of boolean values, in a specific order, one for each key in KEYS
	# **** later, we'll have to update this for touch gestures and gamepads

# we should be able to translate KeysPressed into ActionsRequested
enum ACTIONS { forward, reverse, turnLeft, turnRight, strafeLeft, strafeRight, shoot_1, shoot_2, shoot_3, shoot_all }
var ActionsRequested = [false, false, false, false, false, false, false, false, false, false, false]

# **** if strafing requires pressing left or right while shooting,
	# then we need to be able to go back to turning or shooting
	# when one of the keys is released

enum STANCES { aggressive, peaceful }
var CurrentStance = STANCES.peaceful

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _input(event):
	
	# Note about all the signal emits...
		# we can't know who wants to receive the signal, so...
		# subscribers have to connect the signals.
		# eg: look in Weapons or Engines to see where the signals get connected.
		
	# we don't use ui_up, ui_down, etc. because those were triggering the lists on the sidebar
	if event.is_action_pressed("applyThrust"):
		KeysPressed[KEYS.up] = true
		emit_signal("forward_requested")
	
	if event.is_action_released("applyThrust"):
		KeysPressed[KEYS.up] = false
		emit_signal("forward_released")
	
	if event.is_action_pressed("reverse"):
		KeysPressed[KEYS.down] = true
		emit_signal("reverse_requested")
	
	if event.is_action_released("reverse"):
		KeysPressed[KEYS.down] = false
		emit_signal("reverse_released")

	if event.is_action_pressed("turnLeft"):
		KeysPressed[KEYS.left] = true
		emit_signal("port_requested")

	if event.is_action_released("turnLeft"):
		KeysPressed[KEYS.left] = false
		emit_signal("port_released")
		
	
	if event.is_action_pressed("turnRight"):
		KeysPressed[KEYS.right] = true
		emit_signal("starboard_requested")
	
	if event.is_action_released("turnRight"):
		KeysPressed[KEYS.right] = false
		emit_signal("starboard_released")
	
	if event.is_action_pressed("strafePort"):
		KeysPressed[KEYS.strafeLeft] = true
		emit_signal("strafePort_requested")

	if event.is_action_released("strafePort"):
		KeysPressed[KEYS.strafeLeft] = false
		emit_signal("strafePort_released")

	if event.is_action_pressed("strafeStarboard"):
		KeysPressed[KEYS.strafeRight] = true
		emit_signal("strafeStarboard_requested")

	if event.is_action_released("strafeStarboard"):
		KeysPressed[KEYS.strafeRight] = false
		emit_signal("strafeStarboard_released")

	
	if event.is_action_pressed("shoot_weapon_1"):
		KeysPressed[KEYS.shoot_1] = true
		if CurrentStance == STANCES.aggressive:
			CurrentStance = STANCES.peaceful
			emit_signal("shoot_weapon_1_released")
		elif CurrentStance == STANCES.peaceful:
			CurrentStance = STANCES.aggressive
			emit_signal("shoot_weapon_1_requested")

#	if event.is_action_released("shoot_weapon_1"):
#		KeysPressed[KEYS.shoot_1] = false
#		emit_signal("shoot_weapon_1_released")

	if event.is_action_pressed("shoot_weapon_2"):
		KeysPressed[KEYS.shoot_2] = true
		emit_signal("shoot_weapon_2_requested")
	if event.is_action_released("shoot_weapon_2"):
		KeysPressed[KEYS.shoot_2] = false
		emit_signal("shoot_weapon_2_released")

	if event.is_action_pressed("shoot_weapon_3"):
		KeysPressed[KEYS.shoot_3] = true
		emit_signal("shoot_weapon_3_requested")
	if event.is_action_released("shoot_weapon_3"):
		KeysPressed[KEYS.shoot_3] = false
		emit_signal("shoot_weapon_3_released")

#	if event.is_action_pressed("ship_next"):
#		emit_signal("ship_change_next_requested")
#		CurrentStance = STANCES.peaceful
#
#	if event.is_action_pressed("ship_previous"):
#		emit_signal("ship_change_previous_requested")
#		CurrentStance = STANCES.peaceful

#	if event.is_action_pressed("release_gem"):
#		emit_signal("release_gem_requested")
#
#	if event.is_action_pressed("next_music_sequence"):
#		emit_signal("next_note_sequence_requested")
#
#	if event.is_action_pressed("previous_music_sequence"):
#		emit_signal("previous_note_sequence_requested")
#		print(self.name , " emitting signal: previous_note_sequence_requested")
		

func getActions():
	return ActionsRequested
	
func releaseAllActions():
	# when the pilot dies, send a bunch of ..._released requests to the ship
	emit_signal("reverse_released")
	emit_signal("forward_released")
	emit_signal("starboard_released")
	emit_signal("port_released")
	emit_signal("shoot_weapon_1_released")
	emit_signal("shoot_weapon_2_released")
	emit_signal("shoot_weapon_3_released")
	