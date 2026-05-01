extends State

@onready var hit_flash_component = $"../../HitFlashComponent"
@onready var stun_timer = $"../../StunTimer"
@onready var boss = get_tree().get_first_node_in_group("boss")
@onready var health_component = boss.get_node("HealthComponent")

var stored_dir

func enter():
	hit_flash_component.hit.connect(_on_hit)
	#boss.global_position.y = 400	

		
func _on_hit():
	if health_component.health > 0:
		stored_dir = parent.dir
		parent.boss_speed = (parent.SPEED / 3.5)
		stun_timer.start()


func _on_stun_timer_timeout():	
	parent.boss_speed = parent.SPEED
