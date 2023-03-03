extends Node

# Declare member variables here. Examples:
onready var global = get_node("/root/global")
var CurrentPlayer

signal left_pressed
signal right_pressed
signal up_pressed
signal down_pressed

signal left_released
signal right_released
signal up_released
signal down_released


# Called when the node enters the scene tree for the first time.
func _ready():
	#yield(get_tree().create_timer(.5), "timeout" ) # wait for the player to declare itself
	pass

#func connectSignals(player):
#	connect("left_pressed", player, "_on_left_pressed")
#	connect("right_pressed", player, "_on_right_pressed")
#	connect("up_pressed", player, "_on_up_pressed")
#	connect("down_pressed", player, "_on_down_pressed")
#	connect("left_released", player, "_on_left_released")
#	connect("right_released", player, "_on_right_released")
#	connect("up_released", player, "_on_up_released")
#	connect("down_released", player, "_on_down_released")

func subscribe(keyStr, nodeRequesting):
	connect(keyStr+"_pressed", nodeRequesting, "_on_thrust_requested")
	connect(keyStr+"_released", nodeRequesting, "_on_thrust_released")

func _process(delta):

	if Input.is_action_just_pressed("turnLeft"):
		emit_signal("left_pressed")
	if Input.is_action_just_pressed("turnRight"):
		emit_signal("right_pressed")
	if Input.is_action_just_pressed("applyThrust"):
		emit_signal("up_pressed")
	if Input.is_action_just_pressed("brake"):
		emit_signal("down_pressed")

	if Input.is_action_just_released("turnLeft"):
		emit_signal("left_released")
	if Input.is_action_just_released("turnRight"):
		emit_signal("right_released")
	if Input.is_action_just_released("applyThrust"):
		emit_signal("up_released")
	if Input.is_action_just_released("brake"):
		emit_signal("down_released")
		
		
		
		
