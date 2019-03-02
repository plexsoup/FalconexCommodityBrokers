extends DampedSpringJoint2D

# Declare member variables here. Examples:
export var Length : float = 125
var MyPlanet
var MyStar

# Called when the node enters the scene tree for the first time.
func _ready():
	#wait a moment for the planet to set its position
#	yield(get_tree().create_timer(0.1), "timeout")

	pass
	

func start(myPlanet, myStar, orbitalDistance):
	MyPlanet = myPlanet
	MyStar = myStar
	
	# WTF? This next line was commented out. how was it working?
	initializeSpring(orbitalDistance)

func initializeSpring(orbitalDistance):
	set_node_a(get_path_to(MyPlanet))
	set_node_b(get_path_to(MyStar))
	set_length(orbitalDistance * 1.5)
	set_rest_length(orbitalDistance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#update()

#func _draw():
#	draw_circle(Vector2(0, 0), 25, Color.blue)
#	draw_line(to_local(get_node(get_node_a()).get_global_position()), to_local(get_node(get_node_b()).get_global_position()), Color.antiquewhite, 10)

