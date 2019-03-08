extends PanelContainer

# Declare member variables here. Examples:

var Ticks = 0


onready var global = get_node("/root/global")

var Paused : bool = false

enum STATES { waiting, ready }
var CurrentState = STATES.waiting

signal pause_game()
signal resume_game()
signal quit_game()


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(.1), "timeout") # wait for main
	
	connect("pause_game", global, "_on_PausePanel_pause_requested")
	
	connect("resume_game", global, "_on_PausePanel_resume_pressed")
	connect("resume_game", global.getMain(), "_on_PausePanel_resume_pressed")

	connect("quit_game", global, "_on_PausePanel_quit_pressed")

	
	#hide()
	
	var textBox = $MarginContainer/VBoxContainer/HSplitContainer2/RichTextLabel
	textBox.set_bbcode(
	"""Hello. Thank you for playing.

This game was created by PlexSoup for the
	 Blackthorn Prod Game Jam.
Source is available on [url]https://github.com/plexsoup[/url]

Images: game-icons.net, NASA
Software: Godot, Inkscape, Gimp, Audacity.
Music: 'Blue Feather', Kevin Macleod. Voices: ttsreader.com
"""
	
	)

func initialize():
	CurrentState = STATES.Ready

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Ticks += 1
	# try and prevent holding escape key causing show, then immediately hide
	
	if Paused == true and Ticks > 3 and Input.is_action_just_pressed("pause"):
		emit_signal("resume_game")
		hidePanel()
		
	# showPanel input is captured in Main.

func unhidePanel():
#	Paused = true
#	show()
#	MyAnimationPlayer.play("reveal")
#	yield(MyAnimationPlayer, "animation_finished")
	pass
	# send a signal to the Bottom Button.

func hidePanel():
#	Paused = false
#	MyAnimationPlayer.play("hide")
#	yield(MyAnimationPlayer, "animation_finished")	
#	hide()
	pass
	# send a signal to the bottom button
	



func _on_QuitButton_pressed():
	emit_signal("quit_game")

func _on_ResumeButton_pressed():
	emit_signal("resume_game")
	hidePanel()
	

func _on_RichTextLabel_meta_clicked(meta):
	print(self.name, " meta == ", meta )
	#OS.execute(meta)
	OS.shell_open(meta)
	
	$MarginContainer/VBoxContainer/RichTextLabel/WelcomeVoice.play()



func _on_PausePanel_visibility_changed():
	if visible == true:
		Ticks = 0 # reset the count so I can delay input actions
		
func _on_main_pause_requested():
	print("the pause message is coming from main")
	emit_signal("pause_game")
	unhidePanel()
	
func _on_level_started():
	initialize()
	