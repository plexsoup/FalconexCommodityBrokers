extends HSlider

# Declare member variables here. Examples:
export var Bus : int = 0
onready var global = get_node("/root/global")
enum Buses { Master, Music, SoundFX, Voiceover}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	connect("value_changed", self, "_on_AudioLevels_value_changed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func slider2db(value):
	return lerp(-48, 36, value/100)

func _on_AudioLevels_value_changed(value):
	AudioServer.set_bus_volume_db(Bus, slider2db(value))
	


