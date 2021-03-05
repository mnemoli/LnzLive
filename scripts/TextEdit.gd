extends TextEdit

var current_file_name
signal file_saved 

func open_file(file_name):
	current_file_name = file_name
	var file = File.new()
	file.open("res://resources/" + current_file_name, File.READ)
	text = file.get_as_text()

func save_file():
	var file = File.new()
	file.open("res://resources/" + current_file_name, File.WRITE)
	file.store_string(text)

func _unhandled_key_input(event):
	if Input.is_key_pressed(KEY_CONTROL) and event.pressed and event.scancode == KEY_S:
		save_file()
		emit_signal("file_saved")
		print("saved file")

func _on_OptionButton_file_selected(file_name):
	open_file(file_name)
