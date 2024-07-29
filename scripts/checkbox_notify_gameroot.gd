extends CheckBox
class_name RootNotifyingCheckbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = get_game_root()
	# hack: this script assumes it's the touch controls toggle atm
	self.button_pressed = root.touch_controls

	
func _toggled(toggled_on: bool) -> void:
	var root = get_game_root()
	root.handle_button_pressed(self)
	
func get_game_root() -> GameRoot:
	var parent: Node = self.get_parent()
	while parent != null:
		if parent is GameRoot:
			return parent
		parent = parent.get_parent()
	return null
