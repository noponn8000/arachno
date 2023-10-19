extends PointLight2D

@export var lifetime := 3.0;

var speed := 10.0;

func _ready() -> void:
	get_tree().create_timer(lifetime).connect("timeout", disappear);
	
func _process(delta: float) -> void:
	position += transform.x * speed * delta;

func disappear() -> void:
	var tween = get_tree().create_tween();
	
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5);
	
	await tween.finished;
	queue_free();
