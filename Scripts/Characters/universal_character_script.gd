extends CharacterBody2D


#variables
var speed: int = 1000000
var health: int = 1000
var direction: Vector2i = Vector2i(0,0)

func _physics_process(delta: float) -> void:
	get_movement()
	velocity = direction * speed * delta


func get_movement():
	direction = Input.get_vector("4", "6", "8", "2")
