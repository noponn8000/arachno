extends Interactable

@export var item: InventoryItem;

func interact() -> void:
	Global.player_inventory.add_item(item);
