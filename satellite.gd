extends Sprite

# Declare member variables here. Examples:
var OrbitPeriod
var TimeElapsed : float = 0.0
const LOOP_LIMIT : int = 50
const e = 2.71828
var a = 1

func orbitBodyTest1(delta):

	# hide last position drawn
	#context.clearRect( last_x -10, last_y - 10, 20, 20);
	
	# 1) find the relative time in the orbit and convert to Radians
	var M = 2.0 * PI * TimeElapsed / OrbitPeriod;
	
	# 2) Seed with mean anomaly and solve Kepler's eqn for E
	var u = M # seed with mean anomoly
	var u_next = 0
	var loopCount = 0
	# iterate until within 10-6
	while(loopCount < LOOP_LIMIT):
		# this should always converge in a small number of iterations - but be paranoid
		u_next = u + (M - (u - e * sin(u)))/(1 - e * cos(u))
		if (abs(u_next - u) < 0.00001):
			return
		u = u_next
		loopCount += 1
 

	# 2) eccentric anomoly is angle from center of ellipse, not focus (where centerObject is). Convert
	# to true anomoly, f - the angle measured from the focus. (see Fig 3.2 in Gravity) 
	var cos_f = (cos(u) - e)/(1 - e * cos(u))
	var sin_f = (sqrt(1 - e*e) * sin (u))/(1 - e * cos(u))
	var r = a * (1 - e*e)/(1 + e * cos_f)

	
	#time = time + 1;
	# animate
	
	#last_x = focus_x + r*cos_f
	#last_y = focus_y + r*sin_f

	position = Vector2(r* cos_f, r*sin_f)
	
	
	#setTimeout(orbitBody, 30);


func orbitBodyTest2(delta):
	position += Gravity.dT * Velocity;
	Velocity += Gravity.dT * GravityAccelerationVector(Position);	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	OrbitPeriod = 2.0 * PI * sqrt(a*a*a/(m*m)) # G=1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	TimeElapsed += delta


"""
var orbitPeriod = 2.0 * Math.PI * Math.sqrt(a*a*a/(m*m)); // G=1

function orbitBody() {

 // hide last position drawn
 context.clearRect( last_x -10, last_y - 10, 20, 20);

 // 1) find the relative time in the orbit and convert to Radians
 var M = 2.0 * Math.PI * time/orbitPeriod;

 // 2) Seed with mean anomaly and solve Kepler's eqn for E
 var u = M; // seed with mean anomoly
 var u_next = 0;
 var loopCount = 0;
 // iterate until within 10-6
 while(loopCount++ < LOOP_LIMIT) {
 // this should always converge in a small number of iterations - but be paranoid
 u_next = u + (M - (u - e * Math.sin(u)))/(1 - e * Math.cos(u));
 if (Math.abs(u_next - u) < 1E-6)
 break;
 u = u_next;
 }

 // 2) eccentric anomoly is angle from center of ellipse, not focus (where centerObject is). Convert
 // to true anomoly, f - the angle measured from the focus. (see Fig 3.2 in Gravity) 
 var cos_f = (Math.cos(u) - e)/(1 - e * Math.cos(u));
 var sin_f = (Math.sqrt(1 - e*e) * Math.sin (u))/(1 - e * Math.cos(u));
 var r = a * (1 - e*e)/(1 + e * cos_f);

 time = time + 1;
 // animate
 last_x = focus_x + r*cos_f;
 last_y = focus_y + r*sin_f;
 drawBody( r* cos_f, r*sin_f, "blue");
 setTimeout(orbitBody, 30);
}
"""