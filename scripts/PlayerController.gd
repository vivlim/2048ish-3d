extends Node

@export var SpawnField: MeshInstance3D
@export var debug_label: Label
@export var camera: Camera3D
@export var tile_scene: PackedScene

@export var lock_rotation: bool = true
@export var constraint_cardinal_directions: bool = true
@export var constraint_integer_grid: bool = true
var constraint_integer_grid_correction_speed = 2
@export var constraint_tiles_move_in_input_direction: bool = true
var debug_labels := {}
@export var number_to_spawn_per_move: int = 1
@export var require_line_of_sight_to_spawn: bool = true

var last_accepted_input: Vector3 = Vector3.ZERO
var last_seen_input: Vector3 = Vector3.ZERO # used for debouncing
var buffered_input = null
var waiting_for_settle: bool = true

var time_since_move: float = 0.0
@export var wait_period = 0.05
@export var start_damping_after = 0.5

var move_speed := 30

@onready var rng = RandomNumberGenerator.new()

const initial_values = [1,2,4,8]
const initial_values_weights_unpacked = [4.0, 2.0, 1.0, 0.5]
@onready var initial_value_weights = PackedFloat32Array(initial_values_weights_unpacked)

# Called when the node enters the scene tree for the first time.
func _ready():
	SpawnField.hide()
	for i in range(number_to_spawn_per_move):
		spawn_new_tile()


func debug_label_float(lname, value: float):
	debug_labels[lname] = "%8.3f" % value

func update_debug_label():
	var lines = []
	for label in debug_labels:
		lines.append("%s: %s" % [label, debug_labels[label]])
	debug_label.text = "\n".join(lines)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	time_since_move += delta

	debug_labels["waiting_for_settle"]= str(waiting_for_settle)
	debug_label_float("time_since_move", time_since_move)
	debug_labels["last_accepted_input"]= str(last_accepted_input)
	debug_labels["last_seen_input"]= str(last_seen_input)
	debug_labels["buffered_input"]= str(buffered_input)

	var num_moving_tiles := 0
	var num_tiles := 0
	if waiting_for_settle and time_since_move >= wait_period:
		for c in self.get_children():
			var rb: RigidBody3D = access_rigidbody(c)
			if rb is RigidBody3D:
				num_tiles += 1
				#if !rb.is_sleeping():
				if rb.linear_velocity.length() > 0.001:
					num_moving_tiles += 1
#					if time_since_move > start_damping_after:
#						rb.linear_velocity = lerp(rb.linear_velocity, Vector3.ZERO, 0.7)
#						rb.angular_velocity = lerp(rb.angular_velocity, Vector3.ZERO, 0.7)
		if num_moving_tiles == 0 or time_since_move > start_damping_after:
			waiting_for_settle = false
			for i in range(number_to_spawn_per_move):
				spawn_new_tile()
	debug_labels["num_moving_tiles"]= str(num_moving_tiles)
	debug_labels["num_tiles"]= str(num_tiles)
			
	var new_input = read_input()

	if new_input is Vector3 and buffered_input.length() > 0.0 and not waiting_for_settle:
		waiting_for_settle = true
		time_since_move = 0.0
		for c in self.get_children():
			var rb: RigidBody3D = access_rigidbody(c)
			if rb is RigidBody3D:
				apply_constraints(rb)
				rb.apply_impulse_custom(buffered_input * move_speed)
		last_accepted_input = buffered_input
		# must consume the buffered_input
		buffered_input = Vector3.ZERO
	
	update_debug_label()


func access_rigidbody(node: Node):
	if node is Node3D:
		for c in node.get_children():
			if c is RigidBody3D:
				return c
	return null


		
