class_name InventoryData extends Resource

signal equipment_changed

@export var slots : Array [ SlotData ]
var equipment_slot_count : int = 4

func _init() -> void:
	connect_slots()
	pass

func inventory_slots() -> Array[SlotData]:
	return slots.slice(0,-equipment_slot_count)

func equipment_slots() -> Array[SlotData]:
	return slots.slice(-equipment_slot_count, slots.size())

func add_item ( item : ItemData, count : int = 1 ) -> bool:
	for s in slots:
		if s:
			if s.item_data == item:
				# Will want to add max count limit checking
				s.quantity += count 
				return true
	
	for i in inventory_slots().size():
		if slots[ i ] == null:
			var new = SlotData.new()
			new.item_data = item
			# Will want to add max count limit checking
			new.quantity = count
			slots [ i ] = new
			new.changed.connect( slot_changed )
			return true
	# Inventory full so return false.
	return false

#func remove_item ( item : ItemData, count : int = 1) -> void:
	#for s in slots:
		#if s:
			#if s.item_data == item:
				## Will want to add max count limit checking
				#s.quantity -= count 
				#if s.quantity <= 0:
					#
	#pass

func connect_slots() -> void:
	for s in slots:
		if s: 
			s.changed.connect( slot_changed )
			
func slot_changed () -> void:
	for s in slots:
		if s:
			if s.quantity < 1:
				s.changed.disconnect( slot_changed )
				var index = slots.find( s )
				slots[ index ] = null
				emit_changed()
	pass

func get_save_data () -> Array:
	var item_save : Array = []
	for i in slots.size():
		item_save.append( item_to_save( slots[i]) )
	return item_save
	
func item_to_save ( slot : SlotData ) -> Dictionary:
	var result = { item = '', quantity = 0 }
	if slot != null:
		result.quantity=slot.quantity
		if slot.item_data != null:
			result.item = slot.item_data.resource_path
	return result

func parse_save_data ( save_data : Array ) -> void:
	var array_size = slots.size()
	slots.clear()
	slots.resize( array_size )
	for i in save_data.size():
		slots[ i ] = item_from_save( save_data[ i ] )
	connect_slots()
	pass
	
func item_from_save ( save_object : Dictionary ) -> SlotData:
	if save_object.item == '':
		return null
	var new_slot : SlotData = SlotData.new()
	new_slot.item_data = load( save_object.item )
	new_slot.quantity = int( save_object.quantity )
	return new_slot

func use_item ( item : ItemData, count : int = 1 ) -> bool:
	for s in slots:
		if s:
			if s.item_data == item and s.quantity >= count:
				s.quantity-=count
				if s.quantity<=0:
					print ("BUG CONDITION!")
				return true
	return false

func equip_item ( slot : SlotData ) -> void:
	if slot == null or not slot.item_data is EquipableItemData:
		return
	
	var item : EquipableItemData = slot.item_data
	var slot_index : int = slots.find ( slot )
	var equipment_index : int = slots.size() - equipment_slot_count
	
	match item.type:
		EquipableItemData.Type.ARMOR:
			equipment_index+=0
		EquipableItemData.Type.WEAPON:
			equipment_index+=1
		EquipableItemData.Type.AMULET:
			equipment_index+=2
		EquipableItemData.Type.RING:
			equipment_index+=0
	
	var unequiped_slot : SlotData = slots[ equipment_index ]
	
	slots[ slot_index ] = unequiped_slot
	slots[ equipment_index ] = slot
	
	equipment_changed.emit()
	PauseMenu.focused_item_changed( unequiped_slot )
	pass

func get_attack_bonus () -> int:
	return get_equipment_bonus( EquipableItemModifier.Type.ATTACK )

func get_attack_bonus_diff( item : EquipableItemData ) -> int:
	var before : int = get_attack_bonus()
	var after : int = get_equipment_bonus( EquipableItemModifier.Type.ATTACK, item)
	return after-before
	
func get_defense_bonus () -> int:
	return get_equipment_bonus( EquipableItemModifier.Type.DEFENSE )

func get_defense_bonus_diff( item : EquipableItemData ) -> int:
	var before : int = get_attack_bonus()
	var after : int = get_equipment_bonus( EquipableItemModifier.Type.DEFENSE, item)
	return after-before
	
func get_equipment_bonus ( bonus_type : EquipableItemModifier.Type, compare : EquipableItemData = null ) -> int:
	var bonus : int = 0
	
	for s in equipment_slots():
		if s == null:
			continue
		var e : EquipableItemData = s.item_data
		if compare:
			if e.type == compare.type:
				e=compare
		for m in e.modifiers:
			if m.type == bonus_type:
				bonus += m.value
	
	return bonus
