class_name Interactable;
extends Node2D;

# A generic component which can be inherited from
# for entities which can be interacted with (altars, NPCs)

@export var area: Area2D;

var activated := false;

func _ready() -> void:
	if area == null:
		area = get_child(0);

	area.area_entered.connect(on_area_entered);
	area.area_exited.connect(on_area_exited);

func interact() -> void:
	pass

func on_area_entered(other: Area2D) -> void:
	activated = true;

func on_area_exited(other: Area2D) -> void:
	activated = false;
