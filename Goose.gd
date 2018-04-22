extends Area2D

signal outOfBounds
signal caughtPerson

var emitted_out_of_bounds = false
var emitted_caught_person = false

func _process(delta):
	if emitted_out_of_bounds:
		return
		
	if position.x <= 0:
		emit_signal("outOfBounds")
		emitted_out_of_bounds = true

func _on_Goose_area_entered(area):
	if emitted_caught_person:
		return
		
	if area.is_in_group("person"):
		emit_signal("caughtPerson")
		emitted_caught_person = true
