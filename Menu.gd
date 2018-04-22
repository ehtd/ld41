extends Node2D

func _input(event):
	if event is InputEventKey:
		if event.is_echo():
			return
			
		if event.pressed:
			#print("active_labels: ", active_labels)
			var key = OS.get_scancode_string(event.scancode).to_lower()
			print("key: ", key)
			
			if key == "enter":
				get_tree().change_scene("res://Game.tscn")
				