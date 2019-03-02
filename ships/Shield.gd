extends Sprite

# Declare member variables here. Examples:
onready var MyShip = get_node("..")
onready var global = get_node("/root/global")

var BaseScale : Vector2 = Vector2(0.1, 0.1)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func upgradeShields(level):
	#var level = MyShip.UpgradesDict["shields"]

	if level == 1:
#		set_visible(true)
#		set_self_modulate(Color("4070da59"))
		BaseScale = Vector2(0.25, 0.25)
	elif level == 2:
#		set_visible(true)
#		set_self_modulate(Color("4070da59"))
		BaseScale = Vector2(0.4, 0.4)

	$ShieldTimer.start()
	show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func tweenColor(color1, color2):
	var tween = get_node("Tween")
	tween.interpolate_property(self, "self_modulate",
		color1 , color2, 0.4,
		Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")

	

func _on_ShieldTimer_timeout():
	var color1 = Color("2070da59")
	var color2 = Color("9f70da59")
#	tweenColor(color1, color2)
#	tweenColor(color2, color1)
	
	$ShieldTimer.start()
