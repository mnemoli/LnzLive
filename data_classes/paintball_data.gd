extends Node
class_name PaintBallData

export var base = 0
export var size = 1
export var normalised_position = Vector3(0,0,0)
export var color = Color.white
export var outline_color = Color.black
export var outline = -1
export var z_add = 0.0
export var fuzz = 0

func _init(
 base: int,
 size: int,
 position: Vector3,
 color: Color = Color.white,
 outline_color = Color.black,
 outline = -1,
 fuzz = 0,
 z_add = 0.0):
	self.size = size
	self.normalised_position = position
	self.color = color
	self.outline_color = outline_color
	self.outline = outline
	self.base = base
	self.fuzz = fuzz
	self.z_add = z_add