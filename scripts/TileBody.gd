extends RigidBody3D

@export var Value: int
@export var mesh: MeshInstance3D
@export var canvas: CanvasLayer

var canvasTexture: CanvasTexture

# Called when the node enters the scene tree for the first time.
func _ready():
	#mesh.material_override = 
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$SubViewport/TileCanvas.Value = Value
