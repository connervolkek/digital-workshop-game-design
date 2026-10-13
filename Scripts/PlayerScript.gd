extends CharacterBody2D

var can_move = true
var can_interact = true
#Add a speed variable here!




func _physics_process(_delta: float) -> void:
	if can_move:
		handle_movement()
		handle_animation()
	if can_interact:
		handle_interaction()



## Replace the function below with the code snippet in the slides!
func handle_movement():
	pass










func _ready() -> void:
	Global.fishing_closed.connect(stop_fishing)

func handle_interaction():
	if Input.is_action_just_pressed("Interact"):
		if $FishingRay.is_colliding():
			start_fishing()

func start_fishing():
	$AnimatedSprite2D.stop()
	can_move = false
	can_interact = false
	velocity = Vector2.ZERO
	Global.fishing_opened.emit()

func stop_fishing():
	can_move = true
	can_interact = true


func handle_animation():
	#Rraycast Direction Changes
	var move_direction = Input.get_vector("Left", "Right", "Up", "Down")
	if move_direction == Vector2.ZERO:
		$AnimatedSprite2D.stop()
		return
	var facing_direction = move_direction.normalized()
	$FishingRay.target_position = facing_direction * 40
	if $FishingRay.is_colliding():
		$"fishing label".visible = true
	else:
		$"fishing label".visible = false
	# Animation Logic - Note: this is NOT the best way to do this! 
	if Input.is_action_pressed("Right"):
		$AnimatedSprite2D.play("walk_right")
	elif Input.is_action_pressed("Left"):
		$AnimatedSprite2D.play("walk_left")
	elif Input.is_action_pressed("Up"):
		$AnimatedSprite2D.play("walk_up")
	elif Input.is_action_pressed("Down"):
		$AnimatedSprite2D.play("walk_down")
	else:
		$AnimatedSprite2D.stop()
