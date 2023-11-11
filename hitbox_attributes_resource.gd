class_name HitboxAttributesResource;
extends Resource

@export var base_damage: int;
@export_range(1, 10, 0.1) var crit_multiplier: float;
@export_range(0, 1, 0.05) var crit_chance: float;
@export_range(0, 1, 0.05) var spread: float;
@export var knockback: float;
