extends KinematicBody2D

export var speed = 500
export var jumpSpeed = 1100

var gravity = Master.gravity
var motion = Vector2()
var UP = Vector2(0,-1)
var look_direction = Vector2(1, 0)
var canmove = false
var airAtacksCount = 1

func _ready():
	set_physics_process(true)
	alternaTempo(Master.tempoAtual)
	controleAnimacaoMovimento()
	canmove = true

func alternaTempo(novoTempo):
	for tempo in Master.linhasTemporais:
		toggleNode(get_parent().get_node(tempo), false, tempo);
	toggleNode(get_parent().get_node(Master.linhasTemporais[novoTempo]), true, Master.linhasTemporais[novoTempo]);
	print('De: '+Master.linhasTemporais[Master.tempoAtual])
	print('Para: '+Master.linhasTemporais[novoTempo])
	$Label.text = Master.linhasTemporais[novoTempo]
	Master.tempoAtual = novoTempo

func toggleNode(node, status, tempo):
	for children in node.get_children():
		children.visible = status
	for nodeInGroup in get_tree().get_nodes_in_group('colider'):
		if(nodeInGroup.get_parent().is_in_group(tempo)):
			nodeInGroup.disabled = !status

func _physics_process(delta):
	if canmove:
		if is_on_floor():
			motion.y = 0
			airAtacksCount = 1
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
	
#		if Input.is_action_pressed("ui_up"):
#			look_direction = Vector2(look_direction.x, -1)
	
		if is_on_floor() and Input.is_action_pressed("ui_jump"):
			motion = UP * jumpSpeed
	
		if is_on_ceiling() and motion.y < 0:
			motion.y = 0
	
		controleAnimacaoMovimento()
		move_and_slide(motion, UP)

	if Input.is_action_just_pressed("to_the_future"):
		if(Master.tempoAtual+1 < Master.linhasTemporais.size()):
			canmove = false
			$sprite.play("changetime")
			yield($sprite, "animation_finished")
			alternaTempo(Master.tempoAtual + 1);
			canmove = true
		

	if Input.is_action_just_pressed("to_the_past"):
		if(Master.tempoAtual-1 >= 0):
			canmove = false
			$sprite.play("changetime")
			yield($sprite, "animation_finished")
			alternaTempo(Master.tempoAtual - 1);
			canmove = true

	if Input.is_action_just_pressed("ui_attack"):
		attack()

func controleAnimacaoMovimento():
	if canmove:
		if motion != Vector2():
			if motion.y <= Master.gravity and motion.y >= Master.gravity * (-1):
				if motion.x > 0:
					$sprite.flip_h = false
				elif motion.x < 0:
					$sprite.flip_h = true
				$sprite.play("walking")
			else:
				if motion.x > 0:
					$sprite.flip_h = false
				elif motion.x < 0:
					$sprite.flip_h = true
				if motion.y < 0:
					$sprite.play("jumpup")
				elif motion.y > 0:
					$sprite.play("jumpdown")

func attack():
	if canAttack():
		if !is_on_floor():
			airAtacksCount -= 1
		canmove = false
		$sprite.play("attack")
		yield($sprite, "animation_finished")
		canmove = true

func canAttack():
	return airAtacksCount > 0 and $sprite.animation != "attack"
