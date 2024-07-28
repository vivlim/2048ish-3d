extends RigidBody3D

@export var Value: int
@export var mesh: MeshInstance3D
@export var canvas: CanvasLayer

@export var constraint_cardinal_directions: bool = true
@export var constraint_integer_grid: bool = true
@export var constraint_tiles_move_in_input_direction: bool = true

var canvasTexture: CanvasTexture
var last_impulse := Vector3.ZERO
var last_impulse_direction := Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	#mesh.material_override = 
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$SubViewport/TileCanvas.Value = Value

	# need to enforce this one if not moving also
	if constraint_integer_grid and self.linear_velocity == Vector3.ZERO:
		var target_position = round_xz(self.global_position)
		self.global_position = lerp(self.global_position, target_position, 0.5)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	apply_constraints()

func apply_impulse_custom(force: Vector3):
	last_impulse = force
	last_impulse_direction = force.normalized()
	self.apply_impulse(force)

func apply_constraints():
	if constraint_tiles_move_in_input_direction:
		if last_impulse_direction != Vector3.ZERO and self.linear_velocity != Vector3.ZERO:
			if self.linear_velocity.normalized().dot(last_impulse_direction) > PI/2:
				self.linear_velocity = Vector3.ZERO # cut velocity in half if we are travelling in some totally different direction
			else:
				self.linear_velocity = last_impulse_direction * self.linear_velocity.length()
	if constraint_cardinal_directions:
		if self.linear_velocity.x == 0 or self.linear_velocity.z == 0:
			pass
		else:
			if abs(self.linear_velocity.x) > abs(self.linear_velocity.z):
				self.linear_velocity.x += self.linear_velocity.z
				self.linear_velocity.z = 0
			else:
				self.linear_velocity.z += self.linear_velocity.x
				self.linear_velocity.x = 0
	if constraint_integer_grid:
		# steer towards integer locations as long as it wouldn't be a swerve
		var lookahead_factor = 1 # multiply the linear velocity by this when figuring out what target integer location we are looking at.
		var target_position = round_xz(self.global_position + (self.linear_velocity * lookahead_factor))

		if self.linear_velocity == Vector3.ZERO:
			self.global_position = lerp(self.global_position, target_position, 0.5)
		else:
			var to_target_vec = target_position - self.global_position
			var direction_to_target = to_target_vec.normalized()
			var current_move_direction = self.linear_velocity.normalized()

			var target_angle = current_move_direction.dot(direction_to_target)
			# make sure that the target is in the general direction we're looking, if it's behind us, ignore it
			if target_angle < PI/4:
				# redirect linear velocity
				self.linear_velocity = direction_to_target * self.linear_velocity.length()


func round_xz(vec3: Vector3):
	return Vector3(round(vec3.x), vec3.y, round(vec3.z))
