class_name InventoryData extends Resource

@export var slots : Array [ SlotData ]

func _init() -> void:
	connect_slots()
	pass

func add_item ( item : ItemData, count : int = 1 ) -> bool:
	for s in slots:
		if s:
			if s.item_data == item:
				# Will want to add max count limit checking
				s.quantity += count 
				return true
	for i in slots.size():
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
