extends Node2D

signal destroyed()

var original = ""
var selected = false

func select():
	print('Label selected: ', self)
	selected = true

func deselect():
	selected = false
	
func begins_with(letter):
	return original.begins_with(letter)
	
func generateWord():
	return "word"
	
func _ready():
	original = generateWord()
	$Label.text = original

func tryToRemove(letter):
	prints("Current word ", original)
	if original.empty():
		return
		
	if original.begins_with(letter):
		prints("begins")
		original.erase(0, 1)
		$Label.text = original
		
		if original.empty():
			prints("destroying")
			emit_signal("destroyed")
			selected = false
			queue_free()
	
		
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
