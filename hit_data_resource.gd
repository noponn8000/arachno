class_name HitDataResource;
extends Resource;

@export var damage: int;
@export var critical: bool;
@export var knockback: float;
@export var origin: Vector2;

func _init(dmg: int, crit: bool, knockback: float = 0.0, origin: Vector2 = Vector2.ZERO) -> void:
	self.origin = origin;
	self.damage = dmg;
	self.critical = crit;
	self.knockback = knockback;
