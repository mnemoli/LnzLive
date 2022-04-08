extends TextEdit

var is_user_file = false
var filepath: String
var r = RegEx.new()

signal file_saved(filepath)
signal find_ball(ball_no)
signal file_backed_up()

func _ready():
	wrap_enabled = false
	r.compile("[-.\\d]+")

func _on_example_file_selected(filepath):
	var file = File.new()
	file.open(filepath, File.READ)
	text = file.get_as_text()
	self.filepath = filepath
	is_user_file = false
	file.close()

func _on_user_file_selected(filepath):
	var file = File.new()
	file.open(filepath, File.READ)
	text = file.get_as_text()
	self.filepath = filepath
	is_user_file = true
	file.close()

func _unhandled_key_input(event):
	if Input.is_key_pressed(KEY_CONTROL) and event.pressed and event.scancode == KEY_S:
		save_file()
		
func save_backup():
	if is_user_file:
		var dir = Directory.new()
		dir.open("user://")
		dir.make_dir("resources")
		var file = File.new()
		file.open(filepath.replace( ".lnz", "_backup.lnz"), File.WRITE)
		file.store_string(text)
		file.close()
	else:
		save_file()
		save_backup()
	emit_signal("file_backed_up")
		
func save_file():
	if is_user_file:
		var dir = Directory.new()
		dir.open("user://")
		dir.make_dir("resources")
		var file = File.new()
		file.open(filepath, File.WRITE)
		file.store_string(text)
		file.close()
	else:
		var dir = Directory.new()
		dir.open("user://")
		dir.make_dir("resources")
		var possible_file_name = filepath.replace("res://", "user://")
		var file = File.new()
		if file.file_exists(possible_file_name):
			possible_file_name = possible_file_name.replace(".lnz", str(OS.get_unix_time()) + ".lnz")
		var _possible_error = file.open(possible_file_name, File.WRITE)
		file.store_string(text)
		file.close()
		filepath = possible_file_name
		is_user_file = true
	emit_signal("file_saved", filepath)

func _on_Node_ball_selected(section, ball_no, is_addball, max_addball_no):
	# need to find line number for the ball
	var actual_start_point
	if section == Section.Section.BALL:
		if is_addball:
			actual_start_point = find_line_in_addball_section(ball_no - max_addball_no)
		else:
			actual_start_point = find_line_in_ball_section(ball_no)
	elif section == Section.Section.MOVE:
		if is_addball:
			actual_start_point = find_line_in_addball_section(ball_no - max_addball_no)
		else:
			actual_start_point = find_line_in_move_section(ball_no)
	elif section == Section.Section.PROJECT:
		actual_start_point = find_line_in_project_section(ball_no)
	elif section == Section.Section.LINE:
		actual_start_point = find_line_in_linez_section(ball_no)
	if actual_start_point == -1:
		return
	cursor_set_line(actual_start_point)
	cursor_set_column(0)
	center_viewport_to_cursor()

func find_line_in_ball_section(ball_no):
	var section_find = search('[Ballz Info]', 0, 0, 0)
	var start_point = section_find[SEARCH_RESULT_LINE] + 1
	return find_line_in_ball_or_addball_section(ball_no, start_point)
	
func find_line_in_addball_section(ball_no):
	var section_find = search('[Add Ball]', 0, 0, 0)
	var start_point = section_find[SEARCH_RESULT_LINE] + 1
	return find_line_in_ball_or_addball_section(ball_no, start_point)
	
func find_line_in_move_section(ball_no):
	var section_find = search('[Move]', 0, 0, 0)
	var current_line = cursor_get_line()
	var start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	var end_of_section = search('[', 0, start_of_section, 0)[SEARCH_RESULT_LINE]
	var start_point
	if current_line >= start_of_section and current_line < end_of_section:
		start_point = current_line
	else:
		start_point = start_of_section
	var i = 0
	while true:
		var looped = start_point + i
		var line = get_line(looped).lstrip(" ")
		if line.begins_with("["):
			if start_point == start_of_section:
				return start_of_section - 1
			else:
				start_point = start_of_section
				i = 0
				continue
		if line.begins_with(str(ball_no) + " "):
			break
		i += 1
	return start_point + i
		
	
func find_line_in_project_section(ball_no):
	var section_find = search('[Project Ball]', 0, 0, 0)
	var current_line = cursor_get_line()
	var start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	var end_of_section = search('[', 0, start_of_section, 0)[SEARCH_RESULT_LINE]
	var start_point
	if current_line >= start_of_section and current_line < end_of_section:
		start_point = current_line + 1
	else:
		start_point = start_of_section
	var i = 0
	while true:
		var looped = start_point + i
		var line = get_line(looped).lstrip(" ")
		var parsed_line = r.search_all(line)
		if line.begins_with("["):
			if start_point == start_of_section:
				return start_of_section - 1
			else:
				start_point = start_of_section
				i = 0
				continue
		if parsed_line[1].get_string() == str(ball_no):
			break
		
		i += 1
	return start_point + i
	
func find_line_in_linez_section(ball_no):
	var section_find = search('[Linez]', 0, 0, 0)
	var current_line = cursor_get_line()
	var start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	var end_of_section = search('[', 0, start_of_section, 0)[SEARCH_RESULT_LINE]
	var start_point
	if current_line >= start_of_section and current_line < end_of_section:
		start_point = current_line + 1
	else:
		start_point = start_of_section
	var i = 0
	while true:
		var looped = start_point + i
		var line = get_line(looped).lstrip(" ")
		var parsed_line = r.search_all(line)
		if line.begins_with("["):
			if start_point == start_of_section:
				return start_of_section - 1
			else:
				start_point = start_of_section
				i = 0
				continue
		if parsed_line[0].get_string() == str(ball_no) or parsed_line[1].get_string() == str(ball_no):
			break
		
		i += 1
	return start_point + i

