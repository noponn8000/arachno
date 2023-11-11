class_name Interactable;
extends Node2D;

# A generic component which can be inherited from
# for entities which can be interacted with (altars, NPCs)

@export var area: Area2D;
@export var interaction_box_scene: PackedScene = load("res://scenes/interaction_box.tscn");
@export var interaction_box_offset: Vector2 = Vector2(0, -12);
@export var use_interaction_box := true;

var activated := false;
var interaction_box: InteractionBox;

func _ready() -> void:
	if area == null:
		area = get_child(0);

	area.body_entered.connect(on_body_entered);
	area.body_exited.connect(on_body_exited);

	if use_interaction_box:
		interaction_box = interaction_box_scene.instantiate();
		add_child(interaction_box);
		interaction_box.position = interaction_box_offset;

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and activated:
		interact();

func interact() -> void:
	pass;

func on_body_entered(body: Node2D) -> void:
	if not interaction_box.active:
		return;

	if body.is_in_group("player"):
		activated = true;

		if use_interaction_box:
			interaction_box.activate();

func on_body_exited(body: Node2D) -> void:
	if not interaction_box.active:
		return;

	if body.is_in_group("player"):
		activated = false;

		if use_interaction_box:
			interaction_box.deactivate();
