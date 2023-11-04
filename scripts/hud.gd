extends CanvasLayer

@onready var inventory: Control = $Inventory

func _ready() -> void:
	inventory.visible = false;

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory_toggle"):
		toggle_inventory();

func toggle_inventory() -> void:
	get_tree().paused = !get_tree().paused;
	inventory.visible = !inventory.visible;
