extends Sprite2D

@export var speed : float = 100

var rect : Rect2

# Called when the node enters the scene tree for the first time.
func _ready():
	rect = self.region_rect
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	region_rect.position += Vector2( speed * delta, 0)
	pass
