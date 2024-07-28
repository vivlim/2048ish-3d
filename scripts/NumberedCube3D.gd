extends Node3D

@export var Value: int = 1
@export var rigid_body: RigidBody3D
var marked_for_removal := false
var absorbing_into_target = null

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
		# find which one is faster
		var my_speed = rigid_body.linear_velocity.length()
		var their_speed = other_body.linear_velocity.length()

		print("Two tiles with same value are colliding with speeds " + str(my_speed) + " and " + str(their_speed))

		# one must be stopped
		if check_tile_travelling_toward(self.rigid_body, other_body):
			print("absorbing into them")
			self.marked_for_removal = true
			other_tile.Value = other_tile.Value + self.Value

		elif check_tile_travelling_toward(other_body, self.rigid_body):
			# absorb them into me
			other_tile.marked_for_removal = true
			self.Value = other_tile.Value + self.Value
#		else:
#			# absorb me into them
#			self.marked_for_removal = true
#			other_tile.Value = other_tile.Value + self.Value
func check_tile_travelling_toward(source_tile: RigidBody3D, target_tile: RigidBody3D):
	var source_speed = source_tile.linear_velocity.length()
	var target_speed = target_tile.linear_velocity.length()
	if source_speed > 0.0 and (source_speed / 2) > target_speed:
		if source_tile.linear_velocity.length() > 0.0:

			# check if they are in the direction i'm travelling.
			var direction_to = source_tile.global_position.direction_to(target_tile.global_position)
			# check similarity between direction of the other and direction i'm travelling.
			var dot_product = direction_to.dot(source_tile.linear_velocity.normalized())
			print("dot product: " + str(dot_product))

			if dot_product < PI/3:
				return true
	return false
			
