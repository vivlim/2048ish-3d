extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_menu_button_pressed() -> void:
	var parent_node = self.get_parent()
	if "remove_specific_layer" in parent_node:
		parent_node.remove_specific_layer(self)
