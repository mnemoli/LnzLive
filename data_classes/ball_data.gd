extends Node
class_name BallData

export var ball_no = -1
export var size = 1
export var position = Vector3.ZERO
export var color_index = 0
export var outline = -1
export var z_add = 0.0
export var fuzz = 0
export var group = -1
export var texture_id = -1
export var rotation = Vector3.ZERO
export var outline_color_index = 0

func _init(
 size: int,
 position: Vector3,
 ball_no: int,
 rotation = Vector3.ZERO,
 color_index = 0,
 outline_color_index = 0,
 outline = -1,
 fuzz = 0,
 z_add = 0.0,
 group = -1,
 texture_id = -1):
	self.size = size
	self.position = position
	self.outline = outline
	self.ball_no = ball_no
	self.z_add = z_add
	self.fuzz = fuzz
	self.group = group
	self.texture_id = texture_id
	self.color_index = color_index
	self.rotation = rotation
	self.outline_color_index = outline_color_index
