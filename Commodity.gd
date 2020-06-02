extends Area2D

# Declare member variables here. Examples:
var Types = [ "wheat", "cog", "diamond" ]
var MySprite
var MyColor : Color
var MyType
var FollowTarget : RigidBody2D = null
enum STATES { spawning, ready }
var CurrentState = STATES.spawning
var dirVector : Vector2
var Available : bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start(commodityType : String, startPos, endPos):
	dirVector = (endPos - startPos).normalized()
	MyType = commodityType
	match commodityType:
		"wheat":
			MySprite = load("res://icons/wheat white.png")
			MyColor = Color.green
		"cog":
			MySprite = load("res://icons/cog white.png")
			MyColor =  Color.maroon
		"diamond":
			MySprite = load("res://icons/cut-diamond white.png")
			MyColor =  Color.white
	$Sprite.set_texture(MySprite)
	$Sprite.set_self_modulate(MyColor)
	#$WobbleTimer.set_wait_time(1.0 + randf()*2.0)
	$WobbleTimer.start(1.0 + randf()*2.0)
	
	var tween = get_node("Tween")
	tween.interpolate_property(self, "position",
			startPos, endPos, 0.66,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	CurrentState = STATES.ready
	
	# **** TODO: check for large magnet. ask the ship.
		# fly toward ship immediately
	
		
#	var areas = get_overlapping_areas()
#	for area in areas:
#		if area.name == "Magnet":
#			var ship = area.get_node("..")
#			if ship.has_method("isCargoHoldFull") and ship.isCargoHoldFull() == false:
#				FollowTarget = ship
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): # getting sucked into magnet
	if CurrentState != STATES.ready:
		return

	if FollowTarget == null:
		var driftSpeed = 100.0
		set_global_position(get_global_position() + (dirVector*delta * driftSpeed))

		var areas = get_overlapping_areas()
		for area in areas:
			if area.name == "Magnet":
				var ship = area.get_node("..")
				if ship.has_method("isCargoHoldFull") and ship.isCargoHoldFull() == false:
					FollowTarget = ship
	else: # currently getting sucked into a magnet
		var myPos = get_global_position()
		var shipPos = FollowTarget.get_global_position() 

		var minProximitySq = 64.0
		if (shipPos - myPos).length_squared() < minProximitySq:
			getPickedUp(FollowTarget)
		else:
			set_global_position(lerp(myPos, shipPos, 0.5 ))


func getPickedUp(pickerUpper):
	# Note: this is calling a foreign method directly.
			# better if it was a signal.
	
	if Available == true and pickerUpper.has_method("pickup_commodity"):
		if pickerUpper.has_method("isCargoHoldFull"):
			if pickerUpper.isCargoHoldFull():
				FollowTarget = null # no room to get picked up, just drift away
			else: # ship has room for more cargo
				pickerUpper.pickup_commodity(self, MyType)
				Available = false
				FollowTarget = null

func _on_ship_picked_up_commodity():
	# have to wait for ship to confirm it can hold you
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
			var ship = area.get_node("..")
			if ship.isCargoHoldFull() == false:
				FollowTarget = ship
		
func _on_Commodity_body_entered(body):
	# sometimes this fails to trigger. Needs a proximity check as well.
	if CurrentState == STATES.ready:
		var CurrentPlayer = global.getPlayerShip()
		if body == CurrentPlayer:
			# get collected
			getPickedUp(body)


func _on_DurationTimer_timeout():
	$DestructionTimer.start()


func _on_WobbleTimer_timeout():
	if CurrentState == STATES.ready:
		var tween = get_node("Tween")
		tween.interpolate_property($Sprite, "scale",
			Vector2(0.5,0.5), Vector2(1.5,1.5), 0.5,
			Tween.TRANS_ELASTIC, Tween.EASE_IN)
		tween.start()
		yield(tween, "tween_completed")
		tween.interpolate_property($Sprite, "scale",
			Vector2(1.5,1.5), Vector2(0.5,0.5), 0.5,
			Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		tween.start()
		yield(tween, "tween_completed")	
		
		#$AnimationPlayer.play("wobble")

		$WobbleTimer.set_wait_time(1.0 + randf()*2.0)
		$WobbleTimer.start()
		