func find_line_in_ball_or_addball_section(ball_no, start_point):
	var line = get_line(start_point)
	while true:
		if !line.lstrip(" ").begins_with(";"):
			break
		start_point += 1
		line = get_line(start_point)
	var i = 0
	var j = -1
	while true:
		line = get_line(start_point + i)
		if !line.lstrip(" ").begins_with(";"):
			j += 1
		if j == ball_no:
			break;
		i += 1
	return start_point + i


func _on_ToolsMenu_color_entire_pet(color_index, outline_color_index):
	var species = KeyBallsData.species
	var balls_to_exclude = []
	if species == KeyBallsData.Species.CAT:
		balls_to_exclude.append_array(KeyBallsData.eyes_cat.keys())
		balls_to_exclude.append_array(KeyBallsData.eyes_cat.values())
		balls_to_exclude.append_array(KeyBallsData.nose_cat)
		balls_to_exclude.append_array(KeyBallsData.tongue_cat)
	else:
		balls_to_exclude.append_array(KeyBallsData.eyes_dog.keys())
		balls_to_exclude.append_array(KeyBallsData.eyes_dog.values())
		balls_to_exclude.append_array(KeyBallsData.nose_dog)
		balls_to_exclude.append_array(KeyBallsData.tongue_dog)
		
	var section_find = search('[Ballz Info]', 0, 0, 0)
	var start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	var i = 0
	while true:
		if i in balls_to_exclude:
			i += 1
			continue
		var line = get_line(start_of_section + i).lstrip(" ")
		if line.begins_with(";"):
			i += 1
			continue
		elif line.begins_with("["):
			break
		# here the first number is color
		var parsed_line = r.search_all(line)
		var n = 0
		var final_line = ""
		for r_item in parsed_line:
			var item = r_item.get_string()
			if n == 0 and !color_index.empty():
				final_line += str(color_index) + " "
			elif n == 1 and !outline_color_index.empty():
				final_line += str(outline_color_index) + " "
			else:
				final_line += item + " "
			n += 1
		set_line(start_of_section + i, final_line)
		i += 1
	
	section_find = search('[Add Ball]', 0, 0, 0)
	start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	i = 0
	while true:
		if i + KeyBallsData.max_base_ball_num in balls_to_exclude:
			i += 1
			continue
		var line = get_line(start_of_section + i).lstrip(" ")
		if line.begins_with(";"):
			i += 1
			continue
		elif line.begins_with("["):
			break
		# here the fifth number is color
		var parsed_line = r.search_all(line)
		if int(parsed_line[0].get_string()) in balls_to_exclude:
			i += 1
			continue
		var n = 0
		var final_line = ""
		for r_item in parsed_line:
			var item = r_item.get_string()
			if n == 4 and !color_index.empty():
				final_line += str(color_index) + " "
			elif n == 5 and !outline_color_index.empty():
				final_line += str(outline_color_index) + " "
			else:
				final_line += item + " "
			n += 1
		set_line(start_of_section + i, final_line)
		i += 1
	save_file()


func _on_ToolsMenu_color_part_pet(core_ball_nos, color_index, outline_color_index, intended_part):
	var species = KeyBallsData.species
	var balls_to_exclude = []
	if species == KeyBallsData.Species.CAT:
		balls_to_exclude.append_array(KeyBallsData.eyes_cat.keys())
		balls_to_exclude.append_array(KeyBallsData.eyes_cat.values())
		balls_to_exclude.append_array(KeyBallsData.tongue_cat)
		if intended_part != "NOSE":
			balls_to_exclude.append_array(KeyBallsData.nose_cat)
	else:
		balls_to_exclude.append_array(KeyBallsData.eyes_dog.keys())
		balls_to_exclude.append_array(KeyBallsData.eyes_dog.values())
		balls_to_exclude.append_array(KeyBallsData.tongue_dog)
		if intended_part != "NOSE":
			balls_to_exclude.append_array(KeyBallsData.nose_dog)
		
	var section_find = search('[Ballz Info]', 0, 0, 0)
	var start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	var i = 0
	while true:
		if i in balls_to_exclude:
			i += 1
			continue
		var line = get_line(start_of_section + i).lstrip(" ")
		if line.begins_with(";"):
			i += 1
			continue
		elif line.begins_with("["):
			break
		if !(i in core_ball_nos):
			i += 1
			continue
		# here the first number is color
		var parsed_line = r.search_all(line)
		var n = 0
		var final_line = ""
		for r_item in parsed_line:
			var item = r_item.get_string()
			if n == 0 and !color_index.empty():
				final_line += str(color_index) + " "
			elif n == 1 and !outline_color_index.empty():
				final_line += str(outline_color_index) + " "
			else:
				final_line += item + " "
			n += 1
		set_line(start_of_section + i, final_line)
		i += 1
	
	section_find = search('[Add Ball]', 0, 0, 0)
	start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	i = 0
	while true:
		if i + KeyBallsData.max_base_ball_num in balls_to_exclude:
			i += 1
			continue
		var line = get_line(start_of_section + i).lstrip(" ")
		if line.begins_with(";"):
			i += 1
			continue
		elif line.begins_with("["):
			break
		# here the fifth number is color
		var parsed_line = r.search_all(line)
		if int(parsed_line[0].get_string()) in balls_to_exclude:
			i += 1
			continue
		if !(int(parsed_line[0].get_string()) in core_ball_nos):
			i+=1
			continue
		var n = 0
		var final_line = ""
		for r_item in parsed_line:
			var item = r_item.get_string()
			if n == 4 and !color_index.empty():
				final_line += str(color_index) + " "
			elif n == 5 and !outline_color_index.empty():
				final_line += str(outline_color_index) + " "
			else:
				final_line += item + " "
			n += 1
		set_line(start_of_section + i, final_line)
		i += 1
	save_file()
	
