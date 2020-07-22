extends Node2D

func _ready():
	$TileMap.set_collision_layer_bit(0, false)
	$TileMap.set_collision_mask_bit(0, false)
	pass
