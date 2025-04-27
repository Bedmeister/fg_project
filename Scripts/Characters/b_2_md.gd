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
@export var punch_launch_direction: Vector2 = Vector2i(0.5, -0.5)
@export_subgroup("Kick")
@export var kick_attack_damage: float = 20.0
@export var kick_attack_rating: float = 1
@export var kick_launch_rating: float = 0.5
@export var kick_counter_rating: float = 1.3
@export var kick_launch_direction: Vector2 = Vector2i(0.1, -2)
@export_subgroup("Slash")
@export var slash_attack_damage: float = 30.0
@export var slash_attack_rating: float = 1
@export var slash_launch_rating: float = 0.5
@export var slash_counter_rating: float = 1.5
@export var slash_launch_direction: Vector2 = Vector2i(0.5, -2)
@export_subgroup("Heavy Slash")
@export var heavy_attack_damage: float = 40.0
@export var heavy_attack_rating: float = 1
@export var heavy_launch_rating: float = 1
@export var heavy_counter_rating: float = 1.8
@export var heavy_launch_direction: Vector2 = Vector2i(2, -5)
@export_subgroup("Crouch Punch")
@export var crouch_punch_attack_damage: float = 5.0
@export var crouch_punch_attack_rating: float = 1
@export var crouch_punch_launch_rating: float = 0.1
@export var crouch_punch_counter_rating: float = 1.1
@export var crouch_punch_launch_direction: Vector2 = Vector2i(0.5, -0.5)
@export_subgroup("Crouch Kick")
@export var crouch_kick_attack_damage: float = 15.0
@export var crouch_kick_attack_rating: float = 1
@export var crouch_kick_launch_rating: float = 0.3
@export var crouch_kick_counter_rating: float = 1.3
@export var crouch_kick_launch_direction: Vector2 = Vector2i(0.5, -1)
@export_subgroup("Crouch Slash")
@export var crouch_slash_attack_damage: float = 25.0
@export var crouch_slash_attack_rating: float = 1
@export var crouch_slash_launch_rating: float = 0.7
@export var crouch_slash_counter_rating: float = 1.6
@export var crouch_slash_launch_direction: Vector2 = Vector2i(1, -5)
@export_subgroup("Crouch Heavy Slash")
@export var crouch_heavy_attack_damage: float = 40.0
@export var crouch_heavy_attack_rating: float = 1.0
@export var crouch_heavy_launch_rating: float = 1.0
@export var crouch_heavy_counter_rating: float = 2
@export var crouch_heavy_launch_direction: Vector2 = Vector2i(1, -1)
@export_subgroup("Air Punch")
@export var air_punch_attack_damage: float = 10.0
@export var air_punch_attack_rating: float = 1
@export var air_punch_launch_rating: float = 0.1
@export var air_punch_counter_rating: float = 1.2
@export var air_punch_launch_direction: Vector2 = Vector2i(0.5, -0.5)
@export_subgroup("Air Kick")
@export var air_kick_attack_damage: float = 20.0
@export var air_kick_attack_rating: float = 1
@export var air_kick_launch_rating: float = 0.5
@export var air_kick_counter_rating: float = 1.5
@export var air_kick_launch_direction: Vector2 = Vector2i(0.5, -0.5)
@export_subgroup("Air Slash")
@export var air_slash_attack_damage: float = 30.0
@export var air_slash_attack_rating: float = 1
@export var air_slash_launch_rating: float = 0.7
@export var air_slash_counter_rating: float = 1.7
@export var air_slash_launch_direction: Vector2 = Vector2i(0.5, -0.5)
@export_subgroup("Air Heavy Slash")
@export var air_heavy_attack_damage: float = 40.0
@export var air_heavy_attack_rating: float = 1
@export var air_heavy_launch_rating: float = 0.7
@export var air_heavy_counter_rating: float = 1.9
@export var air_heavy_launch_direction: Vector2 = Vector2i(0.5, -0.5)
@export_group("Bool stats")
@export var fenrir_mode: bool = false
@export var god_mode: bool = false
@export_group("controls")
@export var controlled: bool
@export var block: bool = false
@export var Score: int = 0

var launch_direction: Vector2

var hit_again: bool = false

var state: String
var time: Timer

var direction: Vector2

var jump: bool = false
var double_jump: bool = false


var inputs: Array = [5]
var input_movement: int
var crouching_inputs: Array = [1, 2, 3]
var standing_inputs: Array = [4, 5, 6]
var jumping_input: Array = [7, 8, 9]
var blocking_inputs: Array = [1, 4, 7]

@export_group("players")
@export var enemy: CharacterBody2D

var prev_box: String
var new_box: String
var attack: String
var attack_connected: bool = false

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

func get_attack_input():
	if Input.is_action_just_pressed("Punch"):
		attack = "Punch"
		return true
	elif Input.is_action_just_pressed("Kick"):
		attack = "Kick"
		return true
	elif Input.is_action_just_pressed("Slash"):
		attack = "Slash"
		return true
	elif Input.is_action_just_pressed("Heavy"):
		attack = "Heavy"
		return true
	else:
		return false



func _physics_process(delta: float) -> void:
	get_movement_input()
	input_calc()
	
	if is_on_floor():
		jump = false
	
	if health <= 0:
		$StateChart.send_event("to_death")


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
		change_kick_position_right()
		change_slash_position_right()
		change_heavy_position_right()
		launch_direction.x = abs(launch_direction.x)
		return true
		
	
	#if to the left
	elif enemy.global_position.x < self.global_position.x:
		$Player_animations.flip_h = false
		change_punch_position_left()
		change_kick_position_left()
		change_slash_position_left()
		change_heavy_position_left()
		launch_direction.x = -launch_direction.x
		return false

func change_punch_position_left():
	$Attacks/punch.position.x = -84
	$Attacks/c_punch.position.x = -84
func change_punch_position_right():
	$Attacks/punch.position.x = 84
	$Attacks/c_punch.position.x = 84
func change_kick_position_left():
	$Attacks/kick.position.x = -90
	$Attacks/c_kick.position.x = -84
func change_kick_position_right():
	$Attacks/kick.position.x = 90
	$Attacks/c_kick.position.x = 84
func change_slash_position_left():
	$Attacks/slash.position.x = -94.25
	$Attacks/c_slash.position.x = -77.5
func change_slash_position_right():
	$Attacks/slash.position.x = 94.25
	$Attacks/c_slash.position.x = 77.5
func change_heavy_position_left():
	$Attacks/heavy.position.x = -109.75
	$Attacks/c_heavy.position.x = -166.25
func change_heavy_position_right():
	$Attacks/heavy.position.x = 109.75
	$Attacks/c_heavy.position.x = 166.25

func _on_attacking_state_entered() -> void:
	if state == "Idle":
		$Idle.disabled = false
		$Hit_Box/Idle.disabled = false
	if state == "Crouch":
		$Crouch.disabled = false
		$Hit_Box/Crouch.disabled = false
	if state == "Jump":
		$Jump.disabled = false
		$Hit_Box/Jump.disabled = false
	print("attack: " + attack)
	execute_attack(attack)
	time = get_node_or_null("timers/" + attack.to_lower() +"/" + attack.to_lower())
	time.start()
func _on_attacking_state_processing(delta: float) -> void:
	pass
