extends State

var speed : float = 25000
var boundaries = [100, 850]
var forward : bool = true

func _process(_delta):
	toggle_movement()


func _physics_process(delta):
	parent.velocity.x = speed * delta
	

func toggle_movement():
	var min_x = boundaries[0]
	var max_x = boundaries[1]
	
	#if parent.global_position.x > max_x or parent.global_position.x < min_x:
		#print("act")
		#speed = speed * -1
	if parent.global_position.x > max_x and forward:
		speed = speed * -1
		forward = false
	elif parent.global_position.x < min_x and not forward:
		speed = speed * -1
		forward = true
		
