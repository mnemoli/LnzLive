extends Node
class_name AddBallData

export var base = 0
export var size = 1
export var position = Vector3(0,0,0)
export var color = Color.white
export var color_index = -1
export var outline_color = Color.black
export var outline = -1
export var z_add = 0.0
export var fuzz = 0
export var group = -1
export var body_area = 1
export var ball_no = -1
export var texture_id = -1

func _init(
 base: int,
 ball_no: int,
 size: int,
 position: Vector3,
 color: Color = Color.white,
 color_index: int = -1,
 outline_color = Color.black,
 outline = -1,
 fuzz = 0,
 z_add = 0.0,
 group = -1,
 body_area = 1,
 texture_id = -1):
	self.size = size
	self.position = position
	self.color = color
	self.color_index = color_index
	self.outline_color = outline_color
	self.outline = outline
	self.base = base
	self.z_add = z_add
	self.fuzz = fuzz
	self.group = group
	self.body_area = body_area
	self.ball_no = ball_no
	self.texture_id = texture_id
