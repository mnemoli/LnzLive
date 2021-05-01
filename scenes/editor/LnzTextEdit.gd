extends TextEdit

var is_user_file = false
var filepath: String
var r = RegEx.new()

signal file_saved(filepath)

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
		if line.begins_with(str(ball_no) + ", "):
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


func _on_ToolsMenu_color_entire_pet(color_index):
	var species = KeyBallsData.species
	var balls_to_exclude = []
	if species == KeyBallsData.Species.CAT:
		balls_to_exclude.append_array(KeyBallsData.eyes_cat.keys())
		balls_to_exclude.append_array(KeyBallsData.eyes_cat.values())
		balls_to_exclude.append_array(KeyBallsData.nose_cat)
	else:
		balls_to_exclude.append_array(KeyBallsData.eyes_dog.keys())
		balls_to_exclude.append_array(KeyBallsData.eyes_dog.values())
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
		# here the first number is color
		var color_break = line.find(" ")
		var line_without_color = line.substr(color_break)
		set_line(start_of_section + i, str(color_index) + " " + line_without_color)
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
		var n = 0
		var final_line = ""
		for r_item in parsed_line:
			var item = r_item.get_string()
			if n == 4:
				final_line += str(color_index) + " "
			else:
				final_line += item + " "
			n += 1
		set_line(start_of_section + i, final_line)
		i += 1
	save_file()


func _on_ToolsMenu_color_part_pet(core_ball_nos, color_index):
	var species = KeyBallsData.species
	var balls_to_exclude = []
	if species == KeyBallsData.Species.CAT:
		balls_to_exclude.append_array(KeyBallsData.eyes_cat.keys())
		balls_to_exclude.append_array(KeyBallsData.eyes_cat.values())
		balls_to_exclude.append_array(KeyBallsData.nose_cat)
	else:
		balls_to_exclude.append_array(KeyBallsData.eyes_dog.keys())
		balls_to_exclude.append_array(KeyBallsData.eyes_dog.values())
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
		var color_break = line.find(" ")
		var line_without_color = line.substr(color_break)
		set_line(start_of_section + i, str(color_index) + line_without_color)
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
		if !(int(parsed_line[0].get_string()) in core_ball_nos):
			i+=1
			continue
		var n = 0
		var final_line = ""
		for r_item in parsed_line:
			var item = r_item.get_string()
			if n == 4:
				final_line += str(color_index) + " "
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

var ball_map = {}
	
func _on_ToolsMenu_copy_l_to_r():
	# build up bal map
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
				d.corresponding_ball = get_corresponding_right_ball(i)
				set_line(start_of_section + d.corresponding_ball, line)
				ball_map[d.corresponding_ball] = {line = line, corresponding_ball = i, new_ball_no = d.corresponding_ball}
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
					else:
						new_right_ball_line += item.get_string() + " "
					p+=1
				balls_to_add_temp.append({line = new_right_ball_line, corresponding_ball = ball_no})
			elif base_ball in middle_balls_list:
				var parsed_line = r.search_all(line)
				var x_pos = int(parsed_line[1].get_string())
				if x_pos < 0.0: #left ball
					ball_map[ball_no] = {line = line, new_ball_no = new_ball_count}
					new_ball_count += 1
					left_balls_list.append(ball_no)
					var p = 0
					var new_right_ball_line = ""
					for item in parsed_line:
						if p == 1: # reverse x value
							new_right_ball_line += str(int(item.get_string()) * -1.0) + " "
						else:
							new_right_ball_line += item.get_string() + " "
						p+=1
					balls_to_add_temp.append({line = new_right_ball_line, corresponding_ball = ball_no})
				elif x_pos > 0.0: # right ball
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
					if additional_end_ball == 87 or final_end_ball == 87:
						print("asdfsdfasdf")
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
				if final_end_ball == 87:
					print("asdfsdfasdf")
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
				
				if final_end_ball == 87:
					print("asdfsdfasdf")
				if final_start_ball != start_ball or final_end_ball != end_ball:
					print("pew pew")
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
	
	# remove all the addball lines!
	# in a really moronic way
	section_find = search('[Add Ball]', 0, 0, 0)
	start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	select(start_of_section, 0, start_of_section + lines_in_addball_section - 1, 999)
	cut()
	cursor_set_line(start_of_section)
	center_viewport_to_cursor()
	var final_text = ""
	for k in ball_map:
		if k > 66:
			final_text += ball_map[k].line + "\n"
	insert_text_at_cursor(final_text)
	
	# remove all the linez lines!
	# in a really moronic way
	section_find = search('[Linez]', 0, 0, 0)
	start_of_section = section_find[SEARCH_RESULT_LINE] + 1
	select(start_of_section, 0, start_of_section + lines_in_linez_section - 1, 999)
	cut()
	cursor_set_line(start_of_section)
	center_viewport_to_cursor()
	final_text = ""
	for k in lines_list:
		final_text += k + "\n"
	insert_text_at_cursor(final_text)
	
	save_file()

