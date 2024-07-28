extends Node3D

@export var Value: int = 1
@export var rigid_body: RigidBody3D
var marked_for_removal := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Tile.Value = Value

	if marked_for_removal:
		queue_free()


func _on_tile_body_entered(other_body):
	# assuming that the other body will be directly parented to one of these
	var other_tile = other_body.get_parent_node_3d()
	if ! "Value" in other_tile:
		return

	if self.marked_for_removal or other_tile.marked_for_removal:
		# already handled
		return

	if other_tile.Value != null and other_tile.Value == self.Value:
		print("Two tiles with same value are colliding")
		# find which one is faster
		var my_speed = rigid_body.linear_velocity.length()
		var their_speed = other_body.linear_velocity.length()

		if their_speed >= my_speed:
			# absorb them into me
			other_tile.marked_for_removal = true
			self.Value = other_tile.Value + self.Value
		else:
			# absorb me into them
			self.marked_for_removal = true
			other_tile.Value = other_tile.Value + self.Value



		

