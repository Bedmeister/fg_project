extends CharacterBody2D


@export_category("character stats")
@export_group("Health and Defence stats")
@export var health: float = 1000.0
@export var defense_rating: float = 4.0
@export var guts_rating: float = 4.0
@export var juggle_rating: float = 2.0
@export_group("Speed stats")
@export var SPEED = 8000.0
@export var JUMP_VELOCITY = -2000.0
@export_group("Attack stats")
@export var slash_rating: float = 4
@export_subgroup("Punch")
@export var punch_attack_damage: float = 10.0
@export var punch_attack_rating: float = 1
@export var punch_launch_rating: float = 0.1
@export var punch_counter_rating: float = 1.1
@export_subgroup("Kick")
@export var kick_attack_damage: float = 20.0
@export var kick_attack_rating: float = 1
@export var kick_launch_rating: float = 0.5
@export var kick_counter_rating: float = 1.3
@export_subgroup("Slash")
@export var slash_attack_damage: float = 30.0
@export var slash_attack_rating: float = 1
@export var slash_launch_rating: float = 0.5
@export var slash_counter_rating: float = 1.5
@export_subgroup("Heavy Slash")
@export var heavy_attack_damage: float = 40.0
@export var heavy_attack_rating: float = 1
@export var heavy_launch_rating: float = 1
@export var heavy_counter_rating: float = 1.8
@export_subgroup("Crouch Punch")
@export var crouch_punch_attack_damage: float = 5.0
@export var crouch_punch_attack_rating: float = 1
@export var crouch_punch_launch_rating: float = 0.1
@export var crouch_punch_counter_rating: float = 1.1
@export_subgroup("Crouch Kick")
@export var crouch_kick_attack_damage: float = 15.0
@export var crouch_kick_attack_rating: float = 1
@export var crouch_kick_launch_rating: float = 0.3
@export var crouch_kick_counter_rating: float = 1.3
@export_subgroup("Crouch Slash")
@export var crouch_slash_attack_damage: float = 25.0
@export var crouch_slash_attack_rating: float = 1
@export var crouch_slash_launch_rating: float = 0.7
@export var crouch_slash_counter_rating: float = 1.6
@export_subgroup("Crouch Heavy Slash")
@export var crouch_heavy_attack_damage: float = 40.0
@export var crouch_heavy_attack_rating: float = 1.0
@export var crouch_heavy_launch_rating: float = 1.0
@export var crouch_heavy_counter_rating: float = 2
@export_subgroup("Air Punch")
@export var air_punch_attack_damage: float = 10.0
@export var air_punch_attack_rating: float = 1
@export var air_punch_launch_rating: float = 0.1
@export var air_punch_counter_rating: float = 1.2
@export_subgroup("Air Kick")
@export var air_kick_attack_damage: float = 20.0
@export var air_kick_attack_rating: float = 1
@export var air_kick_launch_rating: float = 0.5
@export var air_kick_counter_rating: float = 1.5
@export_subgroup("Air Slash")
@export var air_slash_attack_damage: float = 30.0
@export var air_slash_attack_rating: float = 1
@export var air_slash_launch_rating: float = 0.7
@export var air_slash_counter_rating: float = 1.7
@export_subgroup("Air Heavy Slash")
@export var air_heavy_attack_damage: float = 40.0
@export var air_heavy_attack_rating: float = 1
@export var air_heavy_launch_rating: float = 0.7
@export var air_heavy_counter_rating: float = 1.9
@export_group("Bool stats")
@export var fenrir_mode: bool = false
@export var god_mode: bool = false
@export_group("controls")
@export var controlled: bool
@export var state: AtomicState


var direction: Vector2




var inputs: Array = [5]
var input_movement: int

@export_group("players")
@export var enemy: CharacterBody2D

var prev_box: String
var new_box: String

func check_attack():
	pass

func input_calc():
	if inputs[-1] != input_movement:
		inputs.append(input_movement)


func get_movement_input():
	if Input.is_action_pressed("Crouch") and Input.is_action_pressed("Move_left"):
		#if enemy is to the right
		if check_enemy_position(enemy):
			input_movement = 1
		elif !check_enemy_position(enemy):
			input_movement = 3
	elif Input.is_action_pressed("Crouch") and Input.is_action_pressed("Move_right"):
		if check_enemy_position(enemy):
			input_movement = 3
		elif !check_enemy_position(enemy):
			input_movement = 1
	elif Input.is_action_pressed("Jump") and Input.is_action_pressed("Move_left"):
		input_movement = 7
	elif Input.is_action_pressed("Jump") and Input.is_action_pressed("Move_right"):
		input_movement = 9
	elif Input.is_action_pressed("Crouch"):
		input_movement = 2
	elif Input.is_action_pressed("Jump"):
		input_movement = 8
	elif Input.is_action_pressed("Move_left"):
		if check_enemy_position(enemy):
			input_movement = 4
		elif !check_enemy_position(enemy):
			input_movement = 6
	elif Input.is_action_pressed("Move_right"):
		if check_enemy_position(enemy):
			input_movement = 6
		elif !check_enemy_position(enemy):
			input_movement = 4
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
		return true
		
	
	#if to the left
	elif enemy.global_position.x < self.global_position.x:
		$Player_animations.flip_h = false
		change_punch_position_left()
		return false
