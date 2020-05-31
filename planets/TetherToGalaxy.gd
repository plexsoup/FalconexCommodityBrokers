extends PinJoint2D

# Declare member variables here. Examples:
var MyStar
var MyGalaxy
var TetherDistance
var Ready = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#yield(get_tree().create_timer(0.1), "timeout") # wait for global
	#Ready = true
	
	#var MyGalaxyPos = get_node(get_node_a()).get_global_position()
	#var lengthToGalaxyCenter = (get_global_position() - MyGalaxyPos).length()

func start(myStar, myGalaxy, distance):
	MyStar = myStar
	MyGalaxy = myGalaxy
	set_node_a(get_path_to(myGalaxy))
	set_node_b(get_path_to(myStar))
	Ready = true

# length is only used for spring joints
#	set_length(lengthToGalaxyCenter)
#	set_rest_length(lengthToGalaxyCenter * 0.75)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()

func _draw():
	if Ready == true:
		draw_line(to_local(get_node(get_node_a()).get_global_position()), to_local(get_node(get_node_b()).get_global_position()), Color.antiquewhite, 3, true)

