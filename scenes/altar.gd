extends Interactable

@export var item: InventoryItem;

func interact() -> void:
	interaction_box.interact();
	remove_child(item);
	Global.player_inventory.add_inventory_item(item);
