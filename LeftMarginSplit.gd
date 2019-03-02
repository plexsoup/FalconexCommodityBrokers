extends HSplitContainer

var PreviousOffset : float
var DesiredOffset : float
var OpenOffset : float = 145.0
var ClosedOffset : float = 0.0
var InitialOffset : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	#clamp_split_offset()
	set_split_offset(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func slidePanel():
	var tween = get_node("Tween")
	
	tween.interpolate_property(self, "split_offset",
	        PreviousOffset, DesiredOffset, 0.33,
	        Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	$SlideNoise.play()

func openPanel():
	$PanelContainer/ButtonMover/MarginContainer/UpgradeButtons.show()
	PreviousOffset = get_split_offset()
	DesiredOffset = OpenOffset
	slidePanel()
	
func closePanel():
	PreviousOffset = get_split_offset()
	DesiredOffset = ClosedOffset
	slidePanel()
	var tween = get_node("Tween")
	yield(tween, "tween_completed")
	$PanelContainer/ButtonMover/MarginContainer/UpgradeButtons.hide()


func _on_LeftButton_toggled(button_pressed):
	if button_pressed == true:
		openPanel()
	else:
		closePanel()