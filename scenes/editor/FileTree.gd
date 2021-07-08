extends Tree

signal example_file_selected(filepath)
signal user_file_selected(filepath)

var examples: TreeItem
var local_storage: TreeItem
var root: TreeItem
var local_storage_textures: TreeItem

export var example_file_location = "res://resources/"
export var user_file_location = "user://resources/"
onready var rename_dialog = get_tree().root.get_node("Root/SceneRoot/RenameDialog") as WindowDialog
onready var preloader = get_tree().root.get_node("Root/ResourcePreloader") as ResourcePreloader

signal backup_file

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
	rescan_textures()

func _on_Tree_item_activated():
	var selected = get_selected() as TreeItem
	var filepath = selected.get_metadata(0)
	var parent = selected.get_parent() as TreeItem
	if parent == examples:
		emit_signal("example_file_selected", filepath)
	else:
		emit_signal("user_file_selected", filepath)
	release_focus()

func rescan(selected_filepath):
	if local_storage != null:
		root.remove_child(local_storage)
	local_storage = create_item(root, 1)
	local_storage.set_text(0, "Local Storage")
	scan_local_storage(selected_filepath)
	
func rescan_textures():
	var was_collapsed = true
	if local_storage_textures != null:
		was_collapsed = local_storage_textures.collapsed
		root.remove_child(local_storage_textures)
	local_storage_textures = create_item(root, 2)
	local_storage_textures.collapsed = was_collapsed
	local_storage_textures.set_text(0, "Local Textures")
	scan_local_textures()
	
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

func scan_local_textures():
	var dir2 = Directory.new()
	dir2.open(user_file_location + "/textures")
	dir2.list_dir_begin()
	filename = dir2.get_next()
	while(!filename.empty()):
		if filename.ends_with(".bmp"):
			var new_item = create_item(local_storage_textures)
			new_item.set_text(0, filename)
			new_item.set_metadata(0, user_file_location + filename)
			var img = Image.new()
			img.load(user_file_location + "/textures/" + filename, true, true)
			var tex = ImageTexture.new()
			tex.create_from_image(img, ImageTexture.FLAG_REPEAT)
			preloader.add_resource(filename, tex)
		filename = dir2.get_next()
	dir2.list_dir_end()

func _on_Tree_item_rmb_selected(position):
	$ItemPopupMenu.rect_global_position = position
	var item = get_selected() as TreeItem
	$ItemPopupMenu.set_item_disabled(0, item.get_parent() != local_storage)
	$ItemPopupMenu.set_item_disabled(1, item.get_parent() != local_storage)
	$ItemPopupMenu.set_item_disabled(2, item.get_parent() != local_storage)
	$ItemPopupMenu.popup()
	
func _on_ItemPopupMenu_id_pressed(id):
	if id == 0: # delete file
		var item = get_selected() as TreeItem
		var filepath = item.get_metadata(0)
		var dir = Directory.new()
		dir.remove(filepath)
		rescan(null)
	elif id == 1: # rename file
		var item = get_selected() as TreeItem
		var filepath = item.get_metadata(0) as String
		rename_dialog.popup()
		rename_dialog.get_node("LineEdit").text = filepath.get_file()
	elif id == 2: #back up
		emit_signal("backup_file")

func _on_RenameDialog_confirmed():
	var item = get_selected() as TreeItem
	var filepath = item.get_metadata(0) as String
	var dir = Directory.new()
	var new_filename = rename_dialog.get_node("LineEdit").text
	var new_filepath = filepath.replace(filepath.get_file(), new_filename)
	dir.rename(filepath, new_filepath)
	rescan(new_filepath)
	emit_signal("user_file_selected", new_filepath)


func _on_ItemPopupMenu_about_to_show():
	var clicked_item = get_selected() as TreeItem
	var textlnz = get_tree().root.get_node("Root/SceneRoot/HSplitContainer/HSplitContainer/TextPanelContainer/LnzTextEdit") as TextEdit
	var clicked_filepath = clicked_item.get_metadata(0) as String
	$ItemPopupMenu.set_item_disabled(2, !textlnz.filepath == clicked_filepath)

func _on_LnzTextEdit_file_backed_up():
	rescan(get_selected().get_metadata(0) as String)
