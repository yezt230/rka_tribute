extends State

@onready var hit_flash_component = $"../../HitFlashComponent"
@onready var stun_timer = $"../../StunTimer"

const SPEED : float = 25000
var stored_speed : float
var boss_speed : float  = SPEED
var boundaries = [100, 850]
var forward : bool = true

func _ready():
	stored_speed = SPEED
	hit_flash_component.hit.connect(_on_hit)


func _process(_delta):
	toggle_movement()
	
	parent.hit_wall.connect(_on_wall_hit)
	parent.speed_label.text = "stored speed: " + str(parent.dir)
	#parent.speed_label.text = "stored speed: " + str("%0.0f" % stored_speed)


func _physics_process(delta):
	parent.velocity.x = stored_speed * delta
	

func toggle_movement():
	var min_x = boundaries[0]
	var max_x = boundaries[1]
	
	#if parent.global_position.x > max_x or parent.global_position.x < min_x:
		#print("act")
		#speed = speed * -1
	#if parent.global_position.x > max_x and forward:
		#stored_speed = stored_speed * -1
		#forward = false
	#elif parent.global_position.x < min_x and not forward:
		#stored_speed = stored_speed * -1
		#forward = true
		
		
func _on_hit():
	print("hitted")
	#stored_speed = 0
	stun_timer.start()


func _on_stun_timer_timeout():	
	stored_speed = boss_speed


func _on_wall_hit():
	print("hit wall")
