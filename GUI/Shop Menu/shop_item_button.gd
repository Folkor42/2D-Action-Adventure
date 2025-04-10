class_name ShopItemButton extends Button

var item : ItemData

func setup_item (_item : ItemData ) -> void:
	item = _item
	print (item.name)
	$Label.text = item.name
	$PriceLabel.text = str( item.cost )
	$TextureRect.texture = item.texture
