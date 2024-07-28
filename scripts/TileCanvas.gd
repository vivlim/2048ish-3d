extends CanvasLayer

@export var Value: int = 0
var LastValue: int = 0
@export var Colors: GradientTexture1D
@export var GradientMapMax: int = 90 # something that doesn't evenly divide by the tile values, so we get different spots on the gradient

# Called when the node enters the scene tree for the first time.
func _ready():
	update_label()

func update_label():
	if Value != LastValue and Value > 0:
		$Label.text = str(Value)
		LastValue = Value
		var gradient_map_value = Value
		while gradient_map_value > GradientMapMax:
			gradient_map_value -= GradientMapMax
		gradient_map_value = log(gradient_map_value)
		var gradient_map_x = remap(gradient_map_value, 0, log(GradientMapMax), 0, Colors.get_width())
		var color = Colors.get_image().get_pixel(gradient_map_x, 0)
		print("color map:" + str(Value) + ": " + str(gradient_map_value) + ", " + str(gradient_map_x))
		$ColorRect.color = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_label()
