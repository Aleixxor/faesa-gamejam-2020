extends KinematicBody2D

export var speed = 500
export var jumpSpeed = 1000

var gravity = Master.gravity
var motion = Vector2()
var UP = Vector2(0,-1)
var look_direction = Vector2(1, 0)

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	if is_on_floor():
		motion.y = 0
	else:
		motion.y += gravity

	if Input.is_action_pressed("ui_right"):
		motion.x = speed
		look_direction = Vector2(1, 0)
	elif Input.is_action_pressed("ui_left"):
		motion.x = -speed
		look_direction = Vector2(-1, 0)
	else:
		motion.x = 0

	if Input.is_action_pressed("ui_up"):
		look_direction = Vector2(look_direction.x, -1)

	if is_on_floor() and Input.is_action_pressed("ui_jump"):
		motion = UP * jumpSpeed

	if is_on_ceiling() and motion.y < 0:
		motion.y = 0

	move_and_slide(motion, UP)
	if motion.x > 0:
		$sprite.flip_h = false
	elif motion.x < 0: 
		$sprite.flip_h = true

	if Input.is_action_just_pressed("to_the_future"):
		print("we are now in the future!")

	if Input.is_action_just_pressed("to_the_past"):
		print("we are now in the past!")

	if Input.is_action_just_pressed("ui_attack"):
		print("PORRADA")
