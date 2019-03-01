extends PanelContainer

# Declare member variables here. Examples:
onready var global = get_node("/root/global")

enum STATES { initializing, ready }
var CurrentState = STATES.initializing

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("GUI")
	hide()

func toggleVisible():
	if visible == true:
		hide()
	else:
		show()
	
func flashMessage():
	#print(self.name, " flashing warning label " )
	for i in range(5):
		toggleVisible()
		yield(get_tree().create_timer(.5), "timeout")

	hide()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


