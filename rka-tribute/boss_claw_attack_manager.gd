extends Node2D

@export var claw_scene: PackedScene
@export var segment_scene: PackedScene
@onready var anchor_point = $AnchorPoint

var offset : float = 300
var rotation_speed : float = 2.5
var rotation_radius_size = Vector2(offset,0)
var segment_string_length : float
var claw: Node2D
var segments : Array[Node2D] = []

func _ready():
	segment_string_length = anchor_point.position.y
	var seg_amt : int = 9
	var seg_separation = segment_string_length / seg_amt
	for i in range(seg_amt):
		var segment = segment_scene.instantiate() as Node2D
		var segment_x : float
		if i > 0:
			segment_x = anchor_point.position.x / i
		else:
			segment_x = i
		print(segment_x)
		var segment_y = ((seg_amt - i - 1) * seg_separation)
		segment.position = Vector2(segment_x, 100 + segment_y)
		var segment_sprite = segment.get_child(0) as Sprite2D
		segment_sprite.position.x = (offset / i) * (sqrt(i))		
		add_child(segment)
		segments.append(segment)
		
	claw = claw_scene.instantiate() as Node2D
	claw.position = rotation_radius_size
	anchor_point.add_child(claw)


func _physics_process(delta):
	anchor_point.rotation += rotation_speed * delta
	claw.rotation = -anchor_point.rotation
	
	for segment in segments:
		segment.rotation += rotation_speed * delta
		
		var sprite = segment.get_child(0) as Sprite2D
		sprite.rotation = -segment.rotation
