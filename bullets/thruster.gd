extends Sprite

# Declare member variables here. Examples:
var BaseRotation
var BaseScale

# Called when the node enters the scene tree for the first time.
func _ready():
	BaseRotation = rotation
	BaseScale = scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_rotation(BaseRotation + (randf()*2 - 1 )/8)
	set_scale(BaseScale * (1-randf()/8))