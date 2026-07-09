@tool
extends EditorPlugin

var context_menu_plugin:EditorContextMenuPlugin

func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	
	context_menu_plugin = load("uid://gn4benlmyuog").new()
	add_context_menu_plugin(EditorContextMenuPlugin.CONTEXT_SLOT_SCRIPT_EDITOR_CODE, context_menu_plugin)


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	
	if is_instance_valid(context_menu_plugin):
		remove_context_menu_plugin(context_menu_plugin)
