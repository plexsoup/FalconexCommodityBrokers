extends Sprite

# Declare member variables here. Examples:
onready var global = get_node("/root/global")
var Shooting : bool
export var Bullet : PackedScene
onready var MyShip = $"../.."
export var Delay : float = .15

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
	emit_signal("bullet_requested", muzzle.get_global_position(), muzzle.get_global_rotation(), MyShip.get_linear_velocity(), Bullet)
	
#	var newBullet = Bullet.instance()
#	global.getCurrentLevel().get_node("Bullets").add_child(newBullet)
#	# this is bad practice. it's tightly coupled.
#	# better to send a signal asking for a new bullet
#
#	newBullet.start(muzzleLocation, get_global_rotation(), MyShip.get_linear_velocity())
#

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("shoot") and Shooting == false:
		Shooting = true
		commenceFiring()
		
	elif Input.is_action_just_released("shoot"):
		Shooting = false

func commenceFiring():
	$AudioStreamPlayer.play()
	$ReloadTimer.start()
	yield(get_tree().create_timer(0.15), "timeout")
	fireAllGuns()

func _on_ReloadTimer_timeout():
	if Shooting == true:
		commenceFiring()
