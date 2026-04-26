extends State

@onready var hit_flash_component = $"../../HitFlashComponent"
@onready var stun_timer = $"../../StunTimer"

var claw_attack_manager: PackedScene = preload("res://scenes/boss_claw_attack_manager.tscn")
var stored_dir

func _ready():
	var claw = claw_attack_manager.instantiate()
	add_child(claw)
	hit_flash_component.hit.connect(_on_hit)

		
func _on_hit():
	stored_dir = parent.dir
	parent.boss_speed = (parent.SPEED / 3.5)
	stun_timer.start()


func _on_stun_timer_timeout():	
	parent.boss_speed = parent.SPEED
