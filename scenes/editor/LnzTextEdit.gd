extends TextEdit

var is_user_file = false
var filepath: String

signal file_saved(filepath)

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
		emit_signal("file_saved", filepath)
		print("saved file")
		
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
		var x = file.open(possible_file_name, File.WRITE)
		file.store_string(text)
		file.close()
		filepath = possible_file_name
		is_user_file = true
