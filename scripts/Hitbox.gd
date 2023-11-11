class_name Hitbox;
extends Area2D;

@export var attrs: HitboxAttributesResource;

@export var scaling := 1.0;

func _ready() -> void:
	connect("area_entered", _on_area_entered);

func _on_area_entered(other: Area2D) -> void:
	if other is Hurtbox:
		other.register_hit(self);

func get_hit_data() -> HitDataResource:
	if randf() < attrs.crit_chance:
		return HitDataResource.new(
			(attrs.base_damage * attrs.crit_multiplier) * (1.0 + attrs.spread) * scaling,
			true,
			attrs.knockback,
			owner.global_position
		);
	else:
		return HitDataResource.new(
			attrs.base_damage * (1.0 + attrs.spread) * scaling,
			false,
			attrs.knockback,
			owner.global_position
			);
