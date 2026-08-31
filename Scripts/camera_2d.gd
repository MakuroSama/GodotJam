extends Camera2D
@export var target: Node2D
@export_range(0.0, 1.0) var smoothing := 0.05   # Smaller values follow more slowly and smoothly
var trauma := 0.0
@export var trauma_decay := 0.8   # Decay per second
@export var max_offset := 12.0    # Maximum shake distance
func add_trauma(amount: float) -> void:
	trauma = minf(trauma + amount, 1.0)   # Add on impact (capped at 1.0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if trauma <= 0.0 :
		offset = Vector2.ZERO
		return
	trauma = maxf(trauma - trauma_decay * delta, 0.0)   # Decay over time
	var shake := trauma * trauma                          # Squaring makes strong shakes stand out
	offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * max_offset * shake
	


func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		return
	# Interpolation that keeps the follow speed constant across frame rates
	global_position = global_position.lerp(target.global_position, 1.0 - pow(smoothing, delta))


func _on_character_body_2d_camera_shake(trauma: Variant) -> void:
	add_trauma(trauma)
	pass # Replace with function body.
