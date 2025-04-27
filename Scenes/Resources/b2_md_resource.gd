class_name B2_MD
extends CharacterBody2D

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
