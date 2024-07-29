extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_visibility()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resized() -> void:
	update_visibility()

func update_visibility():
	var s = self.get_global_rect().size
	if s.y > s.x:
		# portrait mode
		self.show()
	else:
		self.hide()
