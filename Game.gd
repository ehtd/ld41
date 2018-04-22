extends Node2D

const SCREEN_WIDTH = 640
const SCREEN_HEIGHT = 320

var label_scene = preload("res://TypableLabel.tscn")
var max_count = 50
var current_count = 0

var active_labels = []

var label_selected = null

var move_speed = 100
var move_up = true
var person_move_offset_min = 100
var person_move_offset_max = SCREEN_HEIGHT - 100

var goose_move_offset = 10

func _ready():
	randomize()
	$Goose.position = Vector2(100, rand_range(SCREEN_HEIGHT - 100, SCREEN_HEIGHT-200))
	$Person.position = Vector2(SCREEN_WIDTH - 200, rand_range(SCREEN_HEIGHT - 100, SCREEN_HEIGHT-200))
	
	
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

func _process(delta):
	avoidGoose(delta)
	chasePerson(delta)
	
#### PERSON ACTIONS

func avoidGoose(delta):
	var max_offset = person_move_offset_max + rand_range(-100, 100)
	if move_up:
		$Person.position -= Vector2(0.0, move_speed * delta)
	else:
		$Person.position += Vector2(0.0, move_speed * delta)
		
	if $Person.position.y <= person_move_offset_min:
		move_up = false
	elif $Person.position.y >= max_offset:
		move_up = true
	
	
#### GOOSE ACTIONS

func chasePerson(delta):
	var offset = rand_range(-goose_move_offset, goose_move_offset)
	$Goose.position.y = lerp($Goose.position.y, $Person.position.y + offset, 0.1)

#### TypableLabel signals

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
	
#### LABEL TIMER

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
