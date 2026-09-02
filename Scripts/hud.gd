extends CanvasLayer
signal shootRequest
signal shoot(speed)
signal outOfBullets
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameOverText.hide()
	$VBoxContainer/ButtonRetry.hide()
	$VBoxContainer/ButtonTitle.hide()
	$BulletCountText.text = "x" + str($ShootingController.currentBullet)
	$HPBar.value = $HPBar.max_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _shoot(speed) -> void:
	$BulletCountText.text = "x" + str( $ShootingController.currentBullet)
	shoot.emit(speed)
	pass

func _on_character_body_2d_shoot_request_accept() -> void:
	$ShootingController/pointer.show()
	$ShootingController.is_charging = true
	$ShootingController.charge_time = 0

func _on_character_body_2d_died() -> void:
	$GameOverText.show()
	$VBoxContainer/ButtonRetry.show()
	$VBoxContainer/ButtonTitle.show()
	pass # Replace with function body.

func _on_character_body_2d_take_damage(damage: Variant) -> void:
	$HPBar.value -= damage
	pass # Replace with function body.

# Reload the scene when the retry button is pressed.
func _on_button_retry_pressed() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.

# Pressing the button loads the title scene.
func _on_button_title_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/TitleScene.tscn")
	pass # Replace with function body.
