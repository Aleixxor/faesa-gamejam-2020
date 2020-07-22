extends Node

func _ready():
	print("Collision layer -> ")
	for _node in get_tree().get_nodes_in_group("Passado"):
		print("Before -> " + str(_node.collision_layer))
		_node.set_collision_layer_bit(0, false)
		print("After -> " + str(_node.collision_layer))
#	print($Passado/Plano.collision_layer)
	pass
