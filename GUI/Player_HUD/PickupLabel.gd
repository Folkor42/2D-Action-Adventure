extends Label

@onready var pickup_label = $"."

func _ready()->void:
	connect( "picked_up", DisplayPickup )

func DisplayPickup() ->void:
	pickup_label.text ="Item Picked Up"
