extends HSplitContainer

var PreviousOffset : float
var DesiredOffset : float
export var OpenOffset : float = 145.0
export var ClosedOffset : float = 0.0
export var InitialOffset : float = 0.0

export var TweenNodePath = "/Tween"
export var SlideNoisePath = "/SlideNoise"
var TweenNode
var SlideNoise


# Called when the node enters the scene tree for the first time.
func _ready():
	#clamp_split_offset()
	set_split_offset(0)
	TweenNode = get_node(TweenNodePath)
	SlideNoise = get_node(SlideNoisePath)

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


