extends Node3D
class_name GameRoot
@export var stages: Array[PackedScene] = []
@export var stage_target: Node
@export var active_stage_number: int = 0
@export var modal_controller: ModalController
@export var hud_grid: Control
var instantiated_stage_number = null

signal toggle_touch_controls(on: bool)
var touch_controls: bool = false
var touch_controls_set_by_user: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	guess_touch_controls()

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

func handle_button_pressed(button: Button):
	if button is LevelSelectButton:
		switch_to_stage(button.level_index)
		modal_controller.pop_layer()
		
	if button is RootNotifyingCheckbox:
		if button.text == "touch controls":
			touch_controls = button.button_pressed
			touch_controls_set_by_user = true
			toggle_touch_controls.emit(touch_controls)

func guess_touch_controls():
	if touch_controls_set_by_user:
		return
	var s = hud_grid.get_global_rect().size

	if s.y > s.x:
		# portrait mode
		touch_controls = true
	else:
		touch_controls = false
	toggle_touch_controls.emit(touch_controls)


func _on_grid_container_resized() -> void:
	guess_touch_controls()
