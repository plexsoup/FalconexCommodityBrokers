extends Sprite

# Declare member variables here. Examples:
onready var global = get_node("/root/global")
var Shooting : bool = false
export var Bullet : PackedScene
onready var MyShip = $"../.."
export var Delay : float = .15
var Ticks : int = 0
var ShootCycleTimerTicks : int = 0

signal bullet_requested(position, rotation, bulletScene)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	connect("bullet_requested", global.getCurrentLevel(), "_on_Weapon_bullet_requested")

	if has_node("ReloadTimer"):
		if $ReloadTimer.is_connected("timeout", self, "_on_ReloadTimer_timeout") == false:
			$ReloadTimer.connect("timeout", self, "_on_ReloadTimer_timeout")
	else:
		print(self.name, " error needs a Reload Timer" )

func fireAllGuns():
	
	for muzzle in $Muzzles.get_children():
		fireBullet(muzzle )
	$ReloadTimer.start()

func fireBullet(muzzle):
	#print(self.name, " MyShip linear_velocity == ", MyShip.get_linear_velocity())
	var rot = muzzle.get_global_rotation() + randf()*0.035 - 0.0175
	emit_signal("bullet_requested", muzzle.get_global_position(), rot, MyShip.Velocity, Bullet)
	
#	var newBullet = Bullet.instance()
#	global.getCurrentLevel().get_node("Bullets").add_child(newBullet)
#	# this is bad practice. it's tightly coupled.
#	# better to send a signal asking for a new bullet
#
#	newBullet.start(muzzleLocation, get_global_rotation(), MyShip.get_linear_velocity())
#

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Ticks += 1

func isShipCapableOfFiring():
	var capability = true
	if MyShip.CurrentState == MyShip.STATES.exploding:
		capability = false
	elif MyShip.CurrentState == MyShip.STATES.dead:
		capability = false
	elif MyShip.Dead == true:
		capability = false
	return capability

func commenceFiring():
	#$AudioStreamPlayer.play()
	#yield(get_tree().create_timer(0.15), "timeout")
	# STATES: normal, shielded, exploding, dead
	if isShipCapableOfFiring():
		fireAllGuns()
		$ReloadTimer.start()
	
func _on_ReloadTimer_timeout():
	if Shooting == true:
		commenceFiring()

func toggleShooting():
	if Shooting == true:
		Shooting = false
		
	else:
		if isShipCapableOfFiring():
			Shooting = true
			commenceFiring()


func _on_ShootCycleTimer_timeout():
	if isShipCapableOfFiring() == false:
		Shooting = false
		return # bail out. no more shooting if you're dead.
		
	ShootCycleTimerTicks += 1

	# 5 off, 1 on
	if Shooting == false and ShootCycleTimerTicks % 5 == 0:
		if MyShip.getGoal() == MyShip.GOALS.player:
			toggleShooting()
	elif Shooting == true:
		toggleShooting()
