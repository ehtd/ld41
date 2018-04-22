extends Node2D

var label_scene = preload("res://TypableLabel.tscn")
var max_count = 5
var current_count = 0

var active_labels = []

var label_selected = false
var label_selected_index = -1

func _input(event):
	if label_selected:
		return
		
	if event is InputEventKey:
		if event.is_echo():
			return
			
		if event.pressed:
			print("active_labels: ", active_labels)
			var key = OS.get_scancode_string(event.scancode).to_lower()
			
			for i in range(active_labels.size()):
				var label = active_labels[i]
				if active_labels[i].begins_with(key):
					label_selected = true
					label_selected_index = i
					label.select()
					label.tryToRemove(key)
					return
				# print("begins with letter: ",  key, "node: ", active_labels[i] ,": ",active_labels[i].begins_with(key))


func clearSelectedLabel():
	active_labels.remove(label_selected_index)
	label_selected = false
	
func labelDestroyed():
	clearSelectedLabel()
	
func generateLabel():
	print("Generating label")
	var label_instance = label_scene.instance()
	label_instance.position = Vector2(100.0, 50.0 * current_count)
	label_instance.connect("destroyed", self, "labelDestroyed")
	add_child(label_instance)
	
	active_labels.append(label_instance)
	
func _on_Timer_timeout():
	if current_count >= max_count:
		return
	
	current_count += 1
	
	generateLabel()
