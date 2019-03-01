"""

Manage plantary motion, inventory, pricelist, scale, collision shape, etc.

"""


extends RigidBody2D

# Declare member variables here. Examples:
export var OrbitOn : bool = true

var MyStar
var Velocity : Vector2
const NINETY = PI/2
export var BaseSpeed: float = 0.25
var SpeedBonus : float

var TangentVector : Vector2
var Ticks : int = 0
var MyName : String = ""
var CommodityTypes = ["wheat", "diamond", "cog"]
var PlanetType : String
var MyCommodityType : String = ""
export var MaxCommoditiesHeld : int = 8
var CommodityInventory: int = 0
var ClosedForBusiness : bool = false
var PlanetSize : float

var PriceList = {"wheat":100, "diamond":100, "cog":100}
onready var global = get_node("/root/global")

signal commodity_requested(type, price)
signal purchase_accepted(commodityName, quantity, purchasePrice)


# Called when the node enters the scene tree for the first time.
func _ready():
	MyStar = get_node("../..")
	
	
#	var initialPos = get_global_position() + Vector2(randf()*300, randf()*300) - Vector2(150, 150)
#	set_global_position(initialPos)
#	set_sleeping(false)

func connectSignals():
	#print(self.name, " global.getCurrentLevel() == " , global.getCurrentLevel())
	connect("commodity_requested", global.getCurrentLevel(), "_on_Planet_commodity_requested")
	
func start(starToOrbit, planetType, direction, dist, planetScale):
	yield(get_tree().create_timer(0.1), "timeout") # wait for global

	connectSignals()
	MyStar = starToOrbit
	PlanetType = planetType

	set_global_position(MyStar.get_global_position() + Vector2(dist, 0).rotated(direction))

	$TetherToStar.start(self, MyStar, dist)
	generateName()
	SpeedBonus = randf()*800.0
	
	setPlanetScale(planetScale)
	setPlanetColor(planetType)
	setPrices(planetType)

func getColumTextForListing():
	var columnText = [
		name,
		PriceList["wheat"],
		PriceList["diamond"],
		PriceList["cog"]
	]
	return columnText
	
func setPrices(planetType):
	var priceIncreaseFactor = 0.125 / PlanetSize
	# planet scale is 0.1 to 0.3. 1/.1 = 10 1/.3 = 30
	match planetType:
		"agricultural":
			MyCommodityType = "wheat"
			PriceList = {"wheat":50, "cog":150, "diamond":100}
		"industrial":
			MyCommodityType = "cog"
			PriceList = {"wheat":50, "cog":100, "diamond":150}
		"mining":
			MyCommodityType = "diamond"
			PriceList = {"wheat":150, "cog":100, "diamond":50}
	for item in PriceList:
		PriceList[item] = floor(PriceList[item] * priceIncreaseFactor)
		#print(self.name, "PriceList[", item, "] == " , PriceList[item])

#func setSpeed():
#	var distToStar = get_global_position().distance_to(MyStar.get_global_position())
#	Speed = BaseSpeed * distToStar

func setPlanetColor(planetType):
	match planetType:
		"agricultural":
			$Sprite.set_modulate(Color.greenyellow) # green
		"industrial":
			$Sprite.set_modulate(Color.maroon)
		"mining":
			$Sprite.set_modulate(Color.lightgray) # grey 
			
func setPlanetScale(planetScale):
	PlanetSize = planetScale
	$Sprite.set_scale(Vector2(planetScale, planetScale))
	
	# need new collision shape for each planet, since they're different sizes

	var colShape = CollisionShape2D.new()

	var circle = CircleShape2D.new()
	circle.set_radius(253.0 * planetScale)
	colShape.set_shape(circle)
	add_child(colShape)
	
	
		
func generateName():
	
	var markovSyllables = ["en", "ad", "dl", "ex", "ut", "pi", "ma", "ni", "con", "vect", "pram", "targ", "sen", "bit", "cul", "fen", "ar", "ak", "is", "plu", "to", "gla", "ti", "us", "ach", "ra", "dy" ]

	for i in range(3):
		MyName += markovSyllables[randi()%markovSyllables.size()]
		MyName = MyName.capitalize()
	$PlanetName.set_text(MyName)
	self.name = MyName
	
func getStar():
	return MyStar

func orbit(delta):
	# move in a tangent to the vector to the star
	var vectorToStar = MyStar.get_global_position() - get_global_position()
	TangentVector = vectorToStar.normalized().rotated(NINETY)
	var distToStar = vectorToStar.length()
#	if Ticks % 30 == 0:
#		print(self.name, " TangentVector == ", TangentVector )
	Velocity = TangentVector * (BaseSpeed * distToStar + SpeedBonus)
	set_sleeping(false)
	apply_central_impulse(Vector2(0, 0))
	
	#Linear Velocity doesn't care about delta
	set_linear_velocity(Velocity + MyStar.getLinearVelocity())

func trade_commodities(commodityDict, intendedPlanet):
	var total = 0
	if not ClosedForBusiness:
		print(self.name, ": intendedPlanet == ", intendedPlanet )
		if intendedPlanet == self: # player only sells to planets they've selected on the list (to prevent accidental sales)
			for commodity in CommodityTypes:
				total += commodityDict[commodity] * PriceList[commodity]



	return total

func playWelcomeGreeting():
	$WelcomeTraveller.play()

func playThankYouMessage():
	$ThankYouTraveller.play()

func ejectCommoditiesForVisitingShip():
	if CommodityInventory > 0:
		playWelcomeGreeting()
	# kick out collectible gems for player to pick up
	for i in range(CommodityInventory):
		#print(self.name, " CommodityInventory == ", CommodityInventory)
		var pos = get_global_position()
		emit_signal("commodity_requested", pos, MyCommodityType)
		# ^^^^ to the level manager, so they're not parented to the planet
	CommodityInventory = 0
	$ProductionTimer.start()

func _on_VisitLockoutTimer_timeout():
	ClosedForBusiness = false
		

func _physics_process(delta):
	Ticks += 1
	if OrbitOn:
		orbit(delta)
#	update()
#
#func _draw():
	#draw_line(Vector2(0, 0), (TangentVector * Speed), Color.red, 1, true)
	

	


func _on_ProductionTimer_timeout():
	if CommodityInventory < MaxCommoditiesHeld:
		CommodityInventory += 1
		$ProductionTimer.start()
		
func _on_ship_sell_requested(seller, commodityName, quantity):
	if ClosedForBusiness == false:
		var purchasePrice = PriceList[commodityName] * quantity
		connect("purchase_accepted", seller, "_on_planet_purchase_accepted")
		#print(self.name, " accepting purchase ", " seller == ", seller, ", commodityName == ", commodityName, ", quantity == " ,quantity   )
		emit_signal("purchase_accepted", commodityName, quantity, purchasePrice)
		disconnect("purchase_accepted", seller, "_on_planet_purchase_accepted")
		
		$VisitLockoutTimer.start()
		
		if commodityName == "cog": # *** hack - buy wheat, diamond, cog then close for a while
			ClosedForBusiness = true
			$VisitLockoutTimer.start()
			playThankYouMessage()
	
			
func _on_ship_commodities_requested(shipObj):
	ejectCommoditiesForVisitingShip()

	