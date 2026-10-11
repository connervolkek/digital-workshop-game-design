extends CharacterBody2D

var can_move = true
var can_interact = true
var speed = 200

func _physics_process(_delta: float) -> void:
	if can_move:
		handle_movement()
		handle_animation()
	if can_interact:
		handle_interaction()




func handle_movement():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("Right"):
		velocity.x += speed
	if Input.is_action_pressed("Left"):
		velocity.x -= speed
	if Input.is_action_pressed("Down"):
		velocity.y += speed
	if Input.is_action_pressed("Up"):
		velocity.y -= speed
	move_and_slide()

func handle_animation():
	#raycast direction changes
	var move_direction = Input.get_vector("Left", "Right", "Up", "Down")
	if move_direction == Vector2.ZERO:
		return
	var facing_direction = move_direction.normalized()
	$FishingRay.target_position = facing_direction * 40
	if $FishingRay.is_colliding():
		$"fishing label".visible = true
	else:
		$"fishing label".visible = false
	#animation logic here

func _ready() -> void:
	Global.fishing_closed.connect(stop_fishing)

func handle_interaction():
	if Input.is_action_just_pressed("Interact"):
		if $FishingRay.is_colliding():
			start_fishing()

func start_fishing():
	can_move = false
	can_interact = false
	velocity = Vector2.ZERO
	Global.fishing_opened.emit()

func stop_fishing():
	can_move = true
	can_interact = true
