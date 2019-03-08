extends RigidBody2D

# Declare member variables here. Examples:
var MyShip


# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.set_disabled(true)
	pass # Replace with function body.

func start(parentShip):
	MyShip = parentShip
	set_global_position(MyShip.get_global_position() - Vector2(300, 0).rotated(MyShip.get_global_rotation()))
	set_global_rotation(MyShip.get_global_rotation())
	$CollisionShape2D.call_deferred("set_disabled", false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()


func _draw():
	draw_line(to_local(get_global_position()), to_local(MyShip.get_global_position()-Vector2(50, 0).rotated(MyShip.get_global_rotation())), Color.antiquewhite, 3, true)
	