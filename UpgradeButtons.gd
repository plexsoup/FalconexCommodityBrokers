extends GridContainer

# Declare member variables here. Examples:
onready var global = get_node("/root/global")
var CurrentShip
var Ticks = 0

enum STATES { initializing, ready }
var CurrentState = STATES.initializing

signal upgrade(upgradeType, requestingObj)


# Called when the node enters the scene tree for the first time.
func _ready():
	setButtonStatus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Ticks += 1
	if Ticks % 60 == 0 and CurrentShip == null:
		CurrentShip = global.getPlayerShip()
		if CurrentShip != null: # first time we found the player
			connectSignals()

func setButtonStatus():
	for object in get_children():
		if object is Button:
			match object.name:
				"upgLaserBtn":
					object.set_disabled(false)
				"upgEnginesBtn":
					object.set_disabled(false)
				"upgShieldsBtn":
					object.set_disabled(false)
				"upgMissilesBtn":
					object.set_disabled(false)
				"upgMagnetBtn":
					object.set_disabled(false)
				"upgTargetingBtn":
					object.set_disabled(true)
				"upgMinesBtn":
					object.set_disabled(true)
				"upgCargoBtn":
					object.set_disabled(false)
	

func connectSignals():
	connect("upgrade", CurrentShip, "_on_UpgradeButtons_upgrade_pressed")
	connect("upgrade", global.getCurrentLevel(), "_on_UpgradeButtons_upgrade_pressed")
	
	CurrentState = STATES.ready

func checkSufficientCash():
	var costOfUpgrade = 1000
	if CurrentShip.getCash() >= costOfUpgrade:
		return true
	else:
		$InsufficientFunds.play()
		return false

func playUpgradeNoise():
	$UpgradeComplete.play()

func disableButton(button):
	button.set_disabled(true)
	
				
func _on_upgLaserBtn_pressed():
	var button = $upgLaserBtn
	if CurrentState == STATES.ready:
		if checkSufficientCash() == true:
			emit_signal("upgrade", "lasers", self)
			playUpgradeNoise()
			disableButton(button)
	
	

func _on_upgEnginesBtn_pressed():
	var button = $upgEnginesBtn
	if CurrentState == STATES.ready:
		if checkSufficientCash() == true:
			emit_signal("upgrade", "engines", self)
			playUpgradeNoise()
			disableButton(button)


func _on_upgShieldsBtn_pressed():
	var button = $upgShieldsBtn
	if CurrentState == STATES.ready:
		if checkSufficientCash() == true:
			emit_signal("upgrade", "shields", self)
			playUpgradeNoise()
			disableButton(button)


func _on_upgMissilesBtn_pressed():
	var button = $upgMissilesBtn
	if CurrentState == STATES.ready:
		if checkSufficientCash() == true:
			emit_signal("upgrade", "missiles", self)
			playUpgradeNoise()
			disableButton(button)


func _on_upgMagnetBtn_pressed():
	var button = $upgMagnetBtn
	if CurrentState == STATES.ready:
		if checkSufficientCash() == true:
			emit_signal("upgrade", "magnet", self)
			playUpgradeNoise()
			disableButton(button)


func _on_upgTargetingBtn_pressed():
	var button = $upgTargetingBtn
	if CurrentState == STATES.ready:
		if checkSufficientCash() == true:
			emit_signal("upgrade", "targeting", self)
			playUpgradeNoise()
			disableButton(button)
	


func _on_upgMinesBtn_pressed():
	var button = $upgMinesBtn
	if CurrentState == STATES.ready:
		if checkSufficientCash() == true:
			emit_signal("upgrade", "mines", self)
			playUpgradeNoise()
			disableButton(button)


func _on_upgCargoBtn_pressed():
	var button = $upgCargoBtn
	if CurrentState == STATES.ready:
		if checkSufficientCash() == true:
			emit_signal("upgrade", "storage", self)
			playUpgradeNoise()
			disableButton(button)
