extends Shakable

var type := 0;

func _ready() -> void:
	sprite = $Sprite2D;
	particles = $GPUParticles2D;

	$Area2D.body_entered.connect(on_body_entered);
	$Area2D.area_entered.connect(on_area_entered);

func on_body_entered(_body: Node2D) -> void:
	animate_shake(30.0, 1.3, 0.95);

func on_area_entered(other: Area2D) -> void:
	if other is Hitbox and other.monitoring:
		animate_shake(30.0, 1.3, 0.95);
