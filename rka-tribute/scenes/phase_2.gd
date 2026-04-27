extends State

@onready var hit_flash_component = $"../../HitFlashComponent"
@onready var stun_timer = $"../../StunTimer"
@onready var second_claw_spawn_timer = $"../../SecondClawSpawnTimer"
@onready var boss = get_tree().get_first_node_in_group("boss")

var claw_attack_manager: PackedScene = preload("res://scenes/boss_claw_attack_manager.tscn")
var stored_dir

func enter():
	boss.global_position.y = 0
	hit_flash_component.hit.connect(_on_hit)
	spawn_claw()
	second_claw_spawn_timer.start()
	
		
func _on_hit():
	stored_dir = parent.dir
	parent.boss_speed = (parent.SPEED / 3.5)
	stun_timer.start()


func spawn_claw():
	var claw = claw_attack_manager.instantiate()
	claw.position = Vector2(-200, 0)
	if boss:
		boss.add_child(claw)


func _on_stun_timer_timeout():	
	parent.boss_speed = parent.SPEED


func _on_second_claw_spawn_timer_timeout():
	spawn_claw()
