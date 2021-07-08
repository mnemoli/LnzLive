extends Node
class_name PaintBallData

export var base = 0
export var size = 1
export var normalised_position = Vector3(0,0,0)
export var color_index = 0
export var outline_color_index = 0
export var outline = -1
export var z_add = 0.0
export var fuzz = 0
export var texture_id = -1
export var anchored = 0

func _init(
 base: int,
 size: int,
 position: Vector3,
 color_index: int,
 outline_color_index: int,
 outline = -1,
 fuzz = 0,
 z_add = 0.0,
 texture_id = -1,
 anchored = 0):
	self.size = size
	self.normalised_position = position
	self.color_index = color_index
	self.outline_color_index = outline_color_index
	self.outline = outline
	self.base = base
	self.fuzz = fuzz
	self.z_add = z_add
	self.texture_id = texture_id
	self.anchored = anchored
