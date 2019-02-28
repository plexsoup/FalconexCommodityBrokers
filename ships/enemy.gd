"""
enemy will spawn offscreen,
fly toward the player in a sin pattern
fire lasers

"""


extends Area2D

# Declare member variables here. Examples:
var Ticks : int = 0
onready var global = get_node("/root/global")
var CurrentPlayerShip
var CurrentLevel
var Velocity : Vector2
var Speed = 700
var DodgeMagnitude = 500
var MaxHealth : int = 300
var Health : int = MaxHealth

var Dead : bool = false

enum STATES { normal, shielded, exploding, dead }
var CurrentState = STATES.normal

# Called when the node enters the scene tree for the first time.
func _ready():
	Health = MaxHealth

func start(pos):
	set_global_position(pos)
	CurrentPlayerShip = global.getPlayerShip()
	CurrentLevel = global.getCurrentLevel()

func getVectorTowardPlayer(delta):
	var returnVector = Vector2(0,0)
	var myPos = get_global_position()
	var playerPos = CurrentPlayerShip.get_global_position()
	var avoidanceDistance = 800
	if myPos.distance_squared_to(playerPos) > avoidanceDistance * avoidanceDistance:
		returnVector += (playerPos - myPos).normalized() * Speed * delta * global.GameSpeed
	else:
		returnVector -= (playerPos - myPos).normalized() * Speed * delta * global.GameSpeed
	return returnVector
	
func getVectorSideToSideDodging(delta):
	
	return Vector2(1, 0).rotated(rotation-(PI/2)) * sin(Ticks/20) * DodgeMagnitude * delta

func lookTowardPlayer(delta):
	# turn left or right depending on dot product?
	
	var myVector = Vector2(1,0).rotated(rotation)
	var vecToPlayer = CurrentPlayerShip.get_global_position() - get_global_position()
	
	var mySideVec = myVector.rotated(PI/2)
	var turnSpeed = 0.02
	if mySideVec.dot(vecToPlayer) < 0 :
		rotation -= turnSpeed
	else:
		rotation += turnSpeed
	
func getVectorToAvoidAllies(delta):
	var returnVector = Vector2(0,0)
	var myPos = get_global_position()
	var rangeToAvoid = 500
	for ship in get_tree().get_nodes_in_group("enemies"):
		var shipPos = ship.get_global_position()
		if myPos.distance_squared_to(shipPos) < rangeToAvoid * rangeToAvoid:
			returnVector += (myPos - shipPos).normalized() * Speed * delta
#	if Ticks % 60 == 0:
#		print(self.name, "getVectorToAvoidAllies returning: " , returnVector)
#		print(get_tree().get_nodes_in_group("enemies").size())
	return returnVector

func goAfterShip():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Dead == false:
		Ticks += 1
		
		lookTowardPlayer(delta)
		
		Velocity = getVectorTowardPlayer(delta)
		Velocity += getVectorSideToSideDodging(delta)
		Velocity += getVectorToAvoidAllies(delta)
		set_global_position(get_global_position() + Velocity)

func lightUpShield():
#	if $AnimationPlayer.is_playing():
#		$AnimationPlayer.seek(0.0)
#		$AnimationPlayer.stop()
	CurrentState = STATES.shielded
	$AnimationPlayer.play("shield")
	$Shield/ShieldTimer.start()
#	$CollisionShape2D.call_deferred("set_disabled", true)
	
func lightUpExplosion():
#	if $AnimationPlayer.is_playing():
#		$AnimationPlayer.seek(0)
#		$AnimationPlayer.stop()
	CurrentState = STATES.exploding
	$AnimationPlayer.play("explosion")
	$Explosion/DestructionTimer.start()

func dieSlowly():
	#$CollisionShape2D.set_disabled(true)
	CurrentState = STATES.dead
	$Sprite.hide()
	$Shield.hide()
	$weapons.hide()
	lightUpExplosion()

		
func takeDamage(damage):
	if CurrentState == STATES.normal:
		Health -= damage
		if Health <= 0:
			dieSlowly()
		else:
			lightUpShield()
		
	
func _on_hit(damage):
	#print(self.name, " received hit for ", damage, " damage. Health == ", Health )
	if CurrentState == STATES.normal:
		takeDamage(damage)

#func _on_AnimationPlayer_animation_finished(anim_name):
#	#print(self.name, " finished animation: ", anim_name )
#	if anim_name == "shield":
#		$CollisionShape2D.call_deferred("set_disabled", false)
#
#	if anim_name == "explosion":
#		call_deferred("queue_free")


func _on_DestructionTimer_timeout():
	call_deferred("queue_free")


func _on_ShieldTimer_timeout():
	CurrentState = STATES.normal

func _on_ship_filled_inventory():
	goAfterShip()
