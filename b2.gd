extends Sprite

var speed = 100.0
var stopped = false

func _ready():
	position.x = 1900
	
func _process(delta):
	if stopped:
		return
		
	position.x -= speed * delta
	if position.x <= -630:
		position.x = 1900
	
func stop():
	stopped = true