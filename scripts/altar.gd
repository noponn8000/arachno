extends Interactable

@export var item: InventoryItem;

@onready var anim := $AnimationPlayer;

func interact() -> void:
	if not item:
		return;

	interaction_box.interact();
	anim.play("gem_acquire");
	remove_child(item);
	Global.player_inventory.add_inventory_item(item);

	item = null;
