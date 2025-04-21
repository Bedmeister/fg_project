extends Camera2D

var player_1
var player_2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_1 = get_node_or_null("/root/Main/player_1")
	player_2 = get_node_or_null("/root/Main/player_2")

"""
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_avr_position()
	

func get_avr_position():
	var pos = (player_1.position + player_2.position)/2
	return pos
"""
