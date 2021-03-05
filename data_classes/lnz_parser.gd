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
var balls = {}
var lines = []
var color_chart = {
	0: Color(1.00, 1.00, 1.00),
	1: Color(0.50, 0.00, 0.00),
	2: Color(0.00, 0.50, 0.00),
	3: Color(0.50, 0.50, 0.00),
	4: Color(0.00, 0.00, 0.50),
	5: Color(0.50, 0.00, 0.50),
	6: Color(0.00, 0.50, 0.50),
	7: Color(0.75, 0.75, 0.75),
	8: Color(0.75, 0.80, 0.85),
	9: Color(0.00, 0.00, 0.00),
	10: Color(0.91, 0.89, 0.87),
	11: Color(0.89, 0.87, 0.85),
	12: Color(0.87, 0.85, 0.83),
	13: Color(0.86, 0.84, 0.82),
	14: Color(0.84, 0.82, 0.80),
	15: Color(0.83, 0.81, 0.78),
	16: Color(0.81, 0.79, 0.76),
	17: Color(0.80, 0.78, 0.75),
	18: Color(0.78, 0.76, 0.73),
	19: Color(0.76, 0.75, 0.71),
	20: Color(0.46, 0.46, 0.46),
	21: Color(0.44, 0.44, 0.44),
	22: Color(0.42, 0.42, 0.42),
	23: Color(0.40, 0.40, 0.40),
	24: Color(0.38, 0.38, 0.38),
	25: Color(0.36, 0.36, 0.36),
	26: Color(0.34, 0.34, 0.34),
	27: Color(0.32, 0.32, 0.32),
	28: Color(0.30, 0.30, 0.30),
	29: Color(0.27, 0.27, 0.27),
	30: Color(0.26, 0.26, 0.26),
	31: Color(0.23, 0.23, 0.23),
	32: Color(0.20, 0.20, 0.20),
	33: Color(0.17, 0.17, 0.17),
	34: Color(0.14, 0.14, 0.14),
	35: Color(0.11, 0.11, 0.11),
	36: Color(0.09, 0.09, 0.09),
	37: Color(0.05, 0.05, 0.05),
	38: Color(0.03, 0.03, 0.03),
	39: Color(0.00, 0.00, 0.00),
	40: Color(0.86, 0.76, 0.59),
	41: Color(0.84, 0.73, 0.56),
	42: Color(0.81, 0.71, 0.54),
	43: Color(0.78, 0.69, 0.52),
	44: Color(0.76, 0.66, 0.50),
	45: Color(0.73, 0.64, 0.48),
	46: Color(0.71, 0.61, 0.45),
	47: Color(0.68, 0.59, 0.44),
	48: Color(0.66, 0.56, 0.41),
	49: Color(0.64, 0.54, 0.39),
	50: Color(0.53, 0.25, 0.13),
	51: Color(0.50, 0.24, 0.13),
	52: Color(0.47, 0.22, 0.12),
	53: Color(0.44, 0.21, 0.11),
	54: Color(0.41, 0.19, 0.10),
	55: Color(0.38, 0.18, 0.09),
	56: Color(0.35, 0.16, 0.09),
	57: Color(0.32, 0.15, 0.08),
	58: Color(0.29, 0.13, 0.07),
	59: Color(0.26, 0.11, 0.06),
	60: Color(0.71, 0.45, 0.09),
	61: Color(0.69, 0.43, 0.07),
	62: Color(0.67, 0.41, 0.07),
	63: Color(0.65, 0.39, 0.05),
	64: Color(0.63, 0.37, 0.05),
	65: Color(0.61, 0.35, 0.04),
	66: Color(0.59, 0.33, 0.03),
	67: Color(0.58, 0.31, 0.02),
	68: Color(0.56, 0.29, 0.01),
	69: Color(0.54, 0.27, 0.00),
	70: Color(0.94, 0.62, 0.72),
	71: Color(0.91, 0.60, 0.70),
	72: Color(0.89, 0.58, 0.68),
	73: Color(0.87, 0.57, 0.66),
	74: Color(0.84, 0.55, 0.64),
	75: Color(0.82, 0.53, 0.62),
	76: Color(0.79, 0.52, 0.60),
	77: Color(0.76, 0.50, 0.58),
	78: Color(0.74, 0.49, 0.56),
	79: Color(0.72, 0.47, 0.55),
	80: Color(0.66, 0.16, 0.00),
	81: Color(0.64, 0.16, 0.00),
	82: Color(0.62, 0.15, 0.00),
	83: Color(0.61, 0.15, 0.00),
	84: Color(0.59, 0.15, 0.00),
	85: Color(0.57, 0.14, 0.00),
	86: Color(0.56, 0.14, 0.00),
	87: Color(0.54, 0.13, 0.00),
	88: Color(0.52, 0.13, 0.00),
	89: Color(0.51, 0.13, 0.00),
	90: Color(0.42, 0.29, 0.05),
	91: Color(0.40, 0.27, 0.04),
	92: Color(0.38, 0.24, 0.04),
	93: Color(0.36, 0.22, 0.04),
	94: Color(0.34, 0.20, 0.04),
	95: Color(0.32, 0.18, 0.04),
	96: Color(0.30, 0.15, 0.04),
	97: Color(0.28, 0.13, 0.04),
	98: Color(0.26, 0.11, 0.04),
	99: Color(0.24, 0.09, 0.04),
	100: Color(0.65, 0.54, 0.22),
	101: Color(0.64, 0.52, 0.22),
	102: Color(0.62, 0.51, 0.22),
	103: Color(0.60, 0.49, 0.22),
	104: Color(0.59, 0.47, 0.21),
	105: Color(0.58, 0.45, 0.21),
	106: Color(0.56, 0.44, 0.21),
	107: Color(0.55, 0.42, 0.21),
	108: Color(0.53, 0.40, 0.21),
	109: Color(0.52, 0.38, 0.21),
	110: Color(0.38, 0.44, 0.49),
	111: Color(0.36, 0.41, 0.46),
	112: Color(0.35, 0.39, 0.44),
	113: Color(0.33, 0.36, 0.41),
	114: Color(0.31, 0.34, 0.39),
	115: Color(0.29, 0.31, 0.36),
	116: Color(0.27, 0.29, 0.34),
	117: Color(0.25, 0.27, 0.31),
	118: Color(0.23, 0.24, 0.29),
	119: Color(0.21, 0.22, 0.26),
	120: Color(0.60, 0.56, 0.45),
	121: Color(0.59, 0.54, 0.44),
	122: Color(0.58, 0.53, 0.43),
	123: Color(0.56, 0.52, 0.42),
	124: Color(0.55, 0.51, 0.41),
	125: Color(0.54, 0.49, 0.40),
	126: Color(0.53, 0.48, 0.39),
	127: Color(0.51, 0.47, 0.38),
	128: Color(0.50, 0.46, 0.37),
	129: Color(0.49, 0.44, 0.36),
	130: Color(0.33, 0.67, 0.34),
	131: Color(0.24, 0.63, 0.28),
	132: Color(0.08, 0.60, 0.09),
	133: Color(0.21, 0.51, 0.21),
	134: Color(0.19, 0.48, 0.11),
	135: Color(0.06, 0.47, 0.10),
	136: Color(0.15, 0.38, 0.09),
	137: Color(0.18, 0.37, 0.17),
	138: Color(0.07, 0.36, 0.08),
	139: Color(0.06, 0.25, 0.07),
	140: Color(0.17, 0.38, 0.76),
	141: Color(0.22, 0.27, 0.89),
	142: Color(0.20, 0.23, 1.00),
	143: Color(0.20, 0.26, 0.81),
	144: Color(0.09, 0.10, 0.84),
	145: Color(0.18, 0.24, 0.71),
	146: Color(0.09, 0.11, 0.66),
	147: Color(0.16, 0.26, 0.56),
	148: Color(0.10, 0.13, 0.47),
	149: Color(0.07, 0.10, 0.33),
	150: Color(0.85, 0.94, 1.00),
	151: Color(0.67, 0.88, 1.00),
	152: Color(0.60, 0.84, 1.00),
	153: Color(0.51, 0.79, 1.00),
	154: Color(0.46, 0.71, 0.91),
	155: Color(0.41, 0.75, 1.00),
	156: Color(0.32, 0.59, 0.86),
	157: Color(0.09, 0.61, 0.81),
	158: Color(0.34, 0.55, 0.73),
	159: Color(0.12, 0.54, 0.66),
	160: Color(0.92, 0.93, 0.65),
	161: Color(0.92, 0.92, 0.56),
	162: Color(0.82, 0.80, 0.47),
	163: Color(0.97, 0.96, 0.00),
	164: Color(0.93, 0.91, 0.20),
	165: Color(0.76, 0.77, 0.04),
	166: Color(0.76, 0.76, 0.20),
	167: Color(0.62, 0.64, 0.09),
	168: Color(0.62, 0.62, 0.26),
	169: Color(0.43, 0.48, 0.18),
	170: Color(1.00, 1.00, 1.00),
	171: Color(0.75, 0.89, 0.91),
	172: Color(0.67, 0.78, 0.84),
	173: Color(0.65, 0.65, 0.69),
	174: Color(0.63, 0.63, 0.66),
	175: Color(0.45, 0.63, 0.71),
	176: Color(0.51, 0.60, 0.69),
	177: Color(0.51, 0.60, 0.69),
	178: Color(0.50, 0.60, 0.69),
	179: Color(0.50, 0.60, 0.69),
	180: Color(0.89, 0.75, 0.67),
	181: Color(0.84, 0.58, 0.56),
	182: Color(0.84, 0.46, 0.43),
	183: Color(0.72, 0.45, 0.40),
	184: Color(0.62, 0.47, 0.45),
	185: Color(0.64, 0.42, 0.36),
	186: Color(0.54, 0.39, 0.35),
	187: Color(0.60, 0.34, 0.30),
	188: Color(0.42, 0.27, 0.26),
	189: Color(0.35, 0.24, 0.19),
	190: Color(0.45, 0.62, 0.55),
	191: Color(0.00, 0.50, 0.50),
	192: Color(0.26, 0.48, 0.46),
	193: Color(0.00, 0.50, 0.50),
	194: Color(0.22, 0.47, 0.38),
	195: Color(0.24, 0.35, 0.39),
	196: Color(0.15, 0.35, 0.28),
	197: Color(0.13, 0.25, 0.17),
	198: Color(0.07, 0.22, 0.19),
	199: Color(1.00, 1.00, 1.00),
	200: Color(1.00, 1.00, 1.00),
	201: Color(0.96, 0.96, 0.85),
	202: Color(0.91, 0.85, 0.76),
	203: Color(0.17, 0.37, 0.35),
	204: Color(0.83, 0.96, 0.77),
	205: Color(0.77, 0.83, 0.62),
	206: Color(1.00, 0.78, 0.10),
	207: Color(0.69, 0.72, 0.61),
	208: Color(0.69, 0.69, 0.47),
	209: Color(0.65, 0.58, 0.56),
	210: Color(0.67, 0.66, 0.56),
	211: Color(0.84, 0.63, 0.08),
	212: Color(0.78, 0.50, 0.03),
	213: Color(0.79, 0.43, 0.27),
	214: Color(0.47, 0.56, 0.38),
	215: Color(0.60, 0.49, 0.30),
	216: Color(0.50, 0.50, 0.50),
	217: Color(0.40, 0.61, 0.16),
	218: Color(0.00, 0.80, 0.09),
	219: Color(0.65, 0.42, 0.22),
	220: Color(1.00, 0.26, 0.00),
	221: Color(0.59, 0.39, 0.26),
	222: Color(0.60, 0.40, 0.16),
	223: Color(0.87, 0.20, 0.42),
	224: Color(0.16, 0.27, 0.46),
	225: Color(0.35, 0.41, 0.71),
	226: Color(0.26, 0.42, 0.52),
	227: Color(0.31, 0.39, 0.50),
	228: Color(0.46, 0.35, 0.29),
	229: Color(1.00, 0.09, 0.08),
	230: Color(0.43, 0.36, 0.17),
	231: Color(0.61, 0.26, 0.22),
	232: Color(0.72, 0.20, 0.26),
	233: Color(0.53, 0.27, 0.26),
	234: Color(0.33, 0.27, 0.50),
	235: Color(0.49, 0.55, 0.53),
	236: Color(0.81, 0.06, 0.05),
	237: Color(0.57, 0.10, 0.08),
	238: Color(0.20, 0.18, 0.07),
	239: Color(0.07, 0.16, 0.05),
	240: Color(0.05, 0.06, 0.16),
	241: Color(0.00, 0.00, 0.00),
	242: Color(0.00, 0.00, 0.00),
	243: Color(0.00, 0.00, 0.00),
	244: Color(0.00, 0.00, 0.00),
	245: Color(1.00, 1.00, 1.00),
	246: Color(0.31, 0.39, 0.50),
	247: Color(0.00, 0.00, 0.00),
	248: Color(0.50, 0.50, 0.50),
	249: Color(1.00, 0.00, 0.00),
	250: Color(0.00, 1.00, 0.00),
	251: Color(1.00, 1.00, 0.00),
	252: Color(0.00, 0.00, 1.00),
	253: Color(1.00, 0.00, 1.00),
	254: Color(0.00, 1.00, 1.00),
	255: Color(0.00, 0.00, 0.00),
}
var addballs = {}
var paintballs = {}
var omissions = {}
var project_ball = {}
var texture_list = []

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
		var got_color = color_chart.get(color)
		var got_outline_color = color_chart.get(outline_color)
		var paintball = PaintBallData.new(base, diameter_percent, Vector3(x,y,z), got_color, got_outline_color, outline, fuzz)
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
		var pos = Vector3(x, y, z)
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
		var color = color_chart.get(line.color)
		var l_color = color_chart.get(line.l_color)
		var r_color = color_chart.get(line.r_color)
		var line_data = LineData.new(line.start, line.end, line.start_thickness, line.end_thickness, line.fuzz, color, l_color, r_color)
		lines.append(line_data)
		
