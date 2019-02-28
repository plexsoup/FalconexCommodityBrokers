extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	#setupPointGravity()
	pass

func setupPointGravity():
	set_space_override_mode(SPACE_OVERRIDE_REPLACE)
	set_gravity_is_point(true)
	set_gravity_vector(get_global_position())
	set_gravity(600)
	set_gravity_distance_scale(0.1)
