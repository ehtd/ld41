extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$Sprite.connect("animation_finished", self, "animation_finished")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func animation_finished():
	print("animation finished", $Sprite.animation)
	if $Sprite.animation == "crying":
		$Sprite.play("tired")
	elif $Sprite.animation == "give_up":
		$Sprite.play("end")