func _on_attacking_state_physics_processing(delta: float) -> void:
	#if entered on punch
	if attack == "Punch" and attack_connected:
		if state == "Idle":
			#to standing punch
			if Input.is_action_just_pressed("Punch") and inputs[-1] in standing_inputs:
				print("double")
				time.stop()
				$Attacks_ani.stop()
				$Attacks/punch.disabled = true
				attack = "Punch"
				$StateChart.send_event("to_idle")
				$Player_animations.stop()
			#to standing kick
			elif Input.is_action_just_pressed("Kick") and inputs[-1] in standing_inputs:
				print("gatling")
				time.stop()
				$Attacks_ani.stop()
				$Attacks/punch.disabled = true
				attack = "Kick"
				$StateChart.send_event("to_idle")
				$Player_animations.stop()
	#if attack was a kick
	if attack == "Kick" and attack_connected:
		if state == "Idle":
			#to dash
			if Input.is_action_just_pressed("Dash") and inputs[-1] == 6:
				time.stop()
				$Attacks_ani.stop()
				$Player_animations.stop()
				$Attacks/kick.disabled = true
				attack = ""
				print("Dash cancel!")
				$StateChart.send_event("to_dash")
	if attack == "Slash" and attack_connected:
		if state == "Idle":
			if Input.is_action_just_pressed("Heavy") and inputs[-1] in standing_inputs:
				print("gatling")
				time.stop()
				$Attacks_ani.stop()
				$Player_animations.stop()
				$Attacks/slash.disabled = true
				attack = "Heavy"
				$StateChart.send_event("to_idle")
			if Input.is_action_just_pressed("Dash") and inputs[-1] == 6:
				time.stop()
				$Attacks_ani.stop()
				$Attacks/c_slash.disabled = true
				attack = ""
				print("Dash cancel!")
				$Player_animations.stop()
				$StateChart.send_event("to_dash")
		else:
			pass
func _on_attacking_state_exited() -> void:
	for group in $Attacks.get_groups():
		$Attacks.remove_from_group(group)


func _on_punch_timeout() -> void:
	print("punch timeout")
	attack = ""
	attack_connected = false
	if state == "Idle":
		$StateChart.send_event("to_idle")
	elif state == "Crouch":
		$StateChart.send_event("to_crouch")
func _on_kick_timeout() -> void:
	print("kick timeout")
	attack = ""
	attack_connected = false
	if state == "Idle":
		$StateChart.send_event("to_idle")
	elif state == "Crouch":
		$StateChart.send_event("to_crouch")
func _on_slash_timeout() -> void:
	print("slash timeout")
	attack = ""
	attack_connected = false
	if state == "Idle":
		$StateChart.send_event("to_idle")
	elif state == "Crouch":
		$StateChart.send_event("to_crouch")
func _on_heavy_timeout() -> void:
	print("heavy timeout")
	attack = ""
	attack_connected = false
	if state == "Idle":
		$StateChart.send_event("to_idle")
	elif state == "Crouch":
		$StateChart.send_event("to_crouch")

#different for every character
func attack_loop():
	if attack == "Punch":
		return true
	elif attack == "Kick":
		return true
	elif attack == "Slash":
		return true
	elif attack == "Heavy":
		return true
	else:
		return false

func _on_idle_state_entered() -> void:
	juggle_rating = 2.0
	state = "Idle"
	if attack_loop():
		$StateChart.send_event("to_attacking")
	if jump == true and !is_on_floor():
		$StateChart.send_event("to_jump")
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
		
		if inputs[-1] in blocking_inputs or block:
			$Hit_Box.add_to_group("Blocking")
		if inputs[-1] not in blocking_inputs and !block:
			$Hit_Box.remove_from_group("Blocking")
func _on_idle_state_physics_processing(delta: float) -> void:
	#if enemy is there
	if check_for_enemy():
		check_enemy_position(enemy)
	if controlled:
		if get_attack_input():
			$StateChart.send_event("to_attacking")
func _on_idle_state_exited() -> void:
	prev_box = "Idle"



func _on_walk_state_entered() -> void:
	state = "Idle"
	
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
	if inputs[-1] in blocking_inputs or block:
		$Hit_Box.add_to_group("Blocking")
	if inputs[-1] not in blocking_inputs and !block:
		$Hit_Box.remove_from_group("Blocking")
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
	if get_attack_input():
		$Player_animations.play("Idle")
		$StateChart.send_event("to_attacking")
func _on_walk_state_exited() -> void:
	prev_box = "Idle"

func _on_jump_state_entered() -> void:
	state = "Jump"
	#set bools accordingly
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
	if Input.is_action_just_pressed("Jump") and jump == false:
		jump = true
		$StateChart.send_event("to_idle")
	if inputs[-1] in blocking_inputs or block:
		$Hit_Box.add_to_group("Blocking")
	if inputs[-1] not in blocking_inputs and !block:
		$Hit_Box.remove_from_group("Blocking")
func _on_jump_state_physics_processing(delta: float) -> void:
	velocity += get_gravity()
	velocity.x = (direction.x * 5) * SPEED * delta
	move_and_slide()
func _on_jump_state_exited() -> void:
	prev_box = "Jump"





func _on_step_dash_state_entered() -> void:
	$Player_animations.play("Dash")
	attack_connected = false
	
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
	prev_box = "Idle"

func dmg_flash():
	self.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	self.modulate = Color.WHITE
	await get_tree().create_timer(0.1).timeout
	self.modulate = Color.RED

func _on_hitstun_state_entered() -> void:
	dmg_flash()
	print("hit")
	print(juggle_rating)
	$timers/hitstun.start()
func _on_hitstun_state_processing(delta: float) -> void:
	#if health = 0
	#if health <= 0:
	#	pass
	if juggle_rating <= 0:
		print("rating threshold")
		$timers/hitstun.stop()
		$StateChart.send_event("to_juggled")
func _on_hitstun_state_physics_processing(delta: float) -> void:
	if hit_again:
		$timers/hitstun.stop()
		$timers/hitstun.start()
		dmg_flash()
		print("restarted")
		hit_again = false
func _on_hitstun_state_exited() -> void:
	self.modulate = Color.WHITE
	print("not looped")
func _on_hitstun_timeout() -> void:
	$StateChart.send_event("to_idle")


func _on_juggled_state_entered(delta: float) -> void:
	$Player_animations.play("Juggled")
	juggle_rating = 2.0
	print("juggled")
	velocity = (launch_direction * 0.1) * SPEED * delta
func _on_juggled_state_processing(delta: float) -> void:
	#if landed and has health
	#if health > 0 and is_on_floor():
	#	$StateChart.send_event("to_knocked_down")
	
	#if health = 0 and lands
	if health <= 0 and is_on_floor():
		pass
func _on_juggled_state_physics_processing(delta: float) -> void:
	$Player_animations.play("Juggled")
	launch_direction = Vector2(100, -100)
	if check_enemy_position(enemy):
		launch_direction.x = -launch_direction.x
		velocity = (launch_direction * 0.1) * SPEED * delta
		move_and_slide()
	if !check_enemy_position(enemy):
		launch_direction.x = abs(launch_direction.x)
		velocity = (launch_direction * 0.1) * SPEED * delta
		move_and_slide()
	await get_tree().create_timer(0.2).timeout
	$StateChart.send_event("to_knocked_down")
func _on_juggled_state_exited() -> void:
	pass




func _on_knocked_down_state_entered() -> void:
	print("knocked_down")
func _on_knocked_down_state_processing(delta: float) -> void:
	pass # Replace with function body.
func _on_knocked_down_state_physics_processing(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity()
		velocity.x = (direction.x * 5) * SPEED * delta
		move_and_slide()
		if juggle_rating <= 0:
			$Hit_Box/Idle.disabled = true
		
	if is_on_floor():
		$Player_animations.play("Knocked_Down")
		self.modulate = Color.GREEN_YELLOW
		await get_tree().create_timer(0.5).timeout
		self.modulate = Color.WHITE
		$StateChart.send_event("to_idle")
func _on_knocked_down_state_exited() -> void:
	$Hit_Box/Idle.disabled = false




func execute_attack(attack_name: String):
	if attack_name == "Punch":
		if state == "Idle":
			$Attacks.add_to_group("Mid")
			$Attacks.add_to_group("Punch")
			$Attacks_ani.play("punch")
			$Player_animations.play("Attack_1")
		elif state == "Crouch":
			$Attacks.add_to_group("Low")
			$Attacks.add_to_group("Punch")
			$Attacks_ani.play("c_punch")
	elif attack_name == "Kick":
		if state == "Idle":
			$Attacks.add_to_group("Mid")
			$Attacks.add_to_group("Kick")
			$Attacks_ani.play("kick")
			$Player_animations.play("Attack_2")
		elif state == "Crouch":
			$Attacks.add_to_group("Low")
			$Attacks.add_to_group("Kick")
			$Attacks_ani.play("c_kick")
	elif attack_name == "Slash":
		if state == "Idle":
			$Attacks.add_to_group("Mid")
			$Attacks.add_to_group("Slash")
			$Attacks_ani.play("slash")
		elif state == "Crouch":
			$Attacks.add_to_group("Mid")
			$Attacks.add_to_group("Slash")
			$Attacks_ani.play("c_slash")
	elif attack_name == "Heavy":
		if state == "Idle":
			$Attacks.add_to_group("Mid")
			$Attacks.add_to_group("Heavy")
			$Attacks_ani.play("heavy")
		elif state == "Crouch":
			$Attacks.add_to_group("Low")
			$Attacks.add_to_group("Heavy")
			$Attacks_ani.play("c_heavy")
			pass


func _on_attacks_area_entered(area: Area2D) -> void:
	if "Player" in area.get_groups():
		print("hit")
		attack_connected = true

func _on_hit_box_area_entered(area: Area2D):
	print("entered")
	var attack_type = area.get_groups()
	var attack_dmg: float
	var launch_dmg: float
	if "B2-MD" in enemy.get_groups():
		if "Punch" in attack_type:
			attack_dmg = 40
			launch_dmg = 0.1
			$timers/blockstun.wait_time = 0.2
			$timers/hitstun.wait_time = 0.4
			hit_again = true
		elif "Kick" in attack_type:
			attack_dmg = 80
			launch_dmg = 2
			$timers/blockstun.wait_time = 0.4
			$timers/hitstun.wait_time = 1
			hit_again = true
		else:
			return null
	var block_type = $Hit_Box.get_groups()
	if "Blocking" not in block_type:
		print(block_type)
		health -= attack_dmg
		juggle_rating -= launch_dmg
		print(health)
		$StateChart.send_event("to_hitstun")
	elif "Blocking" in block_type:
		$StateChart.send_event("to_blockstun")
	elif !self.is_on_floor():
		$StateChart.send_event("to_juggled")



func _on_blockstun_state_entered() -> void:
	print("blockstun")
	self.modulate = Color.DEEP_SKY_BLUE
	$timers/blockstun.start()
func _on_blockstun_state_processing(delta: float) -> void:
	pass # Replace with function body.
func _on_blockstun_state_physics_processing(delta: float) -> void:
	if hit_again:
		$timers/blockstun.stop()
		$timers/blockstun.start()
		print("restarted")
		hit_again = false
func _on_blockstun_state_exited() -> void:
	self.modulate= Color.WHITE
func _on_blockstun_timeout() -> void:
	$StateChart.send_event("to_idle")


func _on_death_state_entered() -> void:
	print("death")
func _on_death_state_processing(delta: float) -> void:
	pass # Replace with function body.
func _on_death_state_physics_processing(delta: float) -> void:
	var death_in_air: bool 
	if !is_on_floor():
		velocity += get_gravity()
		$Player_animations.play("Death_Fall")
		death_in_air = true
	if is_on_floor():
		$Hit_Box/Idle.disabled = true
		if death_in_air:
			$Player_animations.play("Death_Fall_End")
		else:
			$Player_animations.play("Death")
func _on_death_state_exited() -> void:
	$Hit_Box/Idle.disabled = false
