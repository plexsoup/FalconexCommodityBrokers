extends Sprite

# Declare member variables here. Examples:
onready var global = get_node("/root/global")
var Showing : bool = false
onready var CurrentCamera = get_node("../Camera2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	hide() # Replace with function body.


func showRadarSprite():
	show()
	var tween = get_node("Tween")
	tween.interpolate_property(self, "self_modulate",
			Color(1,1,1,0), Color(1,1,1,1), 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func hideRadarSprite():
	var tween = get_node("Tween")
	tween.interpolate_property(self, "self_modulate",
			Color(1,1,1,1), Color(1,1,1,0), 1,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Showing == false and CurrentCamera.zoom.x > 10:
		showRadarSprite()
		Showing = true
	elif Showing == true and CurrentCamera.zoom.x < 9:
		hideRadarSprite()
		Showing = false
