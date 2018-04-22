extends Node2D

signal destroyed(typableLabel)
signal expired(typableLabel)

var original = ""
var selected = false
var backup = ""

var move_speed = 100.0

var moving = true
var id = get_instance_id()

func select():
	print('Label selected: ', self)
	$Label/ColorRect.color = '#ff00ff'
	selected = true

func deselect():
	selected = false
	$Label/ColorRect.color = '#000000'
	original = backup
	$Label.text = original
	
func begins_with(letter):
	return original.begins_with(letter)
	
func generateWord():
	var words = ["lunatic",
"grabs",
"basis",
"against",
"lean",
"paper",
"calculated",
"purge",
"scores"]

	var random_index = rand_range(0, words.size() - 1)
	return words[random_index]
	
func _ready():
	original = generateWord()
	backup = original
	$Label.text = original
	$Label/ColorRect.color = '#000000'

func destroy():
	prints("destroying")
	emit_signal("destroyed", self)
	selected = false
	queue_free()

func expire():
	prints("expired")
	emit_signal("expired", self)
	selected = false
	queue_free()
	
func _process(delta):
	if moving:
		position -= Vector2(move_speed * delta, 0.0)

	if position.x <= -8:
		expire()
		
func tryToRemove(letter):
	prints("Current word ", original)
	if original.empty():
		return
		
	if original.begins_with(letter):
		prints("begins")
		original.erase(0, 1)
		$Label.text = original
		
		if original.empty():
			destroy()
	
		
func _input(event):
	if selected == false:
		return
		
	if event is InputEventKey:
		if event.is_echo():
			return

		if event.pressed:
			var key = OS.get_scancode_string(event.scancode).to_lower()
			prints("Key pressed", key)
			tryToRemove(key)
