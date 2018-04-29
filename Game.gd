extends Node2D

const SCREEN_WIDTH = 640
const SCREEN_HEIGHT = 320

var label_scene = preload("res://TypableLabel.tscn")

var active_labels = []

var label_selected = null

var move_speed = 100
var move_up = true
var person_move_offset_min = 100
var person_move_offset_max = SCREEN_HEIGHT - 100

var goose_move_offset = 10
var goose_speed_up = false
var goose_increase_x = 10
var goose_decrease_x = 50
var goose_x = 0

var disable_input = false

var game_ended = false

var skip_once = false

func _ready():
	randomize()
	$Goose.position = Vector2(200, rand_range(SCREEN_HEIGHT - 100, SCREEN_HEIGHT-200))
	$Person.position = Vector2(SCREEN_WIDTH - 200, rand_range(SCREEN_HEIGHT - 100, SCREEN_HEIGHT-200))
	goose_x = $Goose.position.x
	$Goose.connect("outOfBounds", self, "fail")
	$Goose.connect("caughtPerson", self, "win")
	$Music.play()
	
func _input(event):
	if event is InputEventKey:
		if event.is_echo():
			return
			
		if event.pressed:
			#print("active_labels: ", active_labels)
			var key = OS.get_scancode_string(event.scancode).to_lower()
			#print("key: ", key)
			
			if key == "enter" and game_ended:
				get_tree().change_scene("res://Menu.tscn")
				return
			
			if disable_input:
				return
		
			if key == "backspace" and label_selected != null:
				label_selected.deselect()
				label_selected = null
				return
				
			if label_selected != null:
				return
		
			# There is a bug where the last letter of the word will pick up the first letter of another word
			if skip_once:
				skip_once = false
				return
				
			for i in range(active_labels.size()):
				var label = active_labels[i]
				if active_labels[i].begins_with(key):
					label_selected = label
					label.select()
					label.tryToRemove(key)
					return
				# print("begins with letter: ",  key, "node: ", active_labels[i] ,": ",active_labels[i].begins_with(key))

func _process(delta):
	if disable_input:
		return
		
	avoidGoose(delta)
	chasePerson(delta)
	move(delta)
		
func win():
	# do person relief animation
	$Goose/Sprite.play("prepare_win")
	$Person/Sprite.play("give_up")
	stopParallax()
	cleanUpLabels()
	$Goose.position = $Person.position
	print("WIN")
	game_ended = true
	$Instructions.visible = true
	#$Music.stop()
	
func fail():
	# do mixed person screaming and goose win animation
	$Person/Sprite.play("crying")
	stopParallax()
	cleanUpLabels()
	print("FAIL")
	game_ended = true
	$Instructions.visible = true
	$Music.stop()

func stopParallax():
	$b1.stop()
	$b2.stop()
	
func cleanUpLabels():
	disable_input = true
	$Timer.stop()
	
	if label_selected != null:
		label_selected = null
		
	for i in range(active_labels.size()):
		var label = active_labels[i]
		label.cleanUp()
	
	active_labels.clear()
	#print("active_labels: ", active_labels)
	
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

func move(delta):
	$Goose.position.x = lerp($Goose.position.x, goose_x, 0.1)

#### TypableLabel signals

func labelExpired(label):
	#print("active_labels: ", active_labels)
	#print("Expired:", label)
	active_labels.erase(label)
	#print("active_labels: ", active_labels)
	if label_selected == label:
		label_selected = null
	goose_x -= goose_decrease_x
	
func labelDestroyed(label):
	#print("active_labels: ", active_labels)
	#print("Destroyed:", label)
	active_labels.erase(label)
	#print("active_labels: ", active_labels)
	label_selected = null
	goose_x += goose_increase_x
	skip_once = true
	
#### LABEL TIMER

func generateLabel():
	#print("Generating label")
	var label_instance = label_scene.instance()
	label_instance.position = Vector2(SCREEN_WIDTH - 8, rand_range(SCREEN_HEIGHT - 100, SCREEN_HEIGHT))
	label_instance.connect("destroyed", self, "labelDestroyed")
	label_instance.connect("expired", self, "labelExpired")
	add_child(label_instance)
	
	active_labels.append(label_instance)
	
func _on_Timer_timeout():
	generateLabel()
	$SFXPlayer.play()
