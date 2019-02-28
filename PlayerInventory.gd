extends Tree

# Declare member variables here. Examples:
onready var global = get_node("/root/global")
var CurrentPlayerShip
var Ticks : int = 0
var InvDisplayTreeItem
var CurrentLevel : Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(.2), "timeout") # wait for player to spawn
	initializeTree()
	CurrentLevel = global.getCurrentLevel()
	print(self.name, " CurrentLevel == ", CurrentLevel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if CurrentLevel != null:
		if CurrentLevel.getState() == CurrentLevel.STATES.playing:
			Ticks += 1
			if Ticks % 60 == 0:
				updateInventoryDisplay()
	else:
		CurrentLevel = global.getCurrentLevel()

func initializeTree():
	set_columns(5)
	set_hide_root(false)
	
	var columnTitles = ["Ship Inventory", "cash", "food", "gem", "cog"]
	for indexNum in columnTitles.size():
		set_column_title(indexNum, columnTitles[indexNum])


	set_column_expand(0, true)
	set_column_min_width(0, 3)
#	set_column_expand(1, false)
#	set_column_expand(2, false)
#	set_column_expand(3, false)
	
	InvDisplayTreeItem = create_item(null)
	set_column_titles_visible(true)

func updateInventoryDisplay():
	
	if CurrentPlayerShip == null:
		CurrentPlayerShip = global.getPlayerShip()
	
	elif CurrentPlayerShip != null:
		InvDisplayTreeItem.set_text(0, "Player") # change later if the player gets to name their ship
		InvDisplayTreeItem.set_text(1, str(CurrentPlayerShip.getCash()))
		InvDisplayTreeItem.set_text(2, str(CurrentPlayerShip.getInventory()["wheat"]))
		InvDisplayTreeItem.set_text(3, str(CurrentPlayerShip.getInventory()["diamond"]))
		InvDisplayTreeItem.set_text(4, str(CurrentPlayerShip.getInventory()["cog"]))
		
	
	
	
	
	
	