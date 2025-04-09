extends CharacterBody2D

#add jump, dash, and air dash next

#variables
var direction: Vector2i 
var jump: bool = false

var input_movement
var inputs = [0] #each input adds to this which allows special inputs


var SPEED: float = 8000.0
var DASH_SPEED: float = SPEED * 1.8
var JUMP_VELOCITY: float = -10000.0
var BACK_DASH: float = -5000
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
			SPEED = 8000.0
	else:
		input_movement = 5

		

		

		



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.

	get_movement_input()
	velocity = direction * SPEED * delta
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("dir_8") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("dir_4"):
		if Input.is_action_just_pressed("dash"):
			velocity.x += BACK_DASH

	move_and_slide()
	
	
	input_calc()
