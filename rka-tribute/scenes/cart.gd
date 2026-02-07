extends CharacterBody2D

@onready var player = $"../Player"

func _ready():
	print("player")
	print(player)
	

#func _process(delta: float) -> void:
	#print("player.x: " + str(player.position.x))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * 2.0 * delta		
	else:
		velocity.y = 0
	
	global_position.x = player.position.x	
	move_and_slide()
