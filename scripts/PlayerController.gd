extends Node

@export var SpawnField: MeshInstance3D
@export var debug_label: Label
@export var camera: Camera3D

@export var lock_rotation: bool = true
var debug_labels := {}

var last_accepted_input: Vector3 = Vector3.ZERO
var buffered_input = null
var waiting_for_settle: bool = true

var time_since_move: float = 0.0
@export var wait_period = 0.05
@export var start_damping_after = 0.5

var tile_scene = preload("res://scenes/NumberedCube3d.tscn")

var move_speed := 30

@onready var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	SpawnField.hide()
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
	debug_labels["buffered_input"]= str(buffered_input)

	var num_moving_tiles := 0
	var num_tiles := 0
	if waiting_for_settle and time_since_move >= wait_period:
		for c in self.get_children():
			var rb: RigidBody3D = access_rigidbody(c)
			if rb is RigidBody3D:
				num_tiles += 1
				rb.constant_force = Vector3.ZERO
				#if !rb.is_sleeping():
				if rb.linear_velocity.length() > 0.001:
					num_moving_tiles += 1
#					if time_since_move > start_damping_after:
#						rb.linear_velocity = lerp(rb.linear_velocity, Vector3.ZERO, 0.7)
#						rb.angular_velocity = lerp(rb.angular_velocity, Vector3.ZERO, 0.7)
		if num_moving_tiles == 0 or time_since_move > start_damping_after:
			waiting_for_settle = false
	debug_labels["num_moving_tiles"]= str(num_moving_tiles)
	debug_labels["num_tiles"]= str(num_tiles)
			
	var new_input = read_input()
	if new_input is Vector3:
		buffered_input = new_input

	if buffered_input is Vector3 and not waiting_for_settle:
		if buffered_input != last_accepted_input:
			waiting_for_settle = true
			time_since_move = 0.0
			for c in self.get_children():
				var rb: RigidBody3D = access_rigidbody(c)
				if rb is RigidBody3D:
					rb.apply_impulse(buffered_input * move_speed)
			last_accepted_input = buffered_input
			spawn_new_tile()
	
	update_debug_label()


func access_rigidbody(node: Node):
	if node is Node3D:
		for c in node.get_children():
			if c is RigidBody3D:
				return c
	return null


		
func read_input():
	if waiting_for_settle:
		return null

	var input := Vector3.ZERO
	input.x = Input.get_axis("left", "right")
	input.z = Input.get_axis("up", "down")

	if input.length() > 0.0:
		input = input.normalized()
		if not (input.x == 0 or input.z == 0):
			return
		
		if input != last_accepted_input:
			return input

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
		print("trying to place tile at " + str(new_position) + ", attempt: " + str(attempts_remaining))
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
		rb.lock_rotation = self.lock_rotation


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
		PhysicsRayQueryParameters3D.create(position, position + Vector3(0.0, -distance, 0.0)),
		# make sure that there's a clear line of sight from the camera to it. that'll stop us from spawning stuff inside of walls
		PhysicsRayQueryParameters3D.create(camera.global_position, position)
	]
	for q in queries:
		var result = space_state.intersect_ray(q)
		if result:
			return false # a ray hit something
	return true


