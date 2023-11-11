class_name HitDataResource;
extends Resource;

@export var damage: int;
@export var critical: bool;
@export var knockback: float;
@export var origin: Vector2;
@export var stun_time: float;

func _init(dmg: int, crit: bool, knockback: float = 0.0, origin: Vector2 = Vector2.ZERO, stun_time: float = 0.0) -> void:
	self.origin = origin;
	self.damage = dmg;
	self.critical = crit;
	self.knockback = knockback;
	self.stun_time = stun_time;