func get_corresponding_right_ball(left_ball_index):
	if left_ball_index < 67:
		if KeyBallsData.species == KeyBallsData.Species.CAT:
			if left_ball_index in [8, 9]:
				return left_ball_index + 2
			elif left_ball_index in [16, 17, 18] or left_ball_index in [49, 50, 51] or left_ball_index in [57, 58, 59]: # finger, toe, whisker
				return left_ball_index + 3
			else:
				return left_ball_index + 1
		else:
			return left_ball_index + 24
	else:
		return ball_map[ball_map[left_ball_index].corresponding_ball].new_ball_no
		
func get_corresponding_left_ball(right_ball_index):
	if right_ball_index < 67:
		if KeyBallsData.species == KeyBallsData.Species.CAT:
			if right_ball_index in [10, 11]:
				return right_ball_index - 2
			elif right_ball_index in [19, 20, 21] or right_ball_index in [52, 53, 54] or right_ball_index in [60, 61, 62]: # finger, toe, whisker
				return right_ball_index - 3
			else:
				return right_ball_index - 1
		else:
			return right_ball_index - 24
	else:
		return ball_map[ball_map[right_ball_index].corresponding_ball].new_ball_no

var ball_map = {}
	
func _on_ToolsMenu_copy_l_to_r():
	save_backup()
	
	# build up ball map
	ball_map = {}
	var section_find = search('[Ballz Info]', 0, 0, 0)
	var start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	var i = 0
	var left_balls_list = []
	var right_balls_list = []
	var middle_balls_list = []
	if KeyBallsData.species == KeyBallsData.Species.CAT:
		left_balls_list = KeyBallsData.symmetry_mode_hide_balls_cat.duplicate()
		right_balls_list = KeyBallsData.symmetry_mode_right_balls_cat.duplicate()
	else:
		left_balls_list = KeyBallsData.symmetry_mode_hide_balls_dog.duplicate()
		right_balls_list = KeyBallsData.symmetry_mode_right_balls_dog.duplicate()
	if left_balls_list.size() != right_balls_list.size():
		print("you made a mistake")
	for n in range(0,66):
		if !(n in left_balls_list or n in right_balls_list):
			middle_balls_list.append(n)
	while true:
		var line = get_line(start_of_section + i).lstrip(" ")
		# ignore comments for now
		if line.begins_with("["):
			break
		if i in left_balls_list or i in middle_balls_list:
			var d = {line = line, new_ball_no = i}
			if i in left_balls_list:
				var parsed_line = r.search_all(line)
				var mirrored_line = ""
				if parsed_line[4].get_string() in ["0", "-2"]: # outline needs to be mirrored
					var p = 0
					for item in parsed_line:
						if p == 4: #outline type
							if item.get_string() == "0":
								mirrored_line += "-2 "
							else:
								mirrored_line += "0 "
						else:
							mirrored_line += item.get_string() + " "
						p += 1
				else:
					mirrored_line = line
				d.corresponding_ball = get_corresponding_right_ball(i)
				set_line(start_of_section + d.corresponding_ball, mirrored_line)
				ball_map[d.corresponding_ball] = {line = mirrored_line, corresponding_ball = i, new_ball_no = d.corresponding_ball}
			else:
				d.corresponding_ball = null
			ball_map[i] = d
		i += 1
		
	# now the ball map has all the core balls in
	# lets set up the addballs
	
	section_find = search('[Add Ball]', 0, 0, 0)
	start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	i = 0
	var ball_no = 67
	var balls_to_add_temp = []
	var new_ball_count = 67
	while true:
		var line = get_line(start_of_section + i).lstrip(" ")
		# ignore comments for now
		if line.begins_with("[") or line.empty():
			break
		if ball_no <= 76:
			# utility addball, keep
			ball_map[ball_no] = {line = line, new_ball_no = new_ball_count}
			new_ball_count += 1
		else:
			var base_ball = int(line.split(" ", false, 1)[0])
			if base_ball in left_balls_list:
				left_balls_list.append(ball_no)
				ball_map[ball_no] = {line = line, new_ball_no = new_ball_count}
				new_ball_count += 1
				var corresponding_right_ball = get_corresponding_right_ball(base_ball)
				var parsed_line = r.search_all(line)
				var p = 0
				var new_right_ball_line = ""
				for item in parsed_line:
					if p == 0:
						new_right_ball_line += str(corresponding_right_ball) + " "
					elif p == 1: # reverse x value
						new_right_ball_line += str(int(item.get_string()) * -1.0) + " "
					elif p == 9 and item.get_string() in ["0", "-2"]: # outline
						if item.get_string() == "0":
							new_right_ball_line += "-2 "
						else:
							new_right_ball_line += "0 "
					else:
						new_right_ball_line += item.get_string() + " "
					p+=1
				balls_to_add_temp.append({line = new_right_ball_line, corresponding_ball = ball_no})
			elif base_ball in middle_balls_list:
				var parsed_line = r.search_all(line)
				var x_pos = int(parsed_line[1].get_string())
				if x_pos > 0.0: #left ball
					ball_map[ball_no] = {line = line, new_ball_no = new_ball_count}
					new_ball_count += 1
					left_balls_list.append(ball_no)
					var p = 0
					var new_right_ball_line = ""
					for item in parsed_line:
						if p == 1: # reverse x value
							new_right_ball_line += str(int(item.get_string()) * -1.0) + " "
						elif p == 9 and item.get_string() in ["0", "-2"]: # outline
							if item.get_string() == "0":
								new_right_ball_line += "-2 "
							else:
								new_right_ball_line += "0 "
						else:
							new_right_ball_line += item.get_string() + " "
						p+=1
					balls_to_add_temp.append({line = new_right_ball_line, corresponding_ball = ball_no})
				elif x_pos < 0.0: # right ball
					pass
					# do nothing
				else: # middle ball
					ball_map[ball_no] = {line = line, new_ball_no = new_ball_count}
					new_ball_count += 1
					middle_balls_list.append(ball_no)
		i+=1
		ball_no+=1
	var add_count = ball_map.keys().max() + 1
	for b in balls_to_add_temp:
		b.new_ball_no = new_ball_count
		ball_map[add_count] = b
		ball_map[b.corresponding_ball].corresponding_ball = add_count
		add_count += 1
		new_ball_count += 1
	
	var lines_in_addball_section = i
		
	# lines
	
	section_find = search('[Linez]', 0, 0, 0)
	start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	i = 0
	var lines_list = []
	while true:
		var line = get_line(start_of_section + i).lstrip(" ")
		# ignore comments for now
		if line.begins_with("[") or line.empty():
			break
		var parsed_line = r.search_all(line)
		var start_ball = int(parsed_line[0].get_string())
		var end_ball = int(parsed_line[1].get_string())
		if start_ball in left_balls_list or end_ball in left_balls_list:
			var final_line = ""
			if !ball_map.has(start_ball) or !ball_map.has(end_ball): # the ball got removed
				pass
			else:
				var final_start_ball = ball_map[start_ball].new_ball_no
				var additional_start_ball
				if start_ball in left_balls_list:
					additional_start_ball = get_corresponding_right_ball(start_ball)
				var final_end_ball = ball_map[end_ball].new_ball_no
				var additional_end_ball
				if end_ball in left_balls_list:
					additional_end_ball = get_corresponding_right_ball(end_ball)
				if additional_end_ball != null or additional_start_ball != null:
					if additional_end_ball == null:
						additional_end_ball = final_end_ball
					elif additional_start_ball == null:
						additional_start_ball = final_start_ball
					var p = 0
					for item in parsed_line:
						if p == 0:
							final_line += str(additional_start_ball) + " "
						elif p == 1:
							final_line += str(additional_end_ball) + " "
						else:
							final_line += item.get_string() + " "
						p+=1
					lines_list.append(final_line)
					final_line = ""
				var p = 0
				for item in parsed_line:
					if p == 0:
						final_line += str(final_start_ball) + " "
					elif p == 1:
						final_line += str(final_end_ball) + " "
					else:
						final_line += item.get_string() + " "
					p+=1
				lines_list.append(final_line)
		elif start_ball in middle_balls_list and end_ball in middle_balls_list:
			var final_line = ""
			if !ball_map.has(start_ball) or !ball_map.has(end_ball): # the ball got removed
				pass
			else:
				var final_start_ball = ball_map[start_ball].new_ball_no
				var final_end_ball = ball_map[end_ball].new_ball_no
				var p = 0
				for item in parsed_line:
					if p == 0:
						final_line += str(final_start_ball) + " "
					elif p == 1:
						final_line += str(final_end_ball) + " "
					else:
						final_line += item.get_string() + " "
					p+=1
				lines_list.append(final_line)
		i += 1
	
	var lines_in_linez_section = i
	
	# deal with moves. only need to care about base balls
	section_find = search('[Move]', 0, 0, 0)
	start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	i = 0
	var moves_list = []
	while true:
		var line = get_line(start_of_section + i).lstrip(" ")
		# ignore comments for now
		if line.begins_with("[") or line.empty():
			break
		var parsed_line = r.search_all(line)
		var move_ball_no = int(parsed_line[0].get_string())
		if move_ball_no in left_balls_list:
			moves_list.append(line)
			var final_line = ""
			var p = 0
			for item in parsed_line:
				if p == 0:
					final_line += str(get_corresponding_right_ball(move_ball_no)) + " "
				elif p == 1:
					final_line += str(int(item.get_string()) * -1.0) + " "
				else:
					final_line += item.get_string() + " "
				p += 1
			moves_list.append(final_line)
		elif move_ball_no in middle_balls_list:
			moves_list.append(line)
		i += 1
		
	var lines_in_move_section = i
	
	# projections
	section_find = search('[Project Ball]', 0, 0, 0)
	start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	i = 0
	var projections_list = []
	while true:
		var line = get_line(start_of_section + i).lstrip(" ")
		# ignore comments for now
		if line.begins_with("[") or line.empty():
			break
		var parsed_line = r.search_all(line)
		var base_ball_no = int(parsed_line[0].get_string())
		var move_ball_no = int(parsed_line[1].get_string())
		if move_ball_no in left_balls_list:
			if move_ball_no > 66:
				var new_ball_no = ball_map[move_ball_no].new_ball_no
				var final_line = ""
				var p = 0
				for item in parsed_line:
					if p == 0:
						final_line += str(ball_map[base_ball_no].new_ball_no) + " "
					elif p == 1:
						final_line += str(ball_map[move_ball_no].new_ball_no) + " "
					else:
						final_line += item.get_string() + " "
					p += 1
				projections_list.append(final_line)
			else:
				projections_list.append(line)
			var final_line = ""
			var p = 0
			for item in parsed_line:
				if p == 0:
					if base_ball_no in left_balls_list:
						final_line += str(get_corresponding_right_ball(base_ball_no)) + " "
					elif !base_ball_no in middle_balls_list: #right ball!
						final_line += str(get_corresponding_left_ball(base_ball_no)) + " "
					else:
						final_line += str(ball_map[base_ball_no].new_ball_no) + " "
				elif p == 1:
					if move_ball_no in left_balls_list:
						final_line += str(get_corresponding_right_ball(move_ball_no)) + " "
					else:
						final_line += str(ball_map[move_ball_no].new_ball_no) + " "
				else:
					final_line += item.get_string() + " "
				p += 1
			projections_list.append(final_line)
		elif move_ball_no in middle_balls_list:
			var final_line = ""
			var p = 0
			for item in parsed_line:
				if p == 0:
					if base_ball_no in left_balls_list:
						final_line += str(get_corresponding_right_ball(base_ball_no)) + " "
					elif !base_ball_no in middle_balls_list: #right ball!
						final_line += str(get_corresponding_left_ball(base_ball_no)) + " "
					else:
						final_line += str(ball_map[base_ball_no].new_ball_no) + " "
				elif p == 1:
					final_line += str(ball_map[move_ball_no].new_ball_no) + " "
				else:
					final_line += item.get_string()
				p += 1
			projections_list.append(final_line)
		i += 1
		
	var lines_in_projections_section = i
	
	# paintballs
	section_find = search('[Paint Ballz]', 0, 0, 0)
	start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	i = 0
	var paintballs_list = []
	while true:
		var line = get_line(start_of_section + i).lstrip(" ")
		# ignore comments for now
		if line.begins_with("[") or line.empty():
			break
		var parsed_line = r.search_all(line)
		var base_ball_no = int(parsed_line[0].get_string())
		if base_ball_no in left_balls_list:
			var new_base_ball_no = ball_map[base_ball_no].new_ball_no
			# add original line
			var final_line = ""
			var p = 0
			for item in parsed_line:
				if p == 0:
					final_line += str(new_base_ball_no) + " "
				else:
					final_line += item.get_string() + " "
				p += 1
			paintballs_list.append(final_line)
			# add flipped line
			final_line = ""
			p = 0
			for item in parsed_line:
				if p == 0:
					final_line += str(get_corresponding_right_ball(base_ball_no)) + " "
				elif p == 2:
					final_line += str(float(item.get_string()) * -1.0) +  " "
				else:
					final_line += item.get_string() + " "
				p += 1
			paintballs_list.append(final_line)
		elif base_ball_no in middle_balls_list:
			var x_pos = float(parsed_line[2].get_string())
			if x_pos < 0.0: # right ball do nothing
				pass
			else:
				var new_base_ball_no = ball_map[base_ball_no].new_ball_no
				# add original line
				var final_line = ""
				var p = 0
				for item in parsed_line:
					if p == 0:
						final_line += str(new_base_ball_no) + " "
					else:
						final_line += item.get_string() + " "
					p += 1
				paintballs_list.append(final_line)
				if x_pos > 0.0: # left side
					final_line = ""
					p = 0
					for item in parsed_line:
						if p == 0:
							final_line += str(new_base_ball_no) + " "
						elif p == 2:
							final_line += str(x_pos * -1.0) + " "
						else:
							final_line += item.get_string() + " "
						p += 1
					paintballs_list.append(final_line)
		i += 1
	
	var lines_in_paintball_section = i
	
	# remove all the addball lines!
	# in a really moronic way
	section_find = search('[Add Ball]', 0, 0, 0)
	start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	select(start_of_section, 0, start_of_section + lines_in_addball_section - 1, 999)
	cut()
	cursor_set_line(start_of_section)
	cursor_set_column(0)
	var final_text = ""
	for k in ball_map:
		if k > 66:
			final_text += ball_map[k].line + "\n"
	final_text = final_text.strip_edges()
	insert_text_at_cursor(final_text)
	
	# remove all the linez lines!
	# in a really moronic way
	section_find = search('[Linez]', 0, 0, 0)
	start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	select(start_of_section, 0, start_of_section + lines_in_linez_section - 1, 999)
	cut()
	cursor_set_line(start_of_section)
	cursor_set_column(0)
	final_text = ""
	for k in lines_list:
		final_text += k + "\n"
	final_text = final_text.strip_edges()
	insert_text_at_cursor(final_text)
	
	# remove all the moves lines!
	# in a really moronic way
	section_find = search('[Move]', 0, 0, 0)
	start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	select(start_of_section, 0, start_of_section + lines_in_move_section - 1, 999)
	cut()
	cursor_set_line(start_of_section)
	cursor_set_column(0)
	final_text = ""
	for k in moves_list:
		final_text += k + "\n"
	final_text = final_text.strip_edges()
	insert_text_at_cursor(final_text)
	
	# remove all the projections lines!
	# in a really moronic way
	section_find = search('[Project Ball]', 0, 0, 0)
	start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	select(start_of_section, 0, start_of_section + lines_in_projections_section - 1, 999)
	cut()
	cursor_set_line(start_of_section)
	cursor_set_column(0)
	final_text = ""
	for k in projections_list:
		final_text += k + "\n"
	final_text = final_text.strip_edges()
	insert_text_at_cursor(final_text)

	# remove all the paintballs lines!
	# in a really moronic way
	section_find = search('[Paint Ballz]', 0, 0, 0)
	start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	select(start_of_section, 0, start_of_section + lines_in_paintball_section - 1, 999)
	cut()
	cursor_set_line(start_of_section)
	cursor_set_column(0)
	final_text = ""
	for k in paintballs_list:
		final_text += k + "\n"
	final_text = final_text.strip_edges()
	insert_text_at_cursor(final_text)
	
	ball_map = {}
	
	save_file()

