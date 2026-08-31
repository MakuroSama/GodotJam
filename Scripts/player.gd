extends CharacterBody2D
signal cameraShake(trauma)
signal shootRequestAccept
signal died
signal takeDamage(damage)
var direction
@export var FRICTION_LERP_WEIGHT := 30
# --- fall damage ---
@export var max_health := 100.0
@export var fall_damage_min_speed := 600.0   # below this fall speed, no damage at all
@export var fall_damage_max_speed := 1600.0  # at/above this speed, damage is capped
@export var fall_damage_max := 50.0          # damage dealt at max_speed or higher

var health := max_health
var was_on_floor := true
func _physics_process(delta: float) -> void:
	direction = get_global_mouse_position() - global_position
	$Gun.rotation = direction.angle()
	$Gun.flip_v = direction.x < 0
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.x = lerp(velocity.x, 0.0, clamp(FRICTION_LERP_WEIGHT * delta, 0.0, 1.0))
	
	var was_falling_speed := velocity.y  # capture before move_and_slide can zero it out on landing
	move_and_slide()
	# landed this frame?
	if is_on_floor() and not was_on_floor:
		cameraShake.emit(was_falling_speed)
		_apply_fall_damage(was_falling_speed)

	was_on_floor = is_on_floor()
func _apply_fall_damage(fall_speed: float) -> void:
	if fall_speed < fall_damage_min_speed:
		return  # landed softly, no damage

	var ratio = clamp(
		(fall_speed - fall_damage_min_speed) / (fall_damage_max_speed - fall_damage_min_speed),
		0.0, 1.0
	)
	var damage = ratio * fall_damage_max
	_take_damage(damage)
func _take_damage(amount: float) -> void:
	takeDamage.emit(amount)
	$GPUParticles2D.splatter(amount)
	health -= amount
	health = max(health, 0.0)
	print("Took ", amount, " fall damage. Health: ", health)
	if health <= 0.0:
		_die()

func _die() -> void:
	died.emit()
	$GPUParticles2D.splatter(256)
	print("Player died")
	$AnimatedSprite2D.hide()
	$Gun.hide()
	# queue_free(), reload scene, play death animation, etc.


func _on_canvas_layer_shoot_request() -> void:
	if is_on_floor():
		shootRequestAccept.emit()


func _on_canvas_layer_shoot(speed: Variant) -> void:
	velocity -= direction.normalized()*speed


func _on_canvas_layer_out_of_bullets() -> void:
	_die()
	pass # Replace with function body.
