extends Label

var original = ""
var selected = true

func generateWord():
	return "word"
	
func _ready():
	original = generateWord()
	text = original

func tryToRemove(letter):
	prints("Current word ", original)
	if original.empty():
		return
		
	if original.begins_with(letter):
		prints("begins")
		original.erase(0, 1)
		text = original
		
		if original.empty():
			prints("destroying")
	
		
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