func _on_Tree_backup_file():
	save_backup()

func _on_ToolsMenu_add_ball(selected_visual_ball):
	var real_base_ball = selected_visual_ball.ball_no
	if selected_visual_ball.base_ball_no != -1:
		real_base_ball = selected_visual_ball.base_ball_no
		
	var section_find = search('[Add Ball]', 0, 0, 0)
	var start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	var i = 0
	while true:
		var line = get_line(start_of_section + i).lstrip(" ")
		# ignore comments for now
		if line.begins_with("[") or line.empty():
			break
		i+=1
	var lines_in_addball_section = i
	var new_ball_no = 67 + i
	var new_ball_cursor_position = start_of_section + lines_in_addball_section
	cursor_set_line(start_of_section + lines_in_addball_section)
	cursor_set_column(0)
	var position: Vector3
	if selected_visual_ball.base_ball_no != -1:
		position = selected_visual_ball.transform.origin * 1000.0
	else:
		position = Vector3.ZERO
	var new_addball_text = "%s %d %d %d %s %s 0 %s 0 %s 30 0 0 0 -1\n" % [real_base_ball, position.x, position.y, position.z, selected_visual_ball.color_index, selected_visual_ball.outline_color_index, selected_visual_ball.fuzz_amount, selected_visual_ball.old_outline]
	insert_text_at_cursor(new_addball_text)
	
