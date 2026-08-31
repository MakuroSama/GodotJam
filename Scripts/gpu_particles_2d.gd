extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_particle_material()
	one_shot = true
	emitting = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func splatter(splatterAmount):
	amount = splatterAmount*10
	restart()
	emitting = true

func setup_particle_material():
	var mat = ParticleProcessMaterial.new()
	
	# Burst outward from impact point
	mat.direction = Vector3(0, -1, 0)
	mat.spread = 180.0  # full spread for splatter
	mat.initial_velocity_min = 40.0
	mat.initial_velocity_max = 150.0
	
	# Gravity pulls droplets down
	mat.gravity = Vector3(0, 400, 0)
	
	# Small, blocky sizes for pixel look
	mat.scale_min = 1.0
	mat.scale_max = 3.0
	
	# Fade and shrink over lifetime
	mat.color = Color(0.6, 0.0, 0.0, 1.0)
	
	# Damping so droplets slow down and "stick"
	mat.damping_min = 20.0
	mat.damping_max = 40.0
	
	process_material = mat
	amount = 24
	lifetime = 1
	explosiveness = 1.0  # all particles burst at once
