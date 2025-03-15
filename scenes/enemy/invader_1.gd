extends Area2D

@export var bullet: PackedScene

# Width and height of this ship in pixels
# TODO: Is there a way to obtain this dynamically?
var ship_width: int = 28
var ship_height: int = 24

# Color of this ship to have it fire matching bullets
var ship_color: Global.Colors = Global.Colors.GREEN

# Return the ship width in pixels
func get_width() -> int:
	return ship_width

# Return the ship height in pixels
func get_height() -> int:
	return ship_height

# Destroy this ship. This just delegates off to the parent.
# TODO: An animation could be added here
func destroy_ship() -> void:
	get_parent().destroy_ship()

# Gire a new bullet and give it a color that matches the ship
func fire_bullet() -> void:
	var new_bullet : Node2D = bullet.instantiate()
	get_tree().root.get_node("Main").add_child(new_bullet)
	new_bullet.position = global_position
	new_bullet.set_bullet_type(Global.BulletType.ENEMY)
	new_bullet.set_bullet_color(ship_color)