#	# add line
	section_find = search('[Linez]', 0, 0, 0)
	start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	i = 0
	while true:
		var line = get_line(start_of_section + i).lstrip(" ")
		# ignore comments for now
		if line.begins_with("[") or line.empty():
			break
		i += 1
	cursor_set_line(start_of_section + i)
	cursor_set_column(0)
	var new_line_text = "%s %s 0 -1 -1 -1 95 95 -1 0\n" % [new_ball_no, selected_visual_ball.ball_no]
	insert_text_at_cursor(new_line_text)
	cursor_set_line(new_ball_cursor_position)
	center_viewport_to_cursor()
	
	save_file()

func _on_LnzTextEdit_gui_input(event):
	if event is InputEventKey and event.pressed and event.control and event.scancode == KEY_Q:
		#if in the balls or addballs section, use line number
		var nearest_section_start = search("[", SEARCH_BACKWARDS, cursor_get_line(), 0)
		var nearest_section = get_line(nearest_section_start[SEARCH_RESULT_LINE])
		if nearest_section == "[Ballz Info]":
			var line_number = cursor_get_line() - nearest_section_start[SEARCH_RESULT_LINE] - 1
			emit_signal("find_ball", line_number)
		elif nearest_section == "[Add Ball]":
			var line_number = cursor_get_line() - nearest_section_start[SEARCH_RESULT_LINE] + 66
			emit_signal("find_ball", line_number)
		else:
			emit_signal("find_ball", int(get_word_under_cursor()))