func read_input():
	var input := Vector3.ZERO
	input.x = Input.get_axis("left", "right")
	input.z = Input.get_axis("up", "down")

	# if there is a previously seen input and it is the same, discard it - we want to return to zero first
	if input == last_seen_input:
		last_seen_input = input
		return null
	last_seen_input = input

	if input.length() > 0.0:
		input = input.normalized()
		if not (input.x == 0 or input.z == 0):
			return
		
		# comment this to disallow moving in the same direction consecutively
		#if input != last_accepted_input:
		buffered_input = input
		return input
	else:
		# nothing's pressed
		if buffered_input is Vector3:
			return buffered_input
		return null

func spawn_new_tile():
	var bounding_box = SpawnField.get_aabb()
	var bbpos = bounding_box.position + SpawnField.global_position
	var bbsize = bounding_box.size
	var min_x = bbpos.x
	var max_x = min_x + bbsize.x
	var min_y = bbpos.y
	var max_y = min_y + bbsize.y
	var min_z = bbpos.z
	var max_z = min_z + bbsize.z
	var new_position = Vector3.ZERO
	
	var attempts_remaining = 200

	while attempts_remaining > 0:
		new_position.x = rng.randf_range(min_x, max_x)
		new_position.y = rng.randf_range(min_y, max_y)
		new_position.z = rng.randf_range(min_z, max_z)
		if constraint_integer_grid:
			new_position = round_xz(new_position) # grid, assume that a tile is 1 unit
		#print("trying to place tile at " + str(new_position) + ", attempt: " + str(attempts_remaining))
		if check_space_empty(new_position):
			var new_tile = tile_scene.instantiate() as Node3D
			self.add_child(new_tile)
			new_tile.global_position = new_position
			setup_new_tile(new_tile)
			return
		attempts_remaining -= 1
	
	print("out of attempts trying to place tile")

func setup_new_tile(new_tile: Node3D):
	var rb: RigidBody3D = access_rigidbody(new_tile)
	if rb is RigidBody3D:
		apply_constraints(rb)

	new_tile.Value = initial_values[rng.rand_weighted(initial_value_weights)]

	# test it's a valid location

func check_space_empty(position: Vector3):
	var space_state = SpawnField.get_world_3d().direct_space_state
	var distance = 1
	var queries = [
		PhysicsRayQueryParameters3D.create(position, position + Vector3(0.0, 0.0, distance)),
		PhysicsRayQueryParameters3D.create(position, position + Vector3(0.0, 0.0, -distance)),
		PhysicsRayQueryParameters3D.create(position, position + Vector3(distance, 0.0, 0.0)),
		PhysicsRayQueryParameters3D.create(position, position + Vector3(-distance, 0.0, 0.0)),
		PhysicsRayQueryParameters3D.create(position, position + Vector3(0.0, distance, 0.0)),
		PhysicsRayQueryParameters3D.create(position, position + Vector3(0.0, -distance, 0.0))
	]
	if require_line_of_sight_to_spawn:
		# make sure that there's a clear line of sight from the camera to it. that'll stop us from spawning stuff inside of walls
		queries.append(PhysicsRayQueryParameters3D.create(camera.global_position, position))
	for q in queries:
		var result = space_state.intersect_ray(q)
		if result:
			return false # a ray hit something
	return true

func apply_constraints(rb: RigidBody3D):
	rb.lock_rotation = self.lock_rotation
	rb.constraint_tiles_move_in_input_direction = constraint_tiles_move_in_input_direction
	rb.constraint_cardinal_directions = constraint_cardinal_directions
	rb.constraint_integer_grid = constraint_cardinal_directions

func round_xz(vec3: Vector3):
	return Vector3(round(vec3.x), vec3.y, round(vec3.z))


func _on_rotation_checkbox_toggled(toggled_on: bool) -> void:
	lock_rotation = toggled_on


func _on_integer_grid_checkbox_toggled(toggled_on: bool) -> void:
	constraint_integer_grid = toggled_on


func _on_tiles_move_in_input_direction_checkbox_toggled(toggled_on: bool) -> void:
	constraint_tiles_move_in_input_direction = toggled_on


func _on_cardinal_directions_checkbox_toggled(toggled_on: bool) -> void:
	constraint_cardinal_directions = toggled_on
