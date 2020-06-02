"""
enemy will spawn offscreen,
fly toward the player in a sin pattern
fire lasers

"""


extends Area2D

# Declare member variables here. Examples:
var Ticks : int = 0
var TimeElapsed : float = 0

onready var global = get_node("/root/global")

export var Speed = 700.0
export var TurnSpeed = 10.0
export var DodgeMagnitude = 250.0
export var MaxHealth : int = 100
export var MaxShields : int = 0
export var ProximitySensorRange : int = 5000
export var LikelihoodOfPursuingPlayer = 0.033

var CurrentPlayerShip
var CurrentLevel
var Velocity : Vector2
var Health : int = MaxHealth
var ShieldRemaining : int = MaxShields
var SquadID : int = 0
var Dead : bool = false

enum STATES { normal, shielded, exploding, dead }
var CurrentState = STATES.normal

enum GOALS { player, planet, commodities, follow_squad }
var CurrentGoal = GOALS.planet


var CurrentTarget

# Called when the node enters the scene tree for the first time.
func _ready():
	Health = MaxHealth

func start(pos, squadID):
	set_global_position(pos)
	CurrentPlayerShip = global.getPlayerShip()
	CurrentLevel = global.getCurrentLevel()
	getNewBehaviour()
	SquadID = squadID
		
func getVectorTowardTarget(delta):
	if is_instance_valid(CurrentTarget) == false:
		print("Debug: CurrentTarget isn't valid " + str(CurrentTarget))
		return Vector2(0,0)
	var returnVector = Vector2(0,0)
	var myPos = get_global_position()
	var targetPos = CurrentTarget.get_global_position()
	var avoidanceDistance = 500
	if myPos.distance_squared_to(targetPos) > avoidanceDistance * avoidanceDistance:
		returnVector += (targetPos - myPos).normalized() * Speed * delta * global.GameSpeed
	else:
		returnVector -= (targetPos - myPos).normalized() * Speed * delta * global.GameSpeed
	return returnVector
	
func getVectorSideToSideDodging(delta):
	
	return Vector2(1, 0).rotated(rotation-(PI/2)) * sin(Ticks/20) * DodgeMagnitude * delta

func lookTowardTarget(delta):
	# turn left or right depending on dot product?
	
	var myVector = Vector2(1,0).rotated(rotation)
	var vecToTarget = Vector2(0,0)
	if is_instance_valid(CurrentTarget):
		vecToTarget = CurrentTarget.get_global_position() - get_global_position()
	else:
		print("Debug: can't locate current target: " + str(CurrentTarget) )
		
	var mySideVec = myVector.rotated(PI/2)
	var angleToTarget = myVector.angle_to(vecToTarget) # radians
	var finesse : float = abs(angleToTarget / PI)
	if mySideVec.dot(vecToTarget) < 0 :
		rotation -= lerp(0, TurnSpeed, finesse) * delta
	else:
		rotation += lerp(0, TurnSpeed, finesse) * delta
	
func getVectorToAvoidAllies(delta):
	var returnVector = Vector2(0,0)
	var myPos = get_global_position()
	var rangeToAvoid = 350
	for ship in get_tree().get_nodes_in_group("enemies"):
		var shipPos = ship.get_global_position()
		if myPos.distance_squared_to(shipPos) < rangeToAvoid * rangeToAvoid:
			returnVector += (myPos - shipPos).normalized() * Speed * delta
#	if Ticks % 60 == 0:
#		print(self.name, "getVectorToAvoidAllies returning: " , returnVector)
#		print(get_tree().get_nodes_in_group("enemies").size())
	return returnVector

func getPlayerInventoryCount():
	return global.getPlayerShip().getInventoryItemCount()

func goAfterPlayerShip():
	CurrentGoal = GOALS.player
	CurrentTarget = global.getPlayerShip()
	setLabel("Attacking Player")
# Called every frame. 'delta' is the elapsed time since the previous frame.

func getSquadID():
	return SquadID

func getSquadLeader():
	var squad = getSquad()
	if squad.size() > 0:
		return squad[0]
	else: # you're the only one left in your squad. attack the player
		goAfterPlayerShip()
		return global.getPlayerShip()

func getSquad():
	var squad = []
	for ship in get_tree().get_nodes_in_group("enemies"):
		if ship != self and ship != CurrentPlayerShip:
			if ship.getSquadID() == self.getSquadID():
				squad.push_back(ship)
	return squad

	
func followSquad():
	if getSquad().size() > 0:
		CurrentGoal = GOALS.follow_squad
		CurrentTarget = getSquadLeader()
		if not is_instance_valid(CurrentTarget): #leader is dead
			goAfterPlayerShip()
		else:
			setLabel("Formation")
	else:
		goAfterPlayerShip()
		