func _on_Node_addball_deleted(ball_no):
	# remove the addball line
	var line_no = find_line_in_addball_section(ball_no - 67)
	select(line_no, 0, line_no + 1, 0)
	cut()
	
	# all the addballs after this have now been renumbered
	# so we need to correct the linez, omissions, projections, paintballz
	# linez
	var section_find = search('[Linez]', 0, 0, 0)
	var start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	var i = 0
	while true:
		var line = get_line(start_of_section + i).lstrip(" ")
		# ignore comments for now
		if line.begins_with("[") or line.empty():
			break
		var parsed_line = r.search_all(line)
		var start_ball = int(parsed_line[0].get_string())
		var end_ball = int(parsed_line[1].get_string())
		if start_ball == ball_no or end_ball == ball_no:
			select(start_of_section + i, 0, start_of_section + i + 1, 0)
			cut()
			continue
		if start_ball > ball_no or end_ball > ball_no:
			var replaced_line = ""
			if start_ball > ball_no:
				start_ball -= 1
			if end_ball > ball_no:
				end_ball -= 1
			replaced_line += str(start_ball) + " " + str(end_ball) + " "
			var start_of_rest = parsed_line[2].get_start()
			replaced_line += line.substr(start_of_rest)
			set_line(start_of_section + i, replaced_line)
		i += 1
	
	# omissions
	section_find = search('[Omissions]', 0, 0, 0)
	start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	i = 0
	while true:
		var line = get_line(start_of_section + i).lstrip(" ")
		# ignore comments for now
		if line.begins_with("[") or line.empty():
			break
		if int(line) == ball_no:
			select(start_of_section + i, 0, start_of_section + i + 1, 0)
			cut()
			continue
		elif int(line) > ball_no:
			var replace_line = str(int(line) - 1)
			set_line(start_of_section + i, replace_line)
		i += 1
	
	# projections
	section_find = search('[Project Ball]', 0, 0, 0)
	start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	i = 0
	while true:
		var line = get_line(start_of_section + i).lstrip(" ")
		# ignore comments for now
		if line.begins_with("[") or line.empty():
			break
		var parsed_line = r.search_all(line)
		var move_ball_no = int(parsed_line[1].get_string())
		if move_ball_no == ball_no:
			select(start_of_section + i, 0, start_of_section + i + 1, 0)
			cut()
			continue
		elif move_ball_no > ball_no:
			var replace_line = "%s %s %s" % [parsed_line[0].get_string(), str(move_ball_no - 1), line.substr(parsed_line[2].get_start())]
			set_line(start_of_section + i, replace_line)
		i += 1
		
	# paintballz
	section_find = search('[Paint Ballz]', 0, 0, 0)
	start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	i = 0
	while true:
		var line = get_line(start_of_section + i).lstrip(" ")
		# ignore comments for now
		if line.begins_with("[") or line.empty():
			break
		
		var split = line.split(" ", false, 1)
		var base_ball_no = int(split[0])
		if base_ball_no == ball_no:
			select(start_of_section + i, 0, start_of_section + i + 1, 0)
			cut()
			continue
		elif base_ball_no > ball_no:
			var replace_line = "%s %s" % [str(base_ball_no), split[1]]
			set_line(start_of_section + i, replace_line)
		i += 1
		
	save_file()
	

