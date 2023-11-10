extends CanvasLayer

@onready var inventory: Control = $Inventory

var inventory_animation_running := false;

func _ready() -> void:
	inventory.visible = false;

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory_toggle"):
		toggle_inventory();

func toggle_inventory() -> void:
	if inventory_animation_running:
		return;

	inventory_animation_running = true;

	var paused = get_tree().paused;

	if paused:
		get_tree().paused = false;
		inventory.animate(false);

		await inventory.animation_finished;
	else:
		inventory.animate(true);
		await inventory.animation_finished;

		get_tree().paused = !get_tree().paused;

	inventory_animation_running = false;
