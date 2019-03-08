"""
NewsAndQuests will scroll text across it's Panel width.
To do this, we'll spawn a series of textboxes.
Once spawned, the textboxes will move their rectangles themselves.


"""


extends Control




# Declare member variables here. Examples:
var NewsItems : Array = [
	"Flood affects [i]TibitDa[/i]. Thousands perish. Planet is in vital need of medical supplies from [i]Objecto[/i]. Compenstaion: $2500",
	"Local population of [i]Metroplitano[/i] seeks luxury items. Bring gems from any planet. Compensation: $1500",
	"Raiders attacking [i]Litcano[/i]! Planet seeks urgent aid from any fighting-capable vessels. Save the planet for permanent price increase on planet.",
	"Planet [i]Vilneuava[/i] is falling into orbital decay. Push it into a stable orbit for reward.",
	"Mining production is down on [i]Plantaric[/i] due to poor supply chain management. Bring cogs for reward."

]
var CurrentNewsItem : int = 0
var CurrentLetter : int = 0
var CrawlMaxLetters : int = 50
var ScrollSpeed : float = 20.0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawnNewsItem():
	print("spawning news")
	var newsItem = NewsCrawlItem.new()
	
	newsItem.start( generateNews(),  Vector2( get_viewport_rect().size.x, 10) )
		# probably (1060, 10) makes the most sense
	
	
func generateNews():
	# TODO: get a random planet, 
		# figure out it's type, 
		# then make relevant news, madlib style
	
	# for now, we'll just pick a string
	return NewsItems[randi()%NewsItems.size()]

func _on_NextNewsItemTimer_timeout():
	$NextNewsItemTimer.set_wait_time(15.0*randf()*30.0)
	$NextNewsItemTimer.start()

	spawnNewsItem()
