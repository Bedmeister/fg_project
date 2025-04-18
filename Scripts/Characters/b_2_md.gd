extends CharacterBody2D

var direction: Vector2
var SPEED = 8000.0
const JUMP_VELOCITY = -2000.0

var inputs: Array = [5]
var input_movement: int


func input_calc():
	if inputs[-1] != input_movement:
		inputs.append(input_movement)


func get_movement_input():
	if Input.is_action_pressed("Crouch") and Input.is_action_pressed("Move_left"):
		input_movement = 1
	
	elif Input.is_action_pressed("Crouch") and Input.is_action_pressed("Move_right"):
		input_movement = 3
	
	elif Input.is_action_pressed("Jump") and Input.is_action_pressed("Move_left"):
		input_movement = 7
	
	elif Input.is_action_pressed("Jump") and Input.is_action_pressed("Move_right"):
		input_movement = 9
	
	elif Input.is_action_pressed("Crouch"):
		input_movement = 2
	
	elif Input.is_action_pressed("Jump"):
		input_movement = 8
	
	elif Input.is_action_pressed("Move_left"):
		input_movement = 4
		
	elif Input.is_action_pressed("Move_right"):
		input_movement = 6
		
	else:
		input_movement = 5

func _physics_process(delta: float) -> void:
	get_movement_input()
	input_calc()

func _on_idle_state_entered() -> void:
	$Player_animations.play("Idle")
	print("idle")

func _on_idle_state_processing(delta: float) -> void:
	#if walking
	if Input.is_action_pressed("Movement"):
		$StateChart.send_event("to_walk")
		
	#if jumping
	if Input.is_action_pressed("Jump"):
		if Input.is_action_pressed("Crouch"):
			return
		else:
			$StateChart.send_event("to_jump")
		
	#if crouching
	if Input.is_action_pressed("Crouch"):
		if Input.is_action_pressed("Jump"):
			return
		else:
			$StateChart.send_event("to_crouch")

func _on_idle_state_physics_processing(delta: float) -> void:
	pass



func _on_walk_state_entered() -> void:
	$Player_animations.play("Walk")
	print("walk")


func _on_walk_state_processing(delta: float) -> void:
	#if not moving
	if velocity == Vector2(0, 0):
		$StateChart.send_event("to_idle")
	#if jumping
	if abs(velocity.y) > 0:
		$StateChart.send_event("to_jump")
		
	#if crouching
	if Input.is_action_pressed("Crouch"):
		$StateChart.send_event("to_crouch")
	

func _on_walk_state_physics_processing(delta: float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Move_left", "Move_right")
	if direction:
		velocity.x = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_jump_state_entered() -> void:
	print("jump")
	$Player_animations.play("Jump")
	#if idle
	if inputs[-1] == 8:
		direction.x = 0
	#if moving left
	if inputs[-1] == 7:
		direction.x = -1
	#if moving right
	if inputs[-1] == 9:
		direction.x = 1
	velocity.y = JUMP_VELOCITY
func _on_jump_state_processing(delta: float) -> void:
	if self.is_on_floor():
		#if not moving on floor
		if velocity.x == 0:
			$StateChart.send_event("to_idle")
		elif abs(velocity.x) > 0:
			$StateChart.send_event("to_walk")
	if Input.is_action_just_pressed("Jump"):
		$StateChart.send_event("to_double_jump")
func _on_jump_state_physics_processing(delta: float) -> void:
	velocity += get_gravity()
	velocity.x = (direction.x * 5) * SPEED * delta
	move_and_slide()

func _on_double_jump_state_entered() -> void:
	print("double jump")
	#if idle
	if inputs[-1] == 8:
		direction.x = 0
	#if moving left
	if inputs[-1] == 7:
		direction.x = -1
	#if moving right
	if inputs[-1] == 9:
		direction.x = 1
	velocity.y = JUMP_VELOCITY
func _on_double_jump_state_processing(delta: float) -> void:
	if self.is_on_floor():
		#if not moving on floor
		if velocity.x == 0:
			$StateChart.send_event("to_idle")
		elif abs(velocity.x) > 0:
			$StateChart.send_event("to_walk")
func _on_double_jump_state_physics_processing(delta: float) -> void:
	velocity += get_gravity()
	velocity.x = (direction.x * 5) * SPEED * delta
	move_and_slide()


func _on_crouch_state_entered() -> void:
	print("crouch")
func _on_crouch_state_processing(delta: float) -> void:
	if !Input.is_action_pressed("Crouch"):
		$StateChart.send_event("to_idle")
	if Input.is_action_pressed("Jump"):
		$StateChart.send_event("to_idle")
func _on_crouch_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.