func getDistanceSqTo(target):
	return self.get_global_position().distance_squared_to(target.get_global_position())

func goToPlanet():
	if CurrentGoal == GOALS.planet:
		if is_instance_valid(CurrentTarget) and CurrentTarget.has_method("isPlanet") and CurrentTarget.isPlanet() == true:
			
			if hasReachedTarget():
				CurrentTarget = global.getGalaxy().getRandomPlanet()
			else:
				pass # nothing to be done, you're already heading to the desired planet
		else: # you have the right goal, just need a target
			CurrentTarget = global.getGalaxy().getRandomPlanet()
	else:
		CurrentGoal = GOALS.planet
		CurrentTarget = global.getGalaxy().getRandomPlanet()
	setLabel("Travelling to " + CurrentTarget.name)

func getNewBehaviour():
	# if you're following the player and they have cargo, keep doing that.
	# if you're following your squad, keep doing that.
	# otherwise, choose whether to go to a planet or follow the player
	
	var numCargo = getPlayerInventoryCount()

	if CurrentGoal == GOALS.player:
		if getPlayerInventoryCount() > 0:
			CurrentTarget = global.getPlayerShip()
		else:
			if randf() < 0.5:
				followSquad()
			else:
				goToPlanet()
		
		

	elif CurrentGoal == GOALS.follow_squad:
		if getSquad().size() > 0:
			CurrentTarget = getSquadLeader()
			if randf() < LikelihoodOfPursuingPlayer * numCargo:
				goAfterPlayerShip()
		else: # you're the last one in the squad
			goAfterPlayerShip()

	elif CurrentGoal == GOALS.planet:
		if randf() < LikelihoodOfPursuingPlayer * numCargo:
			goAfterPlayerShip()
		else:
			goToPlanet()

func setLabel(labelStr):
	$ActionLabel.set_text(labelStr)
		
func getGoal():
	return CurrentGoal

func _process(delta):

	if Dead == false:
		if not is_instance_valid(CurrentTarget):
			getNewBehaviour()
		Ticks += 1
		TimeElapsed += delta

		lookTowardTarget(delta)
		
		Velocity = getVectorTowardTarget(delta)
		Velocity += getVectorSideToSideDodging(delta)
		Velocity += getVectorToAvoidAllies(delta)
		set_global_position(get_global_position() + Velocity)
		
		if CurrentGoal == GOALS.planet and hasReachedTarget():
			getNewBehaviour()
			

func hasReachedTarget():
	var minDistance = 750
	var minDistanceSq = minDistance * minDistance
	if getDistanceSqTo(CurrentTarget) < minDistanceSq:
		return true
	else:
		return false

func lightUpShield():
#	if $AnimationPlayer.is_playing():
#		$AnimationPlayer.seek(0.0)
#		$AnimationPlayer.stop()
	CurrentState = STATES.shielded
	$AnimationPlayer.play("shield")
	$Shield/ShieldTimer.start()
#	$CollisionShape2D.call_deferred("set_disabled", true)

func displayDamageEffect():
	$DamageFX/Particles2D.emitting = true
	
	
func lightUpExplosion():
#	if $AnimationPlayer.is_playing():
#		$AnimationPlayer.seek(0)
#		$AnimationPlayer.stop()
	CurrentState = STATES.exploding
	$AnimationPlayer.play("explosion")
	$Explosion/DestructionTimer.start()

func dieSlowly():
	$CollisionShape2D.call_deferred("set_disabled", true)
	CurrentState = STATES.dead
	$Sprite.hide()
	$Shield.hide()
	$weapons.hide()
	lightUpExplosion()

		
func takeDamage(damage):
	if CurrentState == STATES.normal:
		if ShieldRemaining > 0:
			lightUpShield()
			ShieldRemaining -= 10
		else:
			Health -= damage
			if Health <= 0:
				dieSlowly()
			else:
				displayDamageEffect()
		
	
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
	if getDistanceSqTo(CurrentPlayerShip) < ProximitySensorRange * ProximitySensorRange:
		if randf() < 0.8:
			goAfterPlayerShip()

func _on_ship_emptied_inventory():
	if getDistanceSqTo(CurrentPlayerShip) < ProximitySensorRange * ProximitySensorRange:
		getNewBehaviour()


func _on_BehaviourTimer_timeout():
	getNewBehaviour()
	$BehaviourTimer.set_wait_time(rand_range(5.0,20.0))
	$BehaviourTimer.start()
	
