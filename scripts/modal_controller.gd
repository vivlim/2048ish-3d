extends Control
class_name ModalController

@export var SettingsScene: PackedScene
var layers: Array[Control]
var lerp_targets: Array[Dictionary] = []
var layer_start_locations: Dictionary = {}

const LERP_TARGET_KEY_CONTROL = "Control"
const LERP_TARGET_KEY_LOCATION = "Location"
const LERP_TARGET_KEY_DELETE_AT_END = "DeleteAtEnd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if lerp_targets.size() == 0:
		return

	var indices_to_remove = []
	var i = 0
	for t in lerp_targets:
		var c: Control = t[LERP_TARGET_KEY_CONTROL]
		var target_location = t[LERP_TARGET_KEY_LOCATION]
		c.global_position = lerp(c.global_position, target_location, 0.5)
		if c.global_position - target_location == Vector2.ZERO:
			indices_to_remove.append(i)
			if LERP_TARGET_KEY_DELETE_AT_END in t and t[LERP_TARGET_KEY_DELETE_AT_END]:
				c.queue_free()
		i += 1
	if indices_to_remove.size() > 0:
		indices_to_remove.reverse() # start from the end, because removing items will shift indices
		for to_remove in indices_to_remove:
			lerp_targets.remove_at(to_remove)

func lerp_layer_with_target_pos(c: Control, start_pos: Vector2, target_pos: Vector2, delete_after: bool):
	# starting position is just off the bottom of the screen.
	c.global_position = start_pos
	self.add_child(c)
	lerp_targets.append({
		LERP_TARGET_KEY_CONTROL: c,
		LERP_TARGET_KEY_LOCATION: target_pos,
		LERP_TARGET_KEY_DELETE_AT_END: delete_after
	})

func push_layer(packed_scene: PackedScene, from_direction: Vector2):
	var instance = packed_scene.instantiate()
	self.layers.push_back(instance) # for ordering
	self.add_child(instance)
	var start = get_offscreen_position(from_direction)
	var end = Vector2.ZERO
	layer_start_locations[instance] = start
	lerp_layer_with_target_pos(instance, start, end, false)

func pop_layer():
	if self.layers.size() == 0:
		return
	var popped = self.layers.pop_back()

	var start = Vector2.ZERO
	var end = layer_start_locations[popped]
	layer_start_locations.erase(popped)
	lerp_layer_with_target_pos(popped, start, end, true)

func remove_specific_layer(c: Control):
	if self.layers.size() == 0:
		return

	var idx = self.layers.find(c)
	if idx >= 0:
		self.layers.remove_at(idx)

	var start = Vector2.ZERO
	var end = layer_start_locations[c]
	layer_start_locations.erase(c)
	lerp_layer_with_target_pos(c, start, end, true)


func get_offscreen_position(direction: Vector2) -> Vector2:
	var s = self.get_global_rect().size
	return Vector2(s.x, s.y) * direction

func _on_settings_button_pressed() -> void:
	print("open settings layer")
	push_layer(SettingsScene, Vector2(-0.5, 0))
