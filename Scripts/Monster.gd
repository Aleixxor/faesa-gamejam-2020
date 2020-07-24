extends KinematicBody2D

var motion = Vector2()
var gravity = Master.gravity
var direction = Vector2(1, 1)
var speed = Vector2(50, Master.gravity/ 10)
var cdAttack = 5
var currentCdAttack = 0
var isAttacking = false
var attackDamage = 15
var last_position

func _physics_process(delta):
	if collision_layer == 1 and collision_mask == 1:

		if currentCdAttack > 0:
			currentCdAttack -= delta

		if !isAttacking:
			if last_position == position:
				direction.x = direction.x * (-1)
			else:
				last_position = position

			if is_on_floor():
				direction.y = 0
			else:
				direction.y += 1

			if direction.x < 0:
				$sprite.flip_h = false
			elif direction.x > 0:
				$sprite.flip_h = true

			motion = direction * speed
			if motion.x != 0:
				$sprite.play("run")
			else:
				$sprite.play("idle")
			move_and_slide(motion)
		else:
			attack()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		isAttacking = true
		if body.global_position.x < global_position.x:
			$sprite.flip_h = false
		elif body.global_position.x > global_position.x:
			$sprite.flip_h = true

func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		isAttacking = false

func attack():
	if canAttack():
		for body in $Area2D.get_overlapping_bodies():
			if body.is_in_group("Player"):
				body.receiveDmg(attackDamage)
				pass
		currentCdAttack = cdAttack
		$sprite.play("attack")
		yield($sprite, "animation_finished")
		$sprite.play("idle")

func canAttack():
	return currentCdAttack <= 0
