extends KinematicBody2D

var motion = Vector2()
var gravity = Master.gravity
var direction = Vector2(-1, 0)
var speed = 50

onready var tiles = get_parent().get_node("Plano")
onready var current_tile_position = tiles.world_to_map(global_position)

func _ready():
	pass

func _physics_process(delta):
	if(!$CollisionShape2D.disabled):
		current_tile_position = tiles.world_to_map(global_position + Vector2(direction.x * 64, 1))
		if is_on_floor():
			motion.y = 0
		else:
			motion.y += gravity
	
		move_and_slide(motion)
		motion.y = 0
	
		if canMove() == 'true':
			if direction.x > 0:
				$sprite.flip_h = false
			elif direction.x < 0:
				$sprite.flip_h = true
	
			motion = direction * speed
	
		move_and_slide(motion)

func canMove():
	var auxTile = tiles.get_cell(current_tile_position.x + direction.x, current_tile_position.y)
	if auxTile == null:
		print("I CAN KEEP GOING!")
		return 'true'
	auxTile = tiles.get_cell(current_tile_position.x - direction.x, current_tile_position.y)
	if auxTile == null:
		pass
	return 'false'