func _on_ToolsMenu_recolor(all_recolor_info: Dictionary):
	save_backup()
	
	var recolor_info = all_recolor_info.recolors
	
	var species = KeyBallsData.species
	var balls_to_exclude = []
	if species == KeyBallsData.Species.CAT:
		balls_to_exclude.append_array(KeyBallsData.eyes_cat.keys())
		balls_to_exclude.append_array(KeyBallsData.eyes_cat.values())
		balls_to_exclude.append_array(KeyBallsData.nose_cat)
		balls_to_exclude.append_array(KeyBallsData.tongue_cat)
	else:
		balls_to_exclude.append_array(KeyBallsData.eyes_dog.keys())
		balls_to_exclude.append_array(KeyBallsData.eyes_dog.values())
		balls_to_exclude.append_array(KeyBallsData.nose_dog)
		balls_to_exclude.append_array(KeyBallsData.tongue_dog)
	
	if all_recolor_info.balls_on or all_recolor_info.ball_outlines_on:
		var section_find = search('[Ballz Info]', 0, 0, 0)
		var start_of_section = section_find[SEARCH_RESULT_LINE] + 1
		var i = 0
		while true:
			if i in balls_to_exclude:
				i += 1
				continue
			var line = get_line(start_of_section + i).lstrip(" ")
			if line.begins_with("[") or i > get_line_count():
				break
			if line.begins_with(";") or line.empty():
				i += 1
				continue
			# here the first number is color and second is outline col
			var parsed_line = r.search_all(line)
			var color = parsed_line[0].get_string()
			var outline_color = parsed_line[1].get_string()
			if (recolor_info.has(color) and all_recolor_info.balls_on) or (recolor_info.has(outline_color) and all_recolor_info.ball_outlines_on):
				var n = 0
				var final_line = ""
				for r_item in parsed_line:
					var item = r_item.get_string()
					if n == 0 and recolor_info.has(item) and all_recolor_info.balls_on:
						final_line += recolor_info[color] + " "
					elif n == 1 and recolor_info.has(item) and all_recolor_info.ball_outlines_on:
						final_line += recolor_info[outline_color] + " "
					else:
						final_line += item + " "
					n += 1
				set_line(start_of_section + i, final_line)
			i += 1
		
		section_find = search('[Add Ball]', 0, 0, 0)
		start_of_section = section_find[SEARCH_RESULT_LINE] + 1
		i = 0
		while true:
			if i + KeyBallsData.max_base_ball_num in balls_to_exclude:
				i += 1
				continue
			var line = get_line(start_of_section + i).lstrip(" ")
			if line.begins_with("[") or i > get_line_count():
				break
			if line.begins_with(";") or line.empty():
				i += 1
				continue
			# here the fifth number is color
			var parsed_line = r.search_all(line)
			if int(parsed_line[0].get_string()) in balls_to_exclude:
				i += 1
				continue
			var color = parsed_line[4].get_string()
			var outline_color = parsed_line[5].get_string()
			if (recolor_info.has(color) and all_recolor_info.balls_on) or (recolor_info.has(outline_color) and all_recolor_info.ball_outlines_on):
				var n = 0
				var final_line = ""
				for r_item in parsed_line:
					var item = r_item.get_string()
					if n == 4 and recolor_info.has(item) and all_recolor_info.balls_on:
						final_line += recolor_info[color] + " "
					elif n == 5 and recolor_info.has(item) and all_recolor_info.ball_outlines_on:
						final_line += recolor_info[outline_color] + " "
					else:
						final_line += item + " "
					n += 1
				set_line(start_of_section + i, final_line)
			i += 1
			
	if all_recolor_info.paintballs_on:
		var section_find = search('[Paint Ballz]', 0, 0, 0)
		var start_of_section = section_find[SEARCH_RESULT_LINE] + 1
		var i = 0
		while true:
			if i + KeyBallsData.max_base_ball_num in balls_to_exclude:
				i += 1
				continue
			var line = get_line(start_of_section + i).lstrip(" ")
			if line.begins_with("[") or i > get_line_count():
				break
			if line.begins_with(";") or line.empty():
				i += 1
				continue
			# here the sixth number is color
			var parsed_line = r.search_all(line)
			if int(parsed_line[0].get_string()) in balls_to_exclude:
				i += 1
				continue
			var color = parsed_line[5].get_string()
			if recolor_info.has(color):
				var n = 0
				var final_line = ""
				for r_item in parsed_line:
					var item = r_item.get_string()
					if n == 5:
						final_line += recolor_info[color] + " "
					else:
						final_line += item + " "
					n += 1
				set_line(start_of_section + i, final_line)
			i += 1
		
	if all_recolor_info.lines_on:
		var section_find = search('[Linez]', 0, 0, 0)
		var start_of_section = section_find[SEARCH_RESULT_LINE] + 1
		var i = 0
		while true:
			var line = get_line(start_of_section + i).lstrip(" ")
			# ignore comments for now
			if line.begins_with("[") or line.empty() or i > get_line_count():
				break
			var parsed_line = r.search_all(line)
			var mainColor = parsed_line[3].get_string()
			var lColor = parsed_line[4].get_string()
			var rColor = parsed_line[5].get_string()
			if recolor_info.has(mainColor) or recolor_info.has(lColor) or recolor_info.has(rColor):
				var n = 0
				var final_line = ""
				for item in parsed_line:
					if n == 3 and recolor_info.has(mainColor):
						final_line += recolor_info[mainColor] + " "
					elif n == 4 and recolor_info.has(lColor):
						final_line += recolor_info[lColor] + " "
					elif n == 5 and recolor_info.has(rColor):
						final_line += recolor_info[rColor] + " "
					else:
						final_line += item.get_string() + " "
					n += 1
				set_line(start_of_section + i, final_line)
			i += 1
	save_file()


