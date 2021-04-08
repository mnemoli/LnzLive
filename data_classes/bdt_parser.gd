extends Node
class_name BdtParser

var frames = []

func _init(filename: String, frame_indexes: Array, balls_num: int):
	var file = File.new()
	file.open("res://resources/animations/"+filename, File.READ)
	for frame_offset in frame_indexes:
		file.seek(frame_offset)
		for i in 6:
			var _spec = file.get_16()
		var tag = file.get_16()
		var balls = []
		for ball in balls_num:
			var x = file.get_s16()
			var y = file.get_s16()
			var z = file.get_s16()
			var rot1 = file.get_s8()
			var rot2 = file.get_s8()
			var rot3 = file.get_s8()
			var _tag3 = file.get_s8()
			balls.append(
				{
					tag = tag,
					position = Vector3(x, y, z),
					rotation = Vector3(rot1, rot2, rot3)
				}
			)
		frames.append(balls)
	file.close()
