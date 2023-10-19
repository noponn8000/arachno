class_name Hitbox;
extends Area2D;

var damage := 5;
var knockback := 30.0;

func _ready() -> void:
	connect("area_entered", _on_area_entered);
	
func _on_area_entered(other: Area2D) -> void:
	if other is Hurtbox:
		other.register_hit(self);
