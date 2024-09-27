@tool
class_name ItemPickup extends CharacterBody2D

signal picked_up

@export var item_data : ItemData : set = _set_item_data

@onready var area_2d : Area2D = $Area2D
@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var audio_stream_player_2d : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var item_drop: PersistantDataHandler = $ItemDrop
var name_path 

func _ready() -> void:
	_update_texture()
	if Engine.is_editor_hint():
		return
	area_2d.body_entered.connect ( _on_body_entered )
	#item_drop.set_drop_value(global_position,item_data)
	name_path = get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name

func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide( velocity * delta )
	if collision_info:
		velocity = velocity.bounce( collision_info.get_normal() )
	velocity -= velocity * delta * 4
	pass

func _set_item_data ( value : ItemData ) -> void:
	item_data = value
	_update_texture()
	pass

func _on_body_entered ( b ) -> void:
	if b is Player:
		if item_data:
			if PlayerManager.INVENTORY_DATA.add_item ( item_data ) == true:
				item_picked_up( item_data.name )
	pass
	
func item_picked_up ( _name : String ) -> void:
	area_2d.body_entered.disconnect( _on_body_entered )
	audio_stream_player_2d.play()
	visible = false
	picked_up.emit()
	PlayerHud.update_display_pickup (_name)
	await audio_stream_player_2d.finished
	#item_drop.clear_drop_value()
	queue_free()
	pass
	
func _update_texture() -> void:
	if item_data and sprite_2d:
		sprite_2d.texture = item_data.texture
	pass

func bounce() -> void:
	$AnimationPlayer.play("bounce")
	
