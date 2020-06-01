extends PanelContainer

# Declare member variables here. Examples:
onready var global = get_node("/root/global")

enum STATES { initializing, ready }
var CurrentState = STATES.initializing

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	add_to_group("GUI")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Level_started():
	CurrentState = STATES.ready
	show()
	
