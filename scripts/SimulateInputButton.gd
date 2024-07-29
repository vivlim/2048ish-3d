extends TextureButton
@export var input_to_send: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if input_to_send == null:
		print_debug("Input button without input to send")

func _on_button_down() -> void:
	var event = InputEventAction.new()
	event.action = input_to_send
	event.pressed = true
	Input.parse_input_event(event)


func _on_button_up() -> void:
	var event = InputEventAction.new()
	event.action = input_to_send
	event.pressed = false
	Input.parse_input_event(event)
