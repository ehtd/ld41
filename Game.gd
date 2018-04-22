extends Node2D

const SCREEN_WIDTH = 640
const SCREEN_HEIGHT = 320

var label_scene = preload("res://TypableLabel.tscn")
var max_count = 10
var current_count = 0

var active_labels = []

var label_selected = null
var label_selected_index = -1
	
func _ready():
	randomize()
	
func _input(event):
	if label_selected != null:
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
					label_selected = label
					label.select()
					label.tryToRemove(key)
					return
				# print("begins with letter: ",  key, "node: ", active_labels[i] ,": ",active_labels[i].begins_with(key))


func clearSelectedLabel():
	active_labels.remove(label_selected_index)
	label_selected = false

func labelExpired(label):
	print("active_labels: ", active_labels)
	print("Expired:", label)
	active_labels.erase(label)
	print("active_labels: ", active_labels)
	if label_selected == label:
		label_selected = null
	
func labelDestroyed(label):
	print("active_labels: ", active_labels)
	print("Destroyed:", label)
	active_labels.erase(label)
	print("active_labels: ", active_labels)
	label_selected = null
	
func generateLabel():
	print("Generating label")
	var label_instance = label_scene.instance()
	label_instance.position = Vector2(SCREEN_WIDTH - 8, rand_range(SCREEN_HEIGHT - 100, SCREEN_HEIGHT))
	label_instance.connect("destroyed", self, "labelDestroyed")
	label_instance.connect("expired", self, "labelExpired")
	add_child(label_instance)
	
	active_labels.append(label_instance)
	
func _on_Timer_timeout():
	if current_count >= max_count:
		return
	
	current_count += 1
	
	generateLabel()
