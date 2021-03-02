extends OptionButton

export var lnz = []

signal file_selected(file_name)
signal file_saved(file_name)

func _ready():
	var dir = Directory.new()
	dir.open("resources")
	dir.list_dir_begin()
	var filename = dir.get_next()
	var i = 0
	while(!filename.empty()):
		if filename.ends_with(".lnz"):
			lnz.append(filename)
			add_item(filename, i)
			i += 1
		filename = dir.get_next()

func _on_OptionButton_item_selected(index):
	var real_index = get_item_id(index)
	emit_signal("file_selected", lnz[real_index])

func _on_Button_pressed():
	emit_signal("file_selected", lnz[self.selected])

func _on_TextEdit_file_saved():
	emit_signal("file_saved", lnz[self.selected])
