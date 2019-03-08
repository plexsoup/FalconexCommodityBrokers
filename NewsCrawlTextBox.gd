"""

NewsCrawlTextBox will take a string and a position, then slowly slide
across the display by shifting its rectangle coordinates

"""
extends RichTextLabel
class_name NewsCrawlItem

var Speed : float = -10.0

func _ready():
	set_anchors_preset(PRESET_BOTTOM_WIDE)
	
	
	
func start(text, pos):
	
	set_bbcode(text)
	set_position( pos )
	
func _process(delta):
	# shift position at ScrollSpeed
	set_position(get_position() + Vector2(Speed * delta, 0) )
