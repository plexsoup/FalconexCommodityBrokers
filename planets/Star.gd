extends StaticBody2D

# Declare member variables here. Examples:
export var OrbitGalaxyOn : bool = true

var MyGalaxy
var Velocity : Vector2
const NINETY = PI/2
var Speed : float
export var BaseSpeed : float = 0.05
var TangentVector : Vector2
var Ticks : int = 0
var CommodityTypes = ["wheat", "diamond", "cog"]
var PlanetTypes = ["agricultural", "mining", "industrial"]
var MyName : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func start(myGalaxy, distFromGalaxyCenter, direction):
	MyGalaxy = myGalaxy
	set_global_position(Vector2(distFromGalaxyCenter, 0).rotated(direction))
	Speed = distFromGalaxyCenter * BaseSpeed
	generateName()
	spawnPlanets(randi()%7 +1)
	

func spawnPlanets(numPlanets):
	var PlanetScene = load("res://planets/Planet.tscn")
	
	for planetNum in numPlanets:
		var newPlanet = PlanetScene.instance()
		$Planets.add_child(newPlanet)
		var planetType = PlanetTypes[randi()%PlanetTypes.size()]
		var direction = (2*PI) / numPlanets * planetNum
		var dist = 1000 + randi()%800
		var planetScale = rand_range(0.1, 0.3)

		newPlanet.start(self, planetType, direction, dist, planetScale)

func generateName():
	
	var markovSyllables = ["en", "ad", "dl", "ex", "ut", "pi", "ma", "ni", "con", "vect", "pram", "targ", "sen", "bit", "cul", "fen", "Hel", "ios", "and", "rom", "eda", "cent", "ar", "i", "lept", "us"]

	for i in range(3):
		MyName += markovSyllables[randi()%markovSyllables.size()]
		MyName = MyName.capitalize()
	$StarName.set_text(MyName)
	self.name = MyName
	

func orbit(delta):
	# move in a tangent to the vector to the star
	var vectorToGalaxy = MyGalaxy.get_global_position() - get_global_position()
	TangentVector = vectorToGalaxy.normalized().rotated(NINETY)
#	if Ticks % 30 == 0:
#		print(self.name, " TangentVector == ", TangentVector )
	Velocity = TangentVector * Speed
	#set_linear_velocity(Velocity)
	set_global_position(get_global_position() + Velocity * delta)

func getPlanets():
	return $Planets.get_children()


func getLinearVelocity():
	return Velocity

func _physics_process(delta):
	Ticks += 1
	if OrbitGalaxyOn:
		orbit(delta)
#	update()
#
#func _draw():
#	draw_line(Vector2(0, 0), TangentVector * Speed, Color.red, 1, true)
#
#
