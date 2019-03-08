"""
Drives the character rigid body around the world

Should take input signals from either a player input controller or an AI controller.
Remain agnostic of who's controlling you.

"""

extends RigidBody2D

export var MaxThrust : float
export var ThrustIncrement : float = 10
export var SpinThrust : float
export var MaxSpeed = 1500.0
var CurrentThrust : float = 0.0
var ThrustVector = Vector2()
var DirectionVector: Vector2 = Vector2(0, 0)
var CompassTarget

var Galaxy
var GalaxyPos

onready var EngineSound = $thrust/EngineNoise
onready var global = get_node("/root/global")

var CommodityTypes = ["wheat", "diamond", "cog"]
var CommoditiesHeld = {"wheat":0, "diamond":0, "cog":0}
var MaxInventoryCount = 16

var UpgradesDict = {"lasers":0, "engines":0, "shields":0, "missiles":0, "magnet":0, "targeting":0, "mines":0, "storage":0}
var MaxUpgrades = {"lasers":2, "engines":2, "shields":2, "missiles":2, "magnet":2, "targeting":0, "mines":0, "storage":2}
var Cash : int = 0

var rotation_dir = 0
var screensize

var Shielded : bool = false
var MaxShields : int = 0
var Shields : int = 0
var ShieldAnimation : String = "shields0"
var SideBarDemoCompleted : bool = false

var Ticks : int = 0
var ElapsedTime : float = 0

signal sell(commodityName, quantity)
signal buy(shipObj)
signal cash_popup_requested(pos, amount)
signal picked_up_commodity()
signal filled_inventory()
signal lost_item(pos, commodityType)
signal shopping_requested()
signal pin_joint_requested(nodeA, nodeB)

func _ready():
	start() # why isn't Level calling Start?

func start():
	screensize = get_viewport().get_visible_rect().size
	Galaxy = global.getGalaxy()
	GalaxyPos = Galaxy.get_global_position()
	
	set_contact_monitor(true)
	set_max_contacts_reported(5)

	connect("cash_popup_requested", global.getCurrentLevel(), "_on_ship_cash_popup_requested")

	initializeEngines()


func initializeEngines():
	for engine in $Engines.get_children():
		engine.start($PlayerInputController)
	

func get_input():
	if global.getState() == global.STATES.paused:
		return
	
	if Input.is_action_pressed("applyThrust"):
		CurrentThrust += ThrustIncrement
		CurrentThrust = clamp(CurrentThrust, 0, MaxThrust)
		ThrustVector = Vector2(CurrentThrust, 0)
	else:
		ThrustVector = Vector2(0, 0)
		CurrentThrust = 0

	if Input.is_action_pressed("turnRight"):
		rotation_dir = 1
	elif Input.is_action_pressed("turnLeft"):
		rotation_dir = -1
	else:
		rotation_dir = 0


func setThrustEffect():
	var maximumPossibleThrust = 5500 # allow jet to look bigger after upgrade
	$thrust.set_scale(Vector2(1, CurrentThrust/maximumPossibleThrust * rand_range(0.9, 1.0)))
	$thrust.set_rotation(rand_range(-0.1, 0.1))
	if CurrentThrust > 0:
		if EngineSound.is_playing() == false:
			EngineSound.play()
	else:
		EngineSound.stop()

func checkCashAndOpenUpgradeBar():
	if SideBarDemoCompleted == false and Cash > 1000:
		SideBarDemoCompleted = true
		connect("shopping_requested", global.getMain(), "_on_ship_shopping_requested")
		emit_signal("shopping_requested")
		disconnect("shopping_requested", global.getMain(), "_on_ship_shopping_requested")

#func _process(delta):
#	if Ticks % 5 == 0:
#		updateDebugLabels()
		
		
func updateDebugLabels():
	$CanvasLayer/Panel/SpinThrust.set_text("Torque: " + str(get_applied_torque() ))
	$CanvasLayer/Panel/GodotVersion.set_text("Version: " + str( Engine.get_version_info()))
	$CanvasLayer/Panel/ElapsedTime.set_text("Elapsed Time: " + str(ElapsedTime))

func apply_engine_thrust():
	setThrustEffect()		
	var vel = get_linear_velocity()
	var spd = vel.length()
	if spd < MaxSpeed:
		set_applied_force(ThrustVector.rotated(rotation))
	else:
		set_applied_force(Vector2.ZERO)
	#set_applied_torque(rotation_dir * SpinThrust)
	
	
	if get_linear_velocity().length() > MaxSpeed:
		set_linear_damp(1)
	else:
		set_linear_damp(0.1)
	

func _physics_process(delta):
	Ticks += 1
	ElapsedTime += delta
	checkCashAndOpenUpgradeBar()

	get_input()
	#apply_engine_thrust() # moving this to discrete engines

	var planetsColliding = getPlanetsColliding()
	if planetsColliding.size() > 0:		
		tradeCommodities(planetsColliding)

	if isOutOfBounds():
		redirectPlayer()
		
	DirectionVector = Vector2(1, 0).rotated(get_global_rotation())
	
	update()

func getPlanetsColliding():
	var planetArr : Array = []
	
	var collidingBodies = get_colliding_bodies()
	if collidingBodies != null and collidingBodies.size() > 0:
		for object in get_colliding_bodies():
			if object.is_in_group("planets"):
				planetArr.push_back(object)
	return planetArr

func sellGoodsToPlanet(planet):
	if getInventoryItemCount() > 0:
		if planet == CompassTarget and planet.has_method("_on_ship_sell_requested"):
			for commodity in CommoditiesHeld:
				# (self.name, " trying to sell: ", CommoditiesHeld)
				connect("sell", planet, "_on_ship_sell_requested")
				emit_signal("sell", self, commodity, CommoditiesHeld[commodity])
				disconnect("sell", planet, "_on_ship_sell_requested")
			CompassTarget = null
	
func buyGoodsFromPlanet(planet):
	if planet != CompassTarget:
		connect("buy", planet, "_on_ship_commodities_requested")
		emit_signal("buy", self)
		disconnect("buy", planet, "_on_ship_commodities_requested")
	
func tradeCommodities(planetArr):
	if planetArr is Array == false:
		print(self.name, " error in tradeCommodities, expected planetArr to be an array", planetArr)
	if planetArr != null and planetArr.size() > 0:
		for planet in planetArr:
			sellGoodsToPlanet(planet) # does this order matter?
			buyGoodsFromPlanet(planet)
	
func pickup_commodity(collectibleObj, commodityType):
	# Note: This is called from a foreign class:
			# better if it was a signal
	if getInventoryItemCount() < MaxInventoryCount:
		CommoditiesHeld[commodityType] += 1
		connect("picked_up_commodity", collectibleObj, "_on_ship_picked_up_commodity")
		emit_signal("picked_up_commodity")
		disconnect("picked_up_commodity", collectibleObj, "_on_ship_picked_up_commodity")
		if getInventoryItemCount() == MaxInventoryCount:
			$InventoryFullNoise.play()

			alertFullInventory()
	else:
		pass # ignore items after you've notified about full inventory
	
	
func selectRandomDeliveryDestination():
	CompassTarget = global.getGalaxy().getRandomPlanet()
	$CoordinatesReceivedNoise.play()
	
	
	
func alertFullInventory():
	
	# tell the all enemies and the main level
	var currentLevel = global.getCurrentLevel()
	connect("filled_inventory", currentLevel , "_on_ship_filled_inventory")

	for enemy in get_tree().get_nodes_in_group("enemies"):
		connect("filled_inventory", enemy, "_on_ship_filled_inventory")

	emit_signal("filled_inventory")
	for enemy in get_tree().get_nodes_in_group("enemies"):
		disconnect("filled_inventory", enemy, "_on_ship_filled_inventory")
	
	disconnect("filled_inventory", currentLevel , "_on_ship_filled_inventory")

	
func getInventory():
	return CommoditiesHeld

func getInventoryItemCount():
	var total = 0
	for commodityType in CommoditiesHeld:
		total += CommoditiesHeld[commodityType]
	return total

func isCargoHoldFull():
	if getInventoryItemCount() < MaxInventoryCount:
		return false
	else:
		return true
	
func getCash():
	return Cash
	
func isOutOfBounds():
	var galaxy = global.getGalaxy()
	var distFromGalaxyCenter = get_global_position().distance_to( galaxy.get_global_position() )
	if distFromGalaxyCenter > galaxy.getExtents():
		return true
	else:
		return false

func redirectPlayer():
	# either flip their direction 180 or move them to the other side of the map
	# print(self.name, " player out of bounds")
	
	#get the tangent to the perpendicual to the center of the galaxy
	# get a bounce vector based on your current velocity
	var vecToCenter = Galaxy.get_global_position() - get_global_position()
	var normalVec = vecToCenter.normalized()
	var tangentVector = vecToCenter.rotated(PI/2)
	var linearVel = get_linear_velocity()
	
	var directionVector = Vector2(1, 0).rotated(get_global_rotation())
	#if directionVector.dot(vecToCenter) < 0: # looking out
	if get_linear_velocity().dot(vecToCenter) < 0: # looking out
	
		var bounceVector = linearVel.bounce(normalVec)
		look_at(bounceVector)
		var boundaryDamp = 0.2
		set_applied_force(get_applied_force().bounce(normalVec))
		set_linear_velocity(bounceVector * boundaryDamp)
	


func _draw():
	if CompassTarget != null:
		draw_line(to_local(get_global_position()), to_local(CompassTarget.get_global_position()), Color(0.2, 1.0, 0.2, 0.5), 2)
	

func _on_PlanetList_selected_object(object):
	CompassTarget = object
	
func _on_planet_purchase_accepted(commodityName, quantity, cashGiven):
	#print(self.name , " planet accepted our sale: ", commodityName, ", ", " quantity ", quantity, " , cashGiven ", cashGiven )
	Cash += cashGiven
	CommoditiesHeld[commodityName] -= quantity
	emit_signal("cash_popup_requested", get_global_position(), cashGiven)
	#spawnCashPopup(cashGiven)
	
func _input(event):
	if event.is_action_pressed("cash_popup"):
		emit_signal("cash_popup_requested", get_global_position(), 1000)
		Cash += 1000

func loseItem():
	var itemsInHold = []
	for key in CommoditiesHeld:
		if CommoditiesHeld[key] > 0:
			itemsInHold.push_back(key)
	if itemsInHold.size() > 0:
		var commodityType = itemsInHold[randi()%itemsInHold.size()]
		connect("lost_item", global.getCurrentLevel(), "_on_Ship_commodity_lost" )
		emit_signal("lost_item", get_global_position(), commodityType)
		disconnect("lost_item", global.getCurrentLevel(), "_on_Ship_commodity_lost" )
		CommoditiesHeld[commodityType] -= 1
	else:
		if Cash > 100:
			Cash -= 100
	
	
func _on_hit(amount):
	
	if Shielded == false or Shields <= 0:
		$CrashNoise.play()
		# give up commodities first, then cash
		loseItem()
		$Shield.hide()
	else:
		# **** TODO: Move this logic into Shields object
		if $Shield/AnimationPlayer.is_playing() == false:
			$Shield/AnimationPlayer.play(ShieldAnimation)
			Shields -= 100
			$Shield/ShieldRechargeTimer.start()
		
func getMaxUpgrade(upgradeType):
	return MaxUpgrades[upgradeType]

func _on_UpgradeButtons_upgrade_pressed(upgradeType, upgradeCost, requestingObj):
	var costOfUpgrade = upgradeCost
	if Cash >= costOfUpgrade:
		Cash -= costOfUpgrade
		UpgradesDict[upgradeType] += 1
		var level = UpgradesDict[upgradeType]
		match upgradeType:
			"lasers":
				if level == 1:
					$Weapons/DualLasers/ReloadTimer.set_wait_time(0.08)
					$Weapons/DualLasers.Bullet = load("res://bullets/Laser2.tscn")
				elif level == 2:
					$Weapons/DualLasers/Muzzles/Port2.show()
					$Weapons/DualLasers/Muzzles/Starboard2.show()
			"engines":
				if level == 1:
					MaxThrust = 3500
					ThrustIncrement = 800
					SpinThrust = 65000
					MaxSpeed = 5500
					$thrust.set_self_modulate(Color.lightgreen)
					
				elif level == 2:
					MaxThrust = 5500
					ThrustIncrement = 1200
					SpinThrust = 80000
					MaxSpeed = 7500
					$thrust.set_self_modulate(Color.aquamarine)
			"shields":
				if level == 1:
					$Shield.upgradeShields(1)
					Shielded = true
					MaxShields = 500
					ShieldAnimation = "shields1"
				elif level == 2:
					$Shield.upgradeShields(2)
					MaxShields = 1000
					ShieldAnimation = "shields2"
					
				Shields = MaxShields
				$Shield/AnimationPlayer.play(ShieldAnimation)
				$Shield/ShieldRechargeTimer.start()
				
			"missiles":
				if level == 1:
					$Weapons/MissileLaunchers/Muzzles/Port.show()
					$Weapons/MissileLaunchers/Muzzles/Starboard.show()
				elif level == 2:
					$Weapons/MissileLaunchers/ReloadTimer.set_wait_time(0.15)
			"magnet":
				var shape = $Magnet/CollisionShape2D.get_shape()
				if level == 1:
					shape.set_radius(750)
				elif level == 2:
					shape.set_radius(1500)
			"targeting":
				pass
		
			"storage":
				if level == 1:
					MaxInventoryCount = 32
					$Storage1.show()
				elif level == 2:
					MaxInventoryCount = 64
					var newCargoWagon = load("res://ships/CargoWagon.tscn").instance()
					add_child(newCargoWagon)
					newCargoWagon.start(self)
					
					connect("pin_joint_requested", global.getCurrentLevel(), "_on_pin_joint_requested")
					emit_signal("pin_joint_requested", self, newCargoWagon)
					disconnect("pin_joint_requested", global.getCurrentLevel(), "_on_pin_joint_requested")
					moveEnginesOut()
#					var pinJoint = $PinJoint2D
#					pinJoint.set_node_a(pinJoint.get_path_to(self))
#					pinJoint.set_node_b(pinJoint.get_path_to(newCargoWagon))

		#Notify the Level to increase MaxEnemies
		
			

func moveEnginesOut():
	var engine1 = find_node("PortEngine1")
	var engine2 = find_node("StarboardEngine1")
	engine1.set_position(engine1.get_position()-Vector2(0, 50))
	engine2.set_position(engine2.get_position()+Vector2(0, 50))


func _on_InventoryFullNoise_finished():
	if CompassTarget == null:
		selectRandomDeliveryDestination()


func _on_ShieldRechargeTimer_timeout():
	if Shielded == true and Shields < MaxShields:
		Shields += 100
		$Shield.show()
		#print(self.name, " Shields == " , Shields)
	$Shield/ShieldRechargeTimer.start()
		

