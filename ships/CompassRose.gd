extends Node2D

var PointerScene = preload("res://GUI/CompassPointer.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	# spawn a pointer for each planet
	#addPlanets()
	pass

func spawnPointer(containerNode, target, color):
	var newPointer = PointerScene.instance()
	containerNode.add_child(newPointer)
	newPointer.start(target, color) # semi-transparent green

func addPlanets():
	for planet in global.getGalaxy().getStars():
		var translucentGreen = Color(0, 1, 0, 0.5)
		spawnPointer($planets, planet, translucentGreen) # semi-transparent green

func addCommodity():
	spawnPointer($cargo, null, Color.purple)
	
func removeCommodity(commodityType):
	var cargoPointers = $cargo.get_children()
	if cargoPointers.size() > 0:
		cargoPointers[0].die()

func clearCargo():
	for compassPointer in $cargo.get_children():
		compassPointer.die()

	
func _on_ship_picked_up_commodity():
	addCommodity()
	
func _on_Ship_commodity_lost(location, commodityType):
	removeCommodity(commodityType)
