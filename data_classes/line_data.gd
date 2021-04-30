extends Node
class_name LineData

export var start: int
export var end: int
export var s_thick: int = 100
export var e_thick: int = 100
export var fuzz: int = 0
export var color = Color.white
export var color_index = 0
export var r_color = Color.black
export var l_color = Color.black

func _init(
	start: int, 
	end: int, 
	s_thick: int = 100, 
	e_thick: int = 100, 
	fuzz = 0,
	color = Color.white,
	color_index = 0,
	r_color = Color.black,
	l_color = Color.black):
	self.start = start
	self.end = end
	self.s_thick = s_thick
	self.e_thick = e_thick
	self.fuzz = fuzz
	self.color = color
	self.r_color = r_color
	self.l_color = l_color
	self.color_index = color_index
	