func change_punch_position_left():
	$Attacks/punch.position.x = -81.75
func change_punch_position_right():
	$Attacks/punch.position.x = 81.75





func _on_idle_state_entered() -> void:
	$Idle.disabled = false
	$Hit_Box/Idle.disabled = false
	$Grab_Box/Idle.disabled = false
	$Player_animations.play("Idle")
	print("idle")
func _on_idle_state_processing(delta: float) -> void:
	if controlled:
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
		
		#if state set to death
		if state == $StateChart/Root/Death:
			$StateChart.send_event("to_death")
		
func _on_idle_state_physics_processing(delta: float) -> void:
	#if enemy is there
	if check_for_enemy():
		check_enemy_position(enemy)
func _on_idle_state_exited() -> void:
	$Idle.disabled = true
	$Hit_Box/Idle.disabled = true
	$Grab_Box/Idle.disabled = true
	prev_box = "Idle"



func _on_walk_state_entered() -> void:
	$Idle.disabled = false
	$Hit_Box/Idle.disabled = false
	$Grab_Box/Idle.disabled = false
	
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
func _on_walk_state_exited() -> void:
	$Idle.disabled = true
	$Hit_Box/Idle.disabled = true
	$Grab_Box/Idle.disabled = true
	prev_box = "Idle"

func _on_jump_state_entered() -> void:
	$Jump.disabled = false
	$Hit_Box/Jump.disabled = false
	$Grab_Box/Jump.disabled = false
	
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
func _on_jump_state_exited() -> void:
	$Jump.disabled = true
	$Hit_Box/Jump.disabled = true
	$Grab_Box/Jump.disabled = true
	prev_box = "Jump"

func _on_double_jump_state_entered() -> void:
	$Jump.disabled = false
	$Hit_Box/Jump.disabled = false
	$Grab_Box/Jump.disabled = false
	
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
func _on_double_jump_state_exited() -> void:
	$Jump.disabled = true
	$Hit_Box/Jump.disabled = true
	$Grab_Box/Jump.disabled = true
	prev_box = "Jump"

func _on_crouch_state_entered() -> void:
	$Crouch.disabled = false
	$Hit_Box/Crouch.disabled = false
	$Grab_Box/Crouch.disabled = false
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
func _on_crouch_state_exited() -> void:
	$Crouch.disabled = true
	$Hit_Box/Crouch.disabled = true
	$Grab_Box/Crouch.disabled = true
	prev_box = "Crouch"

func _on_step_dash_state_entered() -> void:
	$Idle.disabled = false
	$Hit_Box/Idle.disabled = false
	$Grab_Box/Idle.disabled = false
	
	print("Step Dash!")
	if check_enemy_position(enemy):
		direction.x = 10
	if !check_enemy_position(enemy):
		direction.x = -10
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
func _on_step_dash_state_exited() -> void:
	$Idle.disabled = true
	$Hit_Box/Idle.disabled = true
	$Grab_Box/Idle.disabled = true
	prev_box = "Idle"

func _on_hitstun_state_entered() -> void:
	print("hit")
func _on_hitstun_state_processing(delta: float) -> void:
	#if health = 0
	if health <= 0:
		$StateChart.send_event("to_death")
func _on_hitstun_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.
func _on_hitstun_state_exited() -> void:
	pass # Replace with function body.

func _on_juggled_state_entered() -> void:
	print("juggled")
func _on_juggled_state_processing(delta: float) -> void:
	#if landed and has health
	if health > 0 and is_on_floor():
		$StateChart.send_event("to_knocked_down")
	
	#if health = 0 and lands
	if health <= 0 and is_on_floor():
		$StateChart.send_event("to_death")
func _on_juggled_state_physics_processing(delta: float) -> void:
	velocity += get_gravity()
	velocity.x = (direction.x * 3) * SPEED * delta
	move_and_slide()
func _on_juggled_state_exited() -> void:
	pass # Replace with function body.


func _on_death_state_entered() -> void:
	print("death")
	self.set_collision_layer_value(20, false)
func _on_death_state_processing(delta: float) -> void:
	pass # Replace with function body.
func _on_death_state_physics_processing(delta: float) -> void:
	velocity += get_gravity()
	move_and_slide()
func _on_death_state_exited() -> void:
	pass # Replace with function body.


func _on_knocked_down_state_entered() -> void:
	print("knocked_down")
func _on_knocked_down_state_processing(delta: float) -> void:
	pass # Replace with function body.
func _on_knocked_down_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.
func _on_knocked_down_state_exited() -> void:
	pass # Replace with function body.


func _on_attack_state_entered() -> void:
	print("attack")
func _on_attack_state_processing(delta: float) -> void:
	pass # Replace with function body.
func _on_attack_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.
func _on_attack_state_exited() -> void:
	prev_box = prev_box
