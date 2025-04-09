extends CharacterBody2D


var SPEED = 200.0
var JUMP_VELOCITY = -500.0
var jump: bool = false







func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump = true
		if Input.is_action_pressed("ui_down"):
			velocity.y = JUMP_VELOCITY * 1.2
		else:
			velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("ui_accept") and !is_on_floor():
		if jump == false:
			velocity.y = JUMP_VELOCITY
			jump = true
	
	if self.is_on_floor() and !Input.is_action_just_pressed("ui_accept"):
		jump = false


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
