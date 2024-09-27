class_name Plant extends Node2D

@export_category("Item Drops")
@export var drops : Array [ DropData ]

const PICKUP = preload("res://Items/Item_pickup/item_pickup.tscn")

func _ready():
	$HitBox.Damaged.connect ( TakeDamage )

	pass

func TakeDamage( _hurt_box : HurtBox ) -> void:
	drop_items()
	queue_free()

func drop_items() -> void:
	if drops.size() == 0:
		return
	for i in drops.size():
		if drops[ i ] == null or drops[ i ].item == null:
			continue
		var drop_count : int = drops[ i ].get_drop_count()
		for j in drop_count:
			var drop : ItemPickup = PICKUP.instantiate() as ItemPickup
			drop.item_data = drops[ i ].item
			get_parent().call_deferred( "add_child", drop )
			drop.global_position = global_position
	pass
