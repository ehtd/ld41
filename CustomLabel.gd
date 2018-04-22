extends Node2D

var original = ""
var selected = false
var backup = ""

export var text = ""

func select():
	#print('Label selected: ', self)
	$Label/ColorRect.color = '#ff581e73'
	selected = true

func deselect():
	selected = false
	$Label/ColorRect.color = '#000000'
	original = backup
	$Label.text = original

func _ready():
	$Label.text = text
	$Label/ColorRect.color = '#000000'
