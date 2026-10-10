extends TextureButton

@export var fish_name: String = "Goldfish"
@export var clicks_required: int = 5
@export var time_limit: float = 5.0
@export var hop_interval: float = 0.65

func start() -> void:
	disabled = false
	show()
	$HopTimer.start(hop_interval)

func stop() -> void:
	$HopTimer.stop()
	disabled = true
	hide()

func hop() -> void:
	if disabled or not visible:
		return
	var available_space: Vector2 = get_parent().size - size
	position.x = randf_range(0.0, available_space.x)
	position.y = randf_range(0.0, available_space.y)

func _on_pressed():
	$CPUParticles2D.emitting = true
	Global.fish_clicked.emit()

func _on_hop_timer_timeout() -> void:
	hop()
