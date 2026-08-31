extends Sprite2D
signal shoot(strength)
@export var maxBullets = 10
@export var min_charge_time := 0.15
@export var max_charge_time := 1.2
@export var min_speed := 400.0
@export var max_speed := 3000.0

var is_charging := false
var charge_time := 0.0

var pointerMaxHeight = -30
var currentBullet = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentBullet = maxBullets
	$pointer.hide()
	pass # Replace with function body.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		$"..".shootRequest.emit()
	
	if is_charging:
		charge_time += delta
		$pointer.position.y = (charge_time/max_charge_time) * pointerMaxHeight
		charge_time = min(charge_time, max_charge_time)

	if Input.is_action_just_released("shoot"):
		if currentBullet <= 0:
			$"../HPBar".value = $"../HPBar".min_value
			$"..".outOfBullets.emit()
		elif is_charging:
			_fire()
		is_charging = false
		$pointer.hide()
func _fire() -> void:
	currentBullet -= 1
	var charge_ratio := 0.0
	if charge_time >= min_charge_time:
		charge_ratio = clamp(charge_time / max_charge_time, 0.0, 1.0)

	var speed = lerp(min_speed, max_speed, charge_ratio)
	$".."._shoot(speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass
