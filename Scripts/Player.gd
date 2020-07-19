extends KinematicBody2D

export var speed = 500
export var jumpSpeed = 1000

var gravity = Master.gravity
var motion = Vector2()
var UP = Vector2(0,-1)
var look_direction = Vector2(1, 0)
var tempoAtual

func _ready():
	set_physics_process(true)
	tempoAtual = get_parent().tempoAtual
	alternaTempo(tempoAtual);

func alternaTempo(novoTempo):
	toggleNode(get_parent().get_node('Passado'), false);
	toggleNode(get_parent().get_node('Presente'), false);
	toggleNode(get_parent().get_node('Futuro'), false);
	toggleNode(get_parent().get_node(tempoAtual), false);
	toggleNode(get_parent().get_node(novoTempo), true);
	print('De: '+tempoAtual)
	print('Para: '+novoTempo)
	tempoAtual = novoTempo

func toggleNode(node, status):
	if status:
		node.pause_mode = PAUSE_MODE_INHERIT
	else:
		node.pause_mode = PAUSE_MODE_STOP
	for children in node.get_children():
		children.visible = status

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
		alternaTempo("Futuro");
		print("we are now in the future!")

	if Input.is_action_just_pressed("to_the_past"):
		alternaTempo("Passado");
		print("we are now in the past!")

	if Input.is_action_just_pressed("ui_attack"):
		print("PORRADA")