func get_balls(file: File):
	get_next_section(file, "Ballz Info")
	var parsed_lines = get_parsed_lines(file, ["color", "outline_color", "speckle", "fuzz", "outline", "size", "group", "texture"])
	var i = 0
	for line in parsed_lines:
		var color = color_chart.get(line.color)
		var outline_color = color_chart.get(line.outline_color)
		var bd = BallData.new(line.size, Vector3.ZERO, i, color, line.color, outline_color, line.outline, line.fuzz, 0.0, line.group, line.texture)
		self.balls[i] = bd
		i += 1

func get_addballs(file: File):
	get_next_section(file, "Add Ball")
	var parsed_lines = get_parsed_lines(file, ["base", "x", "y", "z", "color", "outline_color", "speckle", "fuzz", "group", "outline", "size", "body_area", "add_group", "texture"])
	var max_ball_num = balls.keys().max() + 1
	for line in parsed_lines:
		var color = color_chart.get(line.color)
		var outline_color = color_chart.get(line.outline_color)
		var pos = Vector3(line.x, line.y, line.z)
		var ball = AddBallData.new(line.base, max_ball_num, line.size, pos, color, outline_color, line.outline, line.fuzz, 0, line.group, line.body_area)
		addballs[max_ball_num] = ball
		max_ball_num += 1
		
func get_project_balls(file: File):
	get_next_section(file, "Project Ball")
	var parsed_lines = get_parsed_lines(file, ["base", "projected", "amount"])
	for line in parsed_lines:
		var ar = project_ball.get(line.projected, [])
		ar.append({base = line.base, amount = line.amount})
		project_ball[line.projected] = ar

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
