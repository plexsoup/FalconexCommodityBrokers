extends Button

# Declare member variables here. Examples:
export var HoverText : String = ""
export var NormalText : String = "="
var OriginalPos
var OriginalSize

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	set_text(NormalText)
	OriginalPos = get_position()
	OriginalSize = get_size()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_mouse_entered():
	set_text(HoverText)
	
func _on_mouse_exited():
	set_text(NormalText)
	set_size(OriginalSize)
#	set_position(OriginalPos)
	