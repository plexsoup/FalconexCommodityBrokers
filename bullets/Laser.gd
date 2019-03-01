extends Area2D

# Declare member variables here. Examples:
var Velocity : Vector2
var Speed : float = 1800
#var TimeElapsed = 0.0
var Ticks : int = 0
var BaseRot
export var WaveFreq : float
export var sinPattern : bool = false
var Acceleration = 1700.0
export var Damage = 100

enum STATES { flash, laser, dead }
var CurrentState = STATES.flash

var CurrentPos

signal hit(damage)

# Called when the node enters the scene tree for the first time.
func _ready():
	#TimeElapsed += randf()
	pass
	
func start(loc, rot, initialVel ):
	BaseRot = rot
	Velocity = initialVel + Vector2(Speed, 0).rotated(rot)
	set_global_position(loc)
	rotation = rot


func showMuzzleFlash():
	if has_node("MuzzleFlashSprite"):
		$MuzzleFlashSprite.set_rotation($MuzzleFlashSprite.get_rotation() + randf()*0.4 - 0.2)
		$MuzzleFlashSprite.show()
	$LaserSprite.hide()
	
func hideMuzzleFlash():
	if has_node("MuzzleFlashSprite"):
		$MuzzleFlashSprite.hide()

func showLaser():
	if has_node("MuzzleFlashSprite"):
		$MuzzleFlashSprite.hide()
	$LaserSprite.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#TimeElapsed += delta
	Ticks += 1

	if Ticks == 1:
		showMuzzleFlash()
	elif Ticks == 2:
		hideMuzzleFlash()
	elif Ticks == 3:
		CurrentState = STATES.laser 
		showLaser()

	else:
		CurrentPos = get_global_position() + Velocity * delta
		set_global_position( CurrentPos )
	

func _on_Duration_timeout():
	queue_free()
	


func _on_Laser_area_entered(body):
	if body.has_method("_on_hit") and body.is_in_group("enemies"):
		
		connect("hit", body, "_on_hit")
		emit_signal("hit", Damage)
		disconnect("hit", body, "_on_hit")
		$CollisionShape2D.call_deferred("set_disabled", true)
		call_deferred("queue_free")
