extends Tree

# Declare member variables here. Examples:
onready var global = get_node("/root/global")
var Ticks :int = 0
var Galaxy
var Stars
var Planets : Array = []
var ListItemObjects : Array = []

signal celestial_object_selected(object)

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(1), "timeout") # wait for galaxy to be ready
	initializeLists()

func initializeLists():
	set_columns(4)
	set_hide_root(true)
	#set_column_title(0, "idx")
	set_column_title(0, "Market Prices")
	set_column_min_width(0, 3)
	#set_column_title(2, "type")
	set_column_title(1, "food")
	set_column_title(2, "gem")
	set_column_title(3, "cog")
	set_column_titles_visible(true)
	
	var rootItem = create_item(null, 0) # root

	if Galaxy == null:
		Galaxy = global.getGalaxy()
	
	if Galaxy != null:
		var stars = Galaxy.getStars()
		
		var indexNum = 0
		
		
		for star in stars:
			var starIndex = star.get_position_in_parent()
			var starListing = create_item(rootItem, indexNum)
			#starListing.set_text(0, str(indexNum))
			starListing.set_text(0, star.name)
			ListItemObjects.push_back(star)
			indexNum += 1
			for planet in star.getPlanets():
				Planets.push_back(planet)
				var planetItem = create_item(starListing, indexNum)
				var columnTextArr = planet.getColumTextForListing()
				for colNum in columnTextArr.size():
					planetItem.set_text(colNum, str(columnTextArr[colNum]))
					#planetItem.set_text(0, str(indexNum))
				ListItemObjects.push_back(planet)
				indexNum += 1
				

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Ticks += 1
	
	if Ticks % (60 * 5) == 0: # every 5 seconds or so
		pass
		
	
	
		
func findPlanetByName(planetName):
	# note, if there's more than one planet with the same name, this will return the first one in the list
	for planet in Planets:
		if planet.name == planetName:
			return planet
	return null
		

func _on_PlanetList_item_selected():
	# doesn't work anymore, because we're not using indexes.
	# change it to find planet by name
	
	var item = get_selected()
	var objectName = item.get_text(0)
	var object = findPlanetByName(objectName)
	if object != null:
		connect("celestial_object_selected", global.getPlayerShip(), "_on_PlanetList_selected_object")
		emit_signal("celestial_object_selected", object)
		disconnect("celestial_object_selected", global.getPlayerShip(), "_on_PlanetList_selected_object")



func _on_PlanetList_nothing_selected():
	connect("celestial_object_selected", global.getPlayerShip(), "_on_PlanetList_selected_object")
	emit_signal("celestial_object_selected", null)
	disconnect("celestial_object_selected", global.getPlayerShip(), "_on_PlanetList_selected_object")
