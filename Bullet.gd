extends Area2D

# Declare member variables here. Examples:
var Velocity : Vector2 
var Speed : float = 800
var TimeElapsed = 0.0
var BaseRot
export var WaveFreq : float
export var sinPattern : bool = false
var Acceleration = 1700.0

var CurrentPos
var NextPos
var LastPos

# Called when the node enters the scene tree for the first time.
func _ready():
	TimeElapsed += randf()
	WaveFreq = randf() * 10 + 5.0

func start(loc, rot, initialVel ):
	BaseRot = rot
	Velocity = initialVel + Vector2(Speed, 0).rotated(rot)
	set_global_position(loc)
	rotation = rot



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	TimeElapsed += delta
	Velocity += Vector2(Acceleration * delta, 0).rotated(BaseRot)

	LastPos = get_global_position()
	CurrentPos = get_global_position() + Velocity * delta  + Vector2(0, 12 * sin(TimeElapsed*WaveFreq)).rotated(BaseRot)
	NextPos = CurrentPos + get_global_position() + Velocity * delta  + Vector2(0, 12 * sin(TimeElapsed*WaveFreq)).rotated(BaseRot)
	set_global_position( CurrentPos )
#	look_at(NextPos)
