extends HSplitContainer

# Declare member variables here. Examples:
var IsOpen : bool = false
var InitialOffset : float
var PreviousOffset : float
var DesiredOffset : float
var OpenOffset : float
var ClosedOffset : float

# Called when the node enters the scene tree for the first time.
func _ready():
	var screensize = get_viewport().get_visible_rect().size
	InitialOffset = get_split_offset()

	ClosedOffset = InitialOffset
	OpenOffset = InitialOffset - 300

	PreviousOffset = InitialOffset
	DesiredOffset = InitialOffset
	IsOpen = false

func _process(delta):
	pass	

func slidePanel():
	var tween = get_node("Tween")
	
	tween.interpolate_property(self, "split_offset",
	        PreviousOffset, DesiredOffset, 0.33,
	        Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	$SlideNoise.play()

func openPanel():
	PreviousOffset = ClosedOffset
	DesiredOffset = OpenOffset
	slidePanel()

	#set_split_offset(InitialOffset - 300)
	
func closePanel():
	PreviousOffset = OpenOffset
	DesiredOffset = ClosedOffset
	slidePanel()
	#set_split_offset(InitialOffset)


func _on_Button_toggled(button_pressed):
	#print(self.name, " button toggled")
	if button_pressed == true:
		openPanel()
	else:
		closePanel()
