extends Node
class_name BhdParser

var animation_ranges = []
var num_balls: int
var file_path: String
var frames_offset: int
var ball_sizes = []

func _init(file_path):
	self.file_path = file_path
	var file = File.new()
	file.open(file_path, File.READ)
	frames_offset = file.get_16()
	file.get_32()
	num_balls = file.get_16()
	file.seek(file.get_position() + 30)
	for i in num_balls:
		ball_sizes.append(file.get_16())
	var animation_count = file.get_16()
	for i in animation_count:
		var start = 0
		if i > 0:
			start = animation_ranges[i - 1].end
		var end = file.get_16()
		var num_of_offsets = end - start
		animation_ranges.append({num_of_offsets = num_of_offsets, end = end, start = frames_offset + (start * 4), actual_start = start})
	file.close()

func get_frame_offsets_for(index: int):
	var result = []
	
	var anim_range = animation_ranges[index]
	var num_of_offsets = anim_range.num_of_offsets
	var file = File.new()
	file.open(file_path, File.READ)
	
	file.seek(anim_range.start)
	for i in num_of_offsets:
		var offset = file.get_32()
		result.append(offset)
	
	return result
