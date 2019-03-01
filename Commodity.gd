extends Area2D

# Declare member variables here. Examples:
var Types = [ "wheat", "cog", "diamond" ]
var MySprite
var MyType
var FollowTarget : RigidBody2D = null
enum STATES { spawning, ready }
var CurrentState = STATES.spawning


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start(commodityType : String, startPos, endPos):
	MyType = commodityType
	match commodityType:
		"wheat":
			MySprite = load("res://icons/wheat.png")
		"cog":
			MySprite = load("res://icons/cog.png")
		"diamond":
			MySprite = load("res://icons/cut-diamond.png")
	$Sprite.set_texture(MySprite)
	
	var tween = get_node("Tween")
	tween.interpolate_property(self, "position",
			startPos, endPos, 0.5,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	CurrentState = STATES.ready
	
	# **** TODO: check for large magnet. ask the ship.
		# fly toward ship immediately
	var areas = get_overlapping_areas()
	for area in areas:
		if area.name == "Magnet":
			FollowTarget = area.get_node("..")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if FollowTarget != null:
		set_global_position(lerp(get_global_position(), FollowTarget.get_global_position(), 0.5 ))



func getPickedUp(pickerUpper):
	# Note: this is calling a foreign method directly.
			# better if it was a signal.
	if pickerUpper.has_method("pickup_commodity"):
		if pickerUpper.has_method("isCargoHoldFull"):
			if pickerUpper.isCargoHoldFull():
				FollowTarget = null
				
			else:
				pickerUpper.pickup_commodity(self, MyType)

func _on_ship_picked_up_commodity():
		$Sprite.hide()
		$CollisionShape2D.call_deferred("set_disabled", true)
		$AudioStreamPlayer2D.play()
		$DestructionTimer.start()


func _on_DestructionTimer_timeout():
	call_deferred("queue_free")


func _on_AudioStreamPlayer2D_finished():
	call_deferred("queue_free")


func _on_Commodity_area_entered(area):
	if CurrentState == STATES.ready:
		if area.name == "Magnet":
			FollowTarget = area.get_node("..")
		
func _on_Commodity_body_entered(body):
	if CurrentState == STATES.ready:
		var CurrentPlayer = global.getPlayerShip()
		if body == CurrentPlayer:
			# get collected
			getPickedUp(body)
