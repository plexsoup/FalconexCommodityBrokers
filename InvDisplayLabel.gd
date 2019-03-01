extends Label

# Declare member variables here. Examples:
export var CommodityType : String = "wheat"
onready var global = get_node("/root/global")
var Ticks : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_text("")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global.getCurrentLevel().CurrentState == global.getCurrentLevel().STATES.playing:
	
		Ticks += 1
		if Ticks % 60 == 0:
			if CommodityType != "cash":
				set_text(str(global.getPlayerShip().getInventory()[CommodityType]))
			else:
				set_text(str(global.getPlayerShip().getCash()))	
