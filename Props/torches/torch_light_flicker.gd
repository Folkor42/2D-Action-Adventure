extends PointLight2D


# Called when the node enters the scene tree for the first time.
func _ready():
	flicker()
	pass # Replace with function body.

func flicker() -> void:
	energy = randf() * 0.1 + 0.9
	scale = Vector2(1,1) * energy
	await get_tree().create_timer(0.133).timeout
	flicker()
	pass
