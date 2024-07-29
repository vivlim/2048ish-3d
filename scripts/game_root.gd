extends Node3D
@export var stages: Array[PackedScene] = []
@export var stage_target: Node
@export var active_stage_number: int = 0
var instantiated_stage_number = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if instantiated_stage_number != active_stage_number:
		active_stage_number = active_stage_number % stages.size()
		if instantiated_stage_number != active_stage_number:
			instantiated_stage_number = switch_to_stage(active_stage_number)

func switch_to_stage(index: int) -> int:
	for c in stage_target.get_children():
		c.queue_free()
	var scene_resource = stages[index]
	var new_scene = scene_resource.instantiate() as Node3D
	stage_target.add_child(new_scene)
	return index
