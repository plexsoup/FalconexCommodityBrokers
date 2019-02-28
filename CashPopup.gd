extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func getRandOffset(distance):
	var offset = Vector2(0,0)
	offset.x += randf()*distance - randf()*distance
	offset.y -= randf()*distance + distance/2
	return offset

func start(pos, amount):
	set_global_position(pos)
	$Label.set_text("$"+str(amount))
	#$AnimationPlayer.play()

	var tween = get_node("Tween")
	tween.interpolate_method(self, "set_global_position",
			pos, pos+getRandOffset(100), 0.5,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_method( self, "set_scale", 
			Vector2(0,0), Vector2(3, 3), 0.5,
			Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.interpolate_method(self, "set_modulate",
			Color("00e4e114"), Color("e4e114"), 0.25,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
	tween.start()
	
	$DestructionTimer.start()
	

func dieSlowly():
	var tween = get_node("Tween")
	tween.interpolate_method( self, "set_scale", 
			Vector2(3,3), Vector2(0, 0), 0.5,
			Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.interpolate_method(self, "set_modulate",
			Color("e4e114"), Color("00e4e114") , 0.5,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(get_tree().create_timer(0.5), "timeout")
	call_deferred("queue_free")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_global_rotation(0)

func _on_DestructionTimer_timeout():
	dieSlowly()
