extends CharacterBody2D

var jump: bool = false

var input_movement
var inputs = [0] #each input adds to this which allows special inputs

var SPEED: float = 8000.0 * 1.5
var DASH_SPEED: float = 8000.0 * 2.0
var JUMP_VELOCITY: float = -100000.0 * 1.5
var BACK_DASH: float = -8000
var AIR_DASH: float = 10000.0

func input_calc():
	if inputs[-1] != input_movement:
		inputs.append(input_movement)

func get_movement_input():
	if Input.is_action_pressed("dir_2") and Input.is_action_pressed("dir_4"):
		input_movement = 1
	
	elif Input.is_action_pressed("dir_2") and Input.is_action_pressed("dir_6"):
		input_movement = 3
	
	elif Input.is_action_pressed("dir_8") and Input.is_action_pressed("dir_4"):
		
		input_movement = 7
	
	elif Input.is_action_pressed("dir_8") and Input.is_action_pressed("dir_6"):
		
		input_movement = 9
	
	elif Input.is_action_pressed("dir_2"):
		input_movement = 2
	
	elif Input.is_action_pressed("dir_8"):
		
		input_movement = 8
	
	elif Input.is_action_pressed("dir_4"):
		input_movement = 4
		
	elif Input.is_action_pressed("dir_6"):
		input_movement = 6
		if Input.is_action_pressed("dash"):
			SPEED = DASH_SPEED
		else:
			SPEED = 8000.0 * 1.5
	else:
		input_movement = 5

func double_jump():
	if Input.is_action_just_pressed("dir_8") and !is_on_floor() and jump == false:
		jump = true
		velocity.y = JUMP_VELOCITY
	elif is_on_floor():
		jump = false

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	get_movement_input()
	input_calc()
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("dir_8") and is_on_floor():
		velocity.y = JUMP_VELOCITY * delta	
	if Input.is_action_just_released("dir_8") and !is_on_floor() and jump == false:
		jump = true
		velocity.y = JUMP_VELOCITY * delta
	var direction := Input.get_axis("dir_4", "dir_6")
	if Input.is_action_pressed("dir_2") and is_on_floor():
		velocity = Vector2.ZERO
	else:
		if direction:
			velocity.x = direction * SPEED * delta
		else:
			velocity.x = 0
	
	if is_on_floor():
		jump = false
	
	move_and_slide()
