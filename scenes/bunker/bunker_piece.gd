extends Area2D

# When the bunker piece is destroyed, free it.
# TODO: This could be enhanced with an animation when taken out, or a sound
#       effect that could be played here
func destroy_bunker() -> void:
	queue_free()

# When the bunker enters the scene, add it to the bunker collision layer and bunker
# group so that bullets will be able to hit it.
func _ready() -> void:
	set_collision_layer_value(Global.CollisionLayer.BUNKER, true)
	add_to_group("bunker")
