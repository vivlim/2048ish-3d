extends Button
class_name LevelSelectButton

@export var level_index: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

	
func _pressed() -> void:
	var root = get_game_root()
	root.handle_button_pressed(self)
	
func get_game_root() -> GameRoot:
	var parent: Node = self.get_parent()
	while parent != null:
		if parent is GameRoot:
			return parent
		parent = parent.get_parent()
	return null
