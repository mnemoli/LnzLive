extends Node
class_name LnzParser

var r = RegEx.new()
var str_r = RegEx.new()

var species = 0
var scales = Vector2(255, 255)
var leg_extensions = Vector2(0, 0)
var body_extension = 0
var face_extension = 0
var ear_extension = 0
var head_enlargement = Vector2(100, 0)
var foot_enlargement = Vector2(100, 0)
var moves = {}
var balls = {}
var lines = []
var addballs = {}
var paintballs = {}
var omissions = {}
var project_ball = []
var texture_list = []

var file_path

func get_next_section(file: File, section_name: String):
	file.seek(0)
	var this_line = ""
	while !this_line.begins_with("[" + section_name + "]") and !file.eof_reached():
		this_line = file.get_line()
	if file.eof_reached():
		return false
	return true
	
func get_parsed_lines(file: File, keys: Array):
	var return_array = []
	while true:
		var line = file.get_line().dedent()
		if line.empty() or line.begins_with("[") or file.eof_reached() or line.begins_with("#2"):
			break
		if line.begins_with(";") or line.begins_with("#"):
			continue
		var parsed = r.search_all(line)
		var dict = {}
		var i = 0
		for key in keys:
			dict[key] = int(parsed[i].get_string())
			i += 1
		return_array.append(dict)
	return return_array
	
func get_parsed_line_strings(file: File, keys: Array):
	var return_array = []
	while true:
		var line = file.get_line().dedent()
		if line.empty() or line.begins_with("[") or file.eof_reached() or line.begins_with("#2"):
			break
		if line.begins_with(";") or line.begins_with("#"):
			continue
		var parsed = str_r.search_all(line)
		var dict = {}
		var i = 0
		for key in keys:
			dict[key] = parsed[i].get_string()
			i += 1
		return_array.append(dict)
	return return_array

func _init(file_path):
	self.file_path = file_path
	r.compile("[-.\\d]+")
	str_r.compile("[\\S]+")
	var file = File.new()
	if file.file_exists(file_path):
		file.open(file_path, File.READ)
	else:
		print("file " + file_path + " not found")
		file.close()
		return
	
	var this_line = ""
	
	get_texture_list(file)
	get_species(file)
	get_default_scales(file)
	get_leg_extensions(file)
	get_body_extension(file)
	get_face_extension(file)
	get_ear_extension(file)
	get_head_enlargement(file)
	get_feet_enlargement(file)
	get_omissions(file)
	get_lines(file)
	get_balls(file)
	
	file.seek(0)
	
	get_addballs(file)
	get_project_balls(file)
		
	## Get paintballz
	while this_line != "[Paint Ballz]" and !file.eof_reached():
		this_line = file.get_line()
	while(true):
		this_line = file.get_line()
		if this_line.empty() or this_line.begins_with("[") or file.eof_reached() or this_line.begins_with("#2"):
			break
		if this_line.begins_with(";") or this_line.begins_with('#'):
			continue
		var split_line = r.search_all(this_line)
		var base = int(split_line[0].get_string())
		var diameter_percent = int(split_line[1].get_string())
		var x = float(split_line[2].get_string())
		var y = float(split_line[3].get_string())
		var z = float(split_line[4].get_string())
		var color = int(split_line[5].get_string())
		var outline_color = int(split_line[6].get_string())
		if (outline_color == -1):
			outline_color = 0
		var fuzz = int(split_line[7].get_string())
		var outline = int(split_line[8].get_string())
		var texture = int(split_line[10].get_string())
		var anchored = 0
		if split_line.size() > 11:
			anchored = int(split_line[11].get_string())
		var paintball = PaintBallData.new(base, diameter_percent, Vector3(x,y,z), color, outline_color, outline, fuzz, 0, texture, anchored)
		var pb_array = self.paintballs.get(base, [])
		pb_array.append(paintball)
		self.paintballs[base] = pb_array
		
	## Get move data
	file.seek(0)
	while !this_line.begins_with("[Move]") and !file.eof_reached():
		this_line = file.get_line()
	while(true):
		this_line = file.get_line()
		if this_line.empty() or this_line.begins_with("[") or file.eof_reached() or this_line.begins_with("#2"):
			break
		if this_line.begins_with(";") or this_line.begins_with('#'):
			continue
		var split_line = r.search_all(this_line)
		var base = int(split_line[0].get_string())
		var x = int(split_line[1].get_string())
		var y = int(split_line[2].get_string())
		var z = int(split_line[3].get_string())
		var relative_ball = base
		if split_line.size() > 4:
			relative_ball = int(split_line[4].get_string())
		var pos = Vector3(x, y, z)
		var ar = moves.get(base, [])
		ar.append({position = pos, relative_to = relative_ball})
		moves[base] = ar
		var ball = self.balls[base]
		ball.position = pos
		
	file.close()
	
