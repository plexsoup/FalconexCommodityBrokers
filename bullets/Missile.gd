extends Area2D

# Declare member variables here. Examples:
var Velocity : Vector2
var Speed : float = 1200
var TimeElapsed = 0.0
var BaseRot
export var WaveFreq : float
export var sinPattern : bool = false
var Acceleration = 2200.0
var Damage : int = 500

enum STATES { travelling, exploding }
var CurrentState = STATES.travelling


export var ExplosionRadius: int = 512

var CurrentPos
var NextPos
var LastPos

signal hit(damage)

# Called when the node enters the scene tree for the first time.
func _ready():
	TimeElapsed += randf()
	WaveFreq = randf() * 10 + 5.0


func start(loc, rot, initialVel ):
	BaseRot = rot
	Velocity = initialVel + Vector2(Speed, 0).rotated(rot)
	set_global_position(loc)
	rotation = rot

	$FuseTimer.set_wait_time(0.8+randf())
	$FuseTimer.start()

	$DurationTimer.start() # shouldn't be needed, but just in case.

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	TimeElapsed += delta

	if CurrentState == STATES.travelling:
		Velocity += Vector2(Acceleration * delta, 0).rotated(BaseRot)
		LastPos = get_global_position()
		CurrentPos = get_global_position() + Velocity * delta  + Vector2(0, 12 * sin(TimeElapsed*WaveFreq)).rotated(BaseRot)
		NextPos = CurrentPos + get_global_position() + Velocity * delta  + Vector2(0, 12 * sin(TimeElapsed*WaveFreq)).rotated(BaseRot)
		set_global_position( CurrentPos )
	#	look_at(NextPos)

# Why doesn't this work?
#	if CurrentState == STATES.travelling:
#		Velocity += Vector2(Acceleration * delta * delta, 0).rotated(BaseRot)
#		LastPos = get_global_position()
#		CurrentPos = get_global_position() + Velocity  # + Vector2(0, 12 * sin(TimeElapsed*WaveFreq)).rotated(BaseRot)
#		NextPos = CurrentPos + Velocity  # + Vector2(0, 12 * sin(TimeElapsed*WaveFreq)).rotated(BaseRot)
#		set_global_position( CurrentPos )
#	#	look_at(NextPos)

func explode(radius):
	$Sprite.hide()
	CurrentState = STATES.exploding
	$Explosion/AnimationPlayer.play("explode")
	Velocity = Vector2(0, 0)

func _on_Missile_area_entered(area):
	if area.has_method("_on_hit") and area.is_in_group("enemies"):
		$CollisionShape2D.call_deferred("set_disabled", true)
#		call_deferred("queue_free")
		explode(ExplosionRadius)
		

func _on_Explosion_area_entered(area):
	if area.has_method("_on_hit") and area.is_in_group("enemies"):
		connect("hit", area, "_on_hit")
		emit_signal("hit", Damage)
		disconnect("hit", area, "_on_hit")



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "explode":
		call_deferred("queue_free")


func _on_DurationTimer_timeout():
	queue_free()


func _on_FuseTimer_timeout():
	explode(ExplosionRadius)
