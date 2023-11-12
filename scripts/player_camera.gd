extends Camera2D

var noise_i := 0.0;
var shake_strength := 0.0;
var shake_decay := 0.0;
var shake_speed := 0.0;
var shaking := false;

@onready var noise := FastNoiseLite.new();

func shake(strength: float, decay: float, speed: float) -> void:
	shake_decay = decay;
	shake_speed = speed;
	shake_strength = strength;
	shaking = true;

func _process(delta: float) -> void:
	if not shaking:
		return;

	# Fade out the intensity over time
	shake_strength = move_toward(shake_strength, 0.0, shake_decay * delta);
	if shake_strength == 0:
		shaking = false;

	# Shake by adjusting camera.offset so we can move the camera around the level via it's position
	offset = get_noise_offset(delta);

func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * shake_speed;
	# Set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength
	);
