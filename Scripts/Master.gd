extends Node

var gravity = 50
var tempoAtual = 1 setget changedTime
var linhasTemporais = ['Passado', 'Presente', 'Futuro']
var TIPOS_LINHAS_TEMPORAIS = {
	linhasTemporais[0]: 0,
	linhasTemporais[1]: 1,
	linhasTemporais[2]: 2
}

func changedTime(_newTime):
	print("time has changed..." + str(_newTime))
	for time in linhasTemporais:
		if time == linhasTemporais[_newTime]:
			for _node in get_tree().get_nodes_in_group(time):
#				print(_node)
				_node.set_collision_layer_bit(1, false)
				_node.set_collision_mask_bit(1, false)
				_node.set_collision_layer_bit(0, true)
				_node.set_collision_mask_bit(0, true)
				_node.set_physics_process(true)
		else:
			for _node in get_tree().get_nodes_in_group(time):
#				print(_node)
				_node.set_collision_layer_bit(1, true)
				_node.set_collision_mask_bit(1, true)
				_node.set_collision_layer_bit(0, false)
				_node.set_collision_mask_bit(0, false)
				_node.set_physics_process(false)
			pass
	tempoAtual = _newTime
	pass
