extends Node
class_name LineData

export var start: int
export var end: int
export var s_thick: int = 100
export var e_thick: int = 100
export var fuzz: int = 0
export var color_index = 0
export var l_color_index = 0
export var r_color_index = 0

func _init(
	start: int, 
	end: int, 
	s_thick: int = 100, 
	e_thick: int = 100, 
	fuzz = 0,
	color_index = 0,
	l_color_index = 0,
	r_color_index = 0):
	self.start = start
	self.end = end
	self.s_thick = s_thick
	self.e_thick = e_thick
	self.fuzz = fuzz
	self.r_color_index = r_color_index
	self.l_color_index = l_color_index
	self.color_index = color_index
	
