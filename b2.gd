extends Sprite

var speed = 100.0
var stopped = false

func _ready():
	position.x = 1910
	
func _process(delta):
	if stopped:
		return
		
	position.x -= speed * delta
	if position.x <= -640:
		position.x = 640*3 - 10
	
func stop():
	stopped = true