extends State

@onready var hit_flash_component = $"../../HitFlashComponent"
@onready var stun_timer = $"../../StunTimer"

var stored_dir

func _ready():
	hit_flash_component.hit.connect(_on_hit)


func _process(_delta):
	pass
	#if stored_dir:
		#parent.speed_label.text = str(stored_dir)

		
func _on_hit():
	stored_dir = parent.dir
	parent.boss_speed = 0
	stun_timer.start()


func _on_stun_timer_timeout():	
	print(parent.dir)
	parent.boss_speed = parent.SPEED
