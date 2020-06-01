extends Node2D

# Declare member variables here. Examples:
onready var StarSystems = get_node("StarSystems")
var GalaxyLimitRadius : int = 15000

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	notifyGlobal()
	spawnStars(randi()%4 + 3)


func notifyGlobal():
	global.setGalaxy(self)
		
func spawnStars(numStars):
	var starScene = load("res://planets/Star.tscn")
	for starNum in numStars:
		var newStar = starScene.instance()
		$StarSystems.add_child(newStar)
		var quadrantSize = (2*PI)/numStars
		var direction = quadrantSize*starNum + randf()*quadrantSize
		var dist = 4400 + randi()%3600
		
		newStar.start(self, dist, direction)
	spawnBackgroundStars(550)

func spawnBackgroundStars(numStars):
	var BGStarScene = load("res://planets/BGStars.tscn")
	var medianStars = numStars
	var minStars = numStars / 5
	var maxStars = 2*numStars
	#for i in range(int(rand_range(minStars,maxStars))):	
	for i in range(randi()%(2*numStars)): # too often produces very few background stars
		var newBGStarCluster = BGStarScene.instance()
		
		var randDirection = randf()*2*PI
		var randDistance = randf()*GalaxyLimitRadius
		newBGStarCluster.set_global_position((Vector2(1, 0)*randDistance).rotated(randDirection))
		$"BGStars".add_child(newBGStarCluster)

func getStars():
	return StarSystems.get_children()

func getRandomPlanet():
	var stars = getStars()
	var randomStar = stars[randi()%stars.size()]
	var randomPlanet = randomStar.getRandomPlanet()
	return randomPlanet


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
	# represents the known galaxy
	var numArcs = 96
	var arcSegmentSize = 2*PI/numArcs
	var dist = GalaxyLimitRadius
	
	for arcNum in range(numArcs):
		draw_line(Vector2(dist, 0).rotated(arcNum*arcSegmentSize), Vector2(dist, 0).rotated((arcNum+1)*arcSegmentSize), Color.greenyellow, 5.0, true)
		
	#draw_circle(Vector2(0, 0), 7500, Color(0.2, 0.2, 0.2, 0.2 ))

func getExtents():
	return GalaxyLimitRadius