func get_default_scales(file: File):
	get_next_section(file, "Default Scales")
	var parsed_lines = get_parsed_lines(file, ["scale"])
	if parsed_lines.size() > 0:
		scales = Vector2(parsed_lines[0].scale, parsed_lines[1].scale)
	
func get_leg_extensions(file: File):
	get_next_section(file, "Leg Extension")
	var parsed_lines = get_parsed_lines(file, ["extension"])
	if parsed_lines.size() > 0:
		leg_extensions = Vector2(parsed_lines[0].extension, parsed_lines[1].extension)
	
func get_body_extension(file: File):
	get_next_section(file, "Body Extension")
	var parsed_lines = get_parsed_lines(file, ["extension"])
	if parsed_lines.size() > 0:
		body_extension = parsed_lines[0].extension
	
func get_face_extension(file: File):
	get_next_section(file, "Face Extension")
	var parsed_lines = get_parsed_lines(file, ["extension"])
	if parsed_lines.size() > 0:
		face_extension = parsed_lines[0].extension

func get_ear_extension(file: File):
	get_next_section(file, "Ear Extension")
	var parsed_lines = get_parsed_lines(file, ["extension"])
	if parsed_lines.size() > 0:
		ear_extension = parsed_lines[0].extension
	
func get_head_enlargement(file: File):
	get_next_section(file, "Head Enlargement")
	var parsed_lines = get_parsed_lines(file, ["scale"])
	if parsed_lines.size() > 0:
		head_enlargement = Vector2(parsed_lines[0].scale, parsed_lines[1].scale)
	
func get_feet_enlargement(file: File):
	get_next_section(file, "Feet Enlargement")
	var parsed_lines = get_parsed_lines(file, ["scale"])
	if parsed_lines.size() > 0:
		foot_enlargement = Vector2(parsed_lines[0].scale, parsed_lines[1].scale)
	
func get_omissions(file: File):
	get_next_section(file, "Omissions")
	var parsed_lines = get_parsed_lines(file, ["ball_no"])
	omissions = {}
	for line in parsed_lines:
		omissions[line.ball_no] = true
		
func get_lines(file: File):
	get_next_section(file, "Linez")
	var parsed_lines = get_parsed_lines(file, ["start", "end", "fuzz", "color", "l_color", "r_color", "start_thickness", "end_thickness"])
	for line in parsed_lines:
		var line_data = LineData.new(line.start, line.end, line.start_thickness, line.end_thickness, line.fuzz, line.color, line.l_color, line.r_color)
		lines.append(line_data)
		
func get_balls(file: File):
	get_next_section(file, "Ballz Info")
	var parsed_lines = get_parsed_lines(file, ["color", "outline_color", "speckle", "fuzz", "outline", "size", "group", "texture"])
	var i = 0
	for line in parsed_lines:
		var bd = BallData.new(
			line.size, 
			Vector3.ZERO, 
			i, 
			Vector3.ZERO,
			line.color,
			line.outline_color, 
			line.outline, 
			line.fuzz, 
			0.0, 
			line.group, 
			line.texture)
		self.balls[i] = bd
		i += 1

func get_addballs(file: File):
	get_next_section(file, "Add Ball")
	var parsed_lines = get_parsed_lines(file, ["base", "x", "y", "z", "color", "outline_color", "speckle", "fuzz", "group", "outline", "size", "body_area", "add_group", "texture"])
	var max_ball_num = balls.keys().max() + 1
	for line in parsed_lines:
		var pos = Vector3(line.x, line.y, line.z)
		var ball = AddBallData.new(
			line.base,
		 max_ball_num, 
		line.size, 
		pos,
		line.color, 
		line.outline_color, 
		line.outline, 
		line.fuzz,
		 0, 
		line.group, 
		line.body_area, 
		line.texture)
		addballs[max_ball_num] = ball
		max_ball_num += 1
		
func get_project_balls(file: File):
	get_next_section(file, "Project Ball")
	var parsed_lines = get_parsed_lines(file, ["base", "projected", "amount"])
	for line in parsed_lines:
		project_ball.append({ball = line.projected, base = line.base, amount = line.amount})

func get_species(file: File):
	get_next_section(file, "Species")
	var parsed_lines = get_parsed_lines(file, ["species"])
	if parsed_lines.size() == 0:
		species = 2
	else:
		species = parsed_lines[0].species

func get_texture_list(file: File):
	get_next_section(file, "Texture List")
	var parsed_lines = get_parsed_line_strings(file, ["filepath", "transparent_color"])
	for line in parsed_lines:
		var filename = line.filepath.get_file()
		texture_list.append({filename = filename, transparent_color = line.transparent_color})
