extends VSplitContainer


var PreviousOffset : float
var DesiredOffset : float
export var OpenOffset : float = 145.0
export var ClosedOffset : float = 0.0
export var InitialOffset : float = 0.0

export var TweenNodePath = "/Tween"
export var SlideNoisePath = "/SlideNoise"
var TweenNode
var SlideNoise

onready var global = get_node("/root/global")
var Panels

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.1), "timeout") # wait for main to register itself with global
	#clamp_split_offset()
	set_split_offset(0)
	Panels = global.getMain().find_node("Panels")
	
	TweenNode = Panels.get_node("Tween")
	SlideNoise = Panels.get_node("SlideNoise")
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func slidePanel():
	TweenNode.interpolate_property(self, "split_offset",
			PreviousOffset, DesiredOffset, 0.33,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenNode.start()
	SlideNoise.play()

func openPanel():
	#$LeftPanel/Upgrades.show()
	PreviousOffset = get_split_offset()
	DesiredOffset = OpenOffset
	slidePanel()

func closePanel():
	PreviousOffset = get_split_offset()
	DesiredOffset = ClosedOffset
	slidePanel()
	yield(TweenNode, "tween_completed")
	#$LeftPanel/Upgrades.hide()


func _on_PanelButton_toggled(button_pressed):
	if button_pressed == true:
		openPanel()
	else:
		closePanel()


