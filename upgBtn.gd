extends Button

# Declare member variables here. Examples:
onready var global = get_node("/root/global")



export var CostPerUpgrade : int = 1000
export var UpgradeName : String

export var CurrentUpgrade : int = 0
export var MaxUpgrades : int = 1

enum STATES {  initializing, ready  }
var CurrentState = STATES.initializing
var Ticks : int = 0

signal upgrade_btn_pressed(type, requestedBy)


# Called when the node enters the scene tree for the first time.
func _ready():
	set_text(UpgradeName + ": " + str(CostPerUpgrade))
	set_disabled(true)

	if is_connected("pressed", self, "_on_Btn_pressed") == false:
		connect("pressed", self, "_on_Btn_pressed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Ticks += 1
	if CurrentState == STATES.initializing:
		if Ticks % 60 == 0:
			if global.getPlayerShip() != null:
				CurrentState = STATES.ready
				set_disabled(false)
			

func checkSufficientCash():
	if global.getPlayerShip().getCash() >= getUpgradeCost():
		return true
	else:
		return false
		
func getUpgradeCost():
	return CostPerUpgrade * (CurrentUpgrade + 1)
	
func updatePrice():
	set_text(UpgradeName + ": " + str(CostPerUpgrade * (CurrentUpgrade+1)))
	if CurrentUpgrade >= MaxUpgrades:
		set_text(UpgradeName + ": Max")
		set_disabled(true)

func playUpgradeNoise():
	$"../UpgradeComplete".play()
	
func playInsufficientFunds():
	$"../InsufficientFunds".play()
	
	
func purchaseUpgrade():
	if checkSufficientCash() == true:
		var upgradeCost = (CurrentUpgrade+1)*CostPerUpgrade
		connect("upgrade_btn_pressed", global.getPlayerShip(), "_on_UpgradeButtons_upgrade_pressed")
		emit_signal("upgrade_btn_pressed", UpgradeName, upgradeCost, self)
		disconnect("upgrade_btn_pressed", global.getPlayerShip(), "_on_UpgradeButtons_upgrade_pressed")			
		CurrentUpgrade += 1
		playUpgradeNoise()
		updatePrice()
	else:
		playInsufficientFunds()
	

func _on_Btn_pressed():
	if global.getPlayerShip() == null:
		return # bail out because the ship isn't onscreen yet
	if CurrentState == STATES.ready:
			purchaseUpgrade()
			
		
