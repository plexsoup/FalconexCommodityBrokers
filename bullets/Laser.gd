extends Area2D

# Declare member variables here. Examples:
var Velocity : Vector2
var Speed : float = 1800
var TimeElapsed = 0.0
var BaseRot
export var WaveFreq : float
export var sinPattern : bool = false
var Acceleration = 1700.0
export var Damage = 100

var CurrentPos

signal hit(damage)

# Called when the node enters the scene tree for the first time.
func _ready():
	TimeElapsed += randf()
	
func start(loc, rot, initialVel ):
	BaseRot = rot
	Velocity = initialVel + Vector2(Speed, 0).rotated(rot)
	set_global_position(loc)
	rotation = rot



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	TimeElapsed += delta

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
