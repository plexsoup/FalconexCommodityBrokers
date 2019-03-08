extends Control

# Declare member variables here. Examples:
var PanelButtons
onready var LeftSlider = get_node("LeftSplitContainer")
onready var TopSlider = find_node("TopSplitContainer")
onready var RightSlider = find_node("RightSplitContainer")
onready var BottomSlider = find_node("BottomSplitContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	PanelButtons = find_node("MainView").get_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_open_panel_requested(panel : String):
	print(self.name, " received signal: _on_open_panel_requested(", panel, ")")
	match panel:
		"left":
			PanelButtons[0].pressed = true
			LeftSlider._on_PanelButton_toggled(true)
			# does this send a signal?
		"right":
			PanelButtons[1].pressed = true
			RightSlider._on_PanelButton_toggled(true)
		"top":
			PanelButtons[2].pressed = true
			TopSlider._on_PanelButton_toggled(true)
		"bottom":
			PanelButtons[3].pressed = true
			BottomSlider._on_PanelButton_toggled(true)

func _on_close_panel_requested(panel : String):
	match panel:
		"left":
			PanelButtons[0].pressed = false
			LeftSlider._on_PanelButton_toggled(false)
			# does this send a signal?
		"right":
			PanelButtons[1].pressed = false
			RightSlider._on_PanelButton_toggled(false)
		"top":
			PanelButtons[2].pressed = false
			TopSlider._on_PanelButton_toggled(false)
		"bottom":
			PanelButtons[3].pressed = false
			BottomSlider._on_PanelButton_toggled(false)
