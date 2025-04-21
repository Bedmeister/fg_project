extends CharacterBody2D



var direction: Vector2
var SPEED = 8000.0
const JUMP_VELOCITY = -2000.0

var inputs: Array = [5]
var input_movement: int

@export_group("players")
@export var enemy: CharacterBody2D



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
	

func check_for_enemy():
	if get_node_or_null("Node/Player2") == null:
		return false
	else:
		return true

func check_enemy_position(enemy: CharacterBody2D):
	#if enemy is to the right
	if enemy.global_position.x > self.global_position.x:
		$Player_animations.flip_h = true
		change_punch_position_right()
	
	#if to the left
	elif enemy.global_position.x < self.global_position.x:
		$Player_animations.flip_h = false
		change_punch_position_left()
func change_punch_position_left():
	$Attacks/punch.position.x = -81.75
func change_punch_position_right():
	$Attacks/punch.position.x = 81.75

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
	#if punching
	if Input.is_action_just_pressed("Punch"):
		$StateChart.send_event("to_punch")
func _on_idle_state_physics_processing(delta: float) -> void:
	#if enemy is there
	if check_for_enemy():
		check_enemy_position(enemy)



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
	if Input.is_action_just_pressed("Dash") and inputs[-1] == 6:
		$StateChart.send_event("to_dash")
	#if punching
	if Input.is_action_just_pressed("Punch"):
		$StateChart.send_event("to_punch")
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
	check_enemy_position(enemy)
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
	check_enemy_position(enemy)
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
	#if no longer crouching
	if !Input.is_action_pressed("Crouch"):
		$StateChart.send_event("to_idle")
	#if attempting to jump while crouching
	if Input.is_action_pressed("Jump"):
		$StateChart.send_event("to_idle")
func _on_crouch_state_physics_processing(delta: float) -> void:
	velocity = Vector2.ZERO
	check_enemy_position(enemy)
	move_and_slide()


func _on_step_dash_state_entered() -> void:
	print("Step Dash!")
	direction.x = 10
	$timers/dash.start()
func _on_step_dash_state_processing(delta: float) -> void:
	pass
func _on_step_dash_state_physics_processing(delta: float) -> void:
	velocity.x = direction.x * SPEED * delta
	move_and_slide()
func _on_timer_timeout() -> void:
	print("timeout")
	direction.x = 0
	$StateChart.send_event("to_idle")



func _on_punch_state_entered() -> void:
	#play punch animation
	print("punch")
	$Attacks_ani.play("punch")
	$timers/punch/punch.start()
func _on_punch_timeout() -> void:
	$StateChart.send_event("to_idle")