func _on_ToolsMenu_move_head(x, y, z):
	var head_balls: Array
	if KeyBallsData.species == KeyBallsData.Species.CAT:
		head_balls = KeyBallsData.head_ext_cat.duplicate()
	else:
		head_balls = KeyBallsData.head_ext_dog.duplicate()
	var section_find = search('[Move]', 0, 0, 0)
	var start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	var i = 0
	while true:
		var line = get_line(start_of_section + i).lstrip(" ")
		if line.begins_with(";") or line.empty():
			i += 1
			continue
		elif line.begins_with("["):
			break
		var parsed_line = r.search_all(line)
		if !(parsed_line[0].get_string().to_int() in head_balls):
			i += 1
			continue
		head_balls.erase(parsed_line[0].get_string().to_int())
		var n = 0
		var final_line = ""
		for r_item in parsed_line:
			var item = r_item.get_string()
			if n == 1:
				final_line += str(item.to_int() + x) + " "
			elif n == 2:
				final_line += str(item.to_int() + y) + " "
			elif n == 3:
				final_line += str(item.to_int() + z) + " "
			else:
				final_line += item + " "
			n += 1
		set_line(start_of_section + i, final_line)
		i += 1
	
	# now insert any we missed
	for b in head_balls:
		cursor_set_line(start_of_section + i)
		cursor_set_column(0)
		insert_text_at_cursor(str(b) + " " + str(x) + " " + str(y) + " " + str(z) + "\n")
	
	save_file()

func _on_Node_ball_translation_changed(ball_no, new_position):
	var line_no
	if ball_no < 67:
		var done = false
		var section_find = search('[Move]', 0, 0, 0)
		var start_of_section = section_find[SEARCH_RESULT_LINE] + 1
		var i = 0
		while true:
			var line = get_line(start_of_section + i).lstrip(" ")
			if line.begins_with(";") or line.empty():
				i += 1
				continue
			elif line.begins_with("["):
				if !done:
					print("WARN - did not find move for head rotation for ball " + str(ball_no))
					cursor_set_line(start_of_section + i)
					cursor_set_column(0)
					insert_text_at_cursor(str(ball_no) + " " + str(int(new_position.x)) + " " + str(int(-new_position.y)) + " " + str(int(new_position.z)) + "\n")
				break
			# here the first number is color and second is outline col
			var parsed_line = r.search_all(line)
			if !(parsed_line[0].get_string().to_int() == ball_no):
				i += 1
				continue
			done = true
			var n = 0
			var final_line = ""
			for r_item in parsed_line:
				var item = r_item.get_string()
				if n == 1:
					final_line += str(int(new_position.x)) + " "
				elif n == 2:
					final_line += str(int(-new_position.y)) + " "
				elif n == 3:
					final_line += str(int(new_position.z)) + " "
				else:
					final_line += item + " "
				n += 1
			set_line(start_of_section + i, final_line)
			i += 1
	else:
		line_no = find_line_in_addball_section(ball_no - 67)
		var line = get_line(line_no)
		var parsed_line = r.search_all(line)
		var n = 0
		var final_line = ""
		for r_item in parsed_line:
			var item = r_item.get_string()
			if n == 1:
				final_line += str(int(new_position.x)) + " "
			elif n == 2:
				final_line += str(int(-new_position.y)) + " "
			elif n == 3:
				final_line += str(int(new_position.z)) + " "
			else:
				final_line += item + " "
			n += 1
		set_line(line_no, final_line)
	
func _on_Node_ball_translations_done():
	save_file()
