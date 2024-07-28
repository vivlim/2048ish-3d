extends CanvasLayer

@export var Value: int = 0
@export var LastValue: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	update_label()

func update_label():
	if (Value != LastValue):
		$Label.text = str(Value)
		Value = LastValue

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_label()
