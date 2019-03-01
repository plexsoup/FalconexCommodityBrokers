extends Node2D

# Declare member variables here. Examples:
onready var global = get_node("/root/global")
onready var ShipContainer = get_node("galaxy/Ships")
export var MaxEnemies = 9

enum STATES {
	frozen, playing
}
var CurrentState = STATES.frozen

signal started()


# Called when the node enters the scene tree for the first time.
func _ready():
	global.setCurrentLevel(self)
	
	yield(get_tree().create_timer(0.5), "timeout") # wait for globals
	
	var textArr = [
	"""
		FalconEx Commodity Brokers\n\n
		You are the greatest merchant in the galaxy. You deliver goods
		between planets, always lookng for the best price.
	""",
	"""
		Pickup goods by bumping into planets. Then consult the sidebar
		and select the planet with the best purchasing price.
		\n
		Once you have a planet selected, your nav system will light up the path.
		\n
		Note: You will only sell to the planet you've chosen from the list.
	""",
	"""
		Use WASD to fly.
		Space to Shoot.
		Mouse Wheel to zoom.
		Click the ||| to open the sidebar.
		Use the mouse to select a planet from the list.
	""",
		"Use your cash to buy upgrades from the left sidebar."
	]

	CurrentState = STATES.frozen
	spawnDialogBox(textArr)

func getState():
	return CurrentState
	
func spawnPlayerShip():
	var playerShipScene = load("res://ships/Ship.tscn")
	var newPlayerShip = playerShipScene.instance()
	ShipContainer.add_child(newPlayerShip)
	global.setPlayerShip(newPlayerShip)
	
func spawnDialogBox(textArr):
	var dialogBox = preload("res://DialogBox.tscn")
	var newDialogBox = dialogBox.instance()
	$CanvasLayer/DialogBoxes.add_child(newDialogBox)
	newDialogBox.start(textArr, self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Weapon_bullet_requested(pos, rot, vel, bulletScene):
	
	var newBullet = bulletScene.instance()
	newBullet.start(pos, rot, vel)
	$Bullets.add_child(newBullet)
	
func spawnCommodity(startPos, type):
	var commodityScene = preload("res://collectibles/Commodity.tscn")
	var newCommodity = commodityScene.instance()
	
	var distance = 500
	var endPos = startPos + Vector2(randf()*distance, 0).rotated(randf()*2*PI)
		
	$Collectibles.add_child(newCommodity)
	newCommodity.start(type, startPos, endPos)
	
func spawnCashPopup(pos, amount):
	var popupScene = preload("res://effects/CashPopup.tscn")
	var newPopup = popupScene.instance()
	$Collectibles.add_child(newPopup)
	newPopup.start(pos, amount)

func spawnEnemies(num):
	var pos = Vector2(15000, 0).rotated(randf()*2*PI) # outside boundary
	var enemyScene = preload("res://ships/enemy.tscn")

	for i in range(num):
		yield(get_tree().create_timer(.25), "timeout")
		var newEnemy = enemyScene.instance()
		ShipContainer.add_child(newEnemy)
	
		newEnemy.start(pos)
		pos += Vector2(randf()*300+100, randf()*300+100)

func startGame():
	CurrentState = STATES.playing
	for object in get_tree().get_nodes_in_group("GUI"):
		if object.has_method("_on_Level_started"):
			connect("started", object, "_on_Level_started")
	emit_signal("started")
	for object in get_tree().get_nodes_in_group("GUI"):
		if is_connected("started", object, "_on_Level_started"):
			disconnect("started", object, "_on_Level_started")
	

func getNumEnemies():
	return get_tree().get_nodes_in_group("enemies").size()


func _on_Planet_commodity_requested(pos, type):
	call_deferred("spawnCommodity", pos, type)

func _on_Ship_commodity_lost(pos, type):
	if randf()<0.1:
		return # commodity lost
	else:
		call_deferred("spawnCommodity", pos, type)

func _on_ship_cash_popup_requested(pos, amount):
	#print(self.name, " received signal _on_ship_cash_popup_requested ", pos, " " , amount)
	call_deferred("spawnCashPopup", pos, amount)

func _on_DialogBox_completed():
	spawnPlayerShip()
	startGame()


func _on_EnemySpawnTimer_timeout():
	if CurrentState == STATES.playing:
		if getNumEnemies() < MaxEnemies:
			spawnEnemies(3)

func _on_ship_filled_inventory():
	var warningPanel = $CanvasLayer/WarningPanel
	var warningLabel = warningPanel.get_node("WarningLabel")
	warningPanel.flashMessage()
	
	