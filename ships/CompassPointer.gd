extends Sprite

var MyTarget
var Type
var Ticks = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Ticks += 1
	
	# point at target
	if MyTarget == null:
		distributeEvenly()
	elif is_instance_valid(MyTarget):
		look_at(MyTarget.get_global_position())
	else:
		visible = false

func distributeEvenly():
	var myNum = get_position_in_parent()
	var totalCount = get_parent().get_child_count()
	var ratio : float = float(myNum)/float(totalCount)
	var dirToPoint = ratio * 2 * PI
	set_global_rotation(dirToPoint)

func start(target, color):
	
	MyTarget = target
	set_self_modulate(color)
	visible = true
	
func die():
	queue_free()
