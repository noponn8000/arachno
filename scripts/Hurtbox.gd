class_name Hurtbox
extends Area2D;

signal damage_taken (hitbox);

func register_hit(hitbox: Hitbox) -> void:
	emit_signal("damage_taken", hitbox);
