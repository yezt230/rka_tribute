extends Node2D

@export var claw_scene: PackedScene
@export var segment_scene: PackedScene
@onready var anchor_point = $AnchorPoint

var offset : float = 250
var rotation_speed : float = 2.5
var rotation_radius_size = Vector2(offset,0)
var segment_string_length : float
var claw: Node2D
var segments : Array[Node2D] = []

func _ready():	
	segment_string_length = anchor_point.position.y
	var seg_amt : int = 9
	var seg_separation = segment_string_length / seg_amt
	var center: int = floor(seg_amt / 2)
	
	for i in range(seg_amt):
		var piece_to_load = claw_scene if i == 1 else segment_scene
		var segment = piece_to_load.instantiate() as Node2D
		var inc = floor(seg_amt - abs((i - floor(center / 1.5 )) - center))
		#print("inc: " + str(inc))
		var segment_x = (1 / pow(1.5, inc) * 2000)
		var segment_y = ((seg_amt - i - 1) * seg_separation)
		segment.position = Vector2(segment_x, 100 + segment_y)
		var segment_sprite = segment.get_child(0) as Sprite2D
		segment_sprite.position.x = (offset / i) * (sqrt(i))		
		add_child(segment)
		segments.append(segment)


func _physics_process(delta):
	anchor_point.rotation += rotation_speed * delta	
	for segment in segments:
		segment.rotation += rotation_speed * delta
		
		var sprite = segment.get_child(0) as Sprite2D
		sprite.rotation = -segment.rotation
