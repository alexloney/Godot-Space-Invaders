extends Area2D

func destroy_bunker() -> void:
	queue_free()

func _ready() -> void:
	set_collision_layer_value(Global.CollisionLayer.BUNKER, true)
	add_to_group("bunker")
