extends Tree

signal example_file_selected(filepath)
signal user_file_selected(filepath)

var examples: TreeItem
var local_storage: TreeItem
var root: TreeItem

export var example_file_location = "res://resources/"
export var user_file_location = "user://resources/"

func _ready():
	root = create_item()
	examples = create_item(root)
	examples.set_text(0, "Examples")
	
	var dir = Directory.new()
	dir.open(example_file_location)
	dir.list_dir_begin()
	var filename = dir.get_next()
	while(!filename.empty()):
		if filename.ends_with(".lnz"):
			var new_item = create_item(examples)
			new_item.set_text(0, filename)
			new_item.set_metadata(0, example_file_location + filename)
		filename = dir.get_next()
	dir.list_dir_end()

	rescan(null)

func _on_Tree_item_activated():
	var selected = get_selected() as TreeItem
	var filepath = selected.get_metadata(0)
	var parent = selected.get_parent() as TreeItem
	if parent == examples:
		emit_signal("example_file_selected", filepath)
	else:
		emit_signal("user_file_selected", filepath)

func rescan(selected_filepath):
	if local_storage != null:
		root.remove_child(local_storage)
	local_storage = create_item(root)
	local_storage.set_text(0, "Local Storage")
	scan_local_storage(selected_filepath)
	
func scan_local_storage(selected_filepath):
	var dir2 = Directory.new()
	dir2.open(user_file_location)
	dir2.list_dir_begin()
	filename = dir2.get_next()
	while(!filename.empty()):
		if filename.ends_with(".lnz"):
			var new_item = create_item(local_storage)
			new_item.set_text(0, filename)
			new_item.set_metadata(0, user_file_location + filename)
			if(user_file_location + filename == selected_filepath):
				new_item.select(0)
		filename = dir2.get_next()
	dir2.list_dir_end()
