extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = get_game_root()
	if root:
		root.toggle_touch_controls.connect(on_toggled)
		on_toggled(root.touch_controls)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func get_game_root() -> GameRoot:
	var parent: Node = self.get_parent()
	while parent != null:
		if parent is GameRoot:
			return parent
		parent = parent.get_parent()
	return null

func on_toggled(on: bool):
	if on:
		self.show()
	else:
		self.hide()
