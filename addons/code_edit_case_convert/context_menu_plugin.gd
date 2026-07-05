extends EditorContextMenuPlugin

enum Case {
	PASCAL,
	SNAKE,
	CAMEL,
	KEBAB,
}

func _popup_menu(paths):
	add_context_menu_item("convert to PascalCase", _on_convert.bind(Case.PASCAL))
	add_context_menu_item("convert to snake_case", _on_convert.bind(Case.SNAKE))
	add_context_menu_item("convert to camelCase", _on_convert.bind(Case.CAMEL))
	add_context_menu_item("convert to kebab-case", _on_convert.bind(Case.KEBAB))


func _on_convert(code_edit:CodeEdit, case:Case) -> void:
	
	code_edit.begin_complex_operation()
	code_edit.begin_multicaret_edit()
	
	for i in code_edit.get_caret_count():
		if code_edit.multicaret_edit_ignore_caret(i):
			continue
		
		var selected_text:String = code_edit.get_selected_text(i)
		if selected_text.is_empty():continue
		
		
		##のちの選択復元時に、キャレットが終点か起点かをメモ
		var caret_position_is_to_selection_position:bool = false
		if code_edit.get_selection_origin_line(i) == code_edit.get_selection_from_line(i)\
		and code_edit.get_selection_origin_column(i) == code_edit.get_selection_from_column(i):
			caret_position_is_to_selection_position = true
		
		##選択開始位置をメモ
		var from_line:int = code_edit.get_selection_from_line(i)
		var from_column:int = code_edit.get_selection_from_column(i)
		
		
		
		##変換した文字にする。この時キャレットはその文字の最後に移動する
		var converted_text:String = convert_text(selected_text, case)
		code_edit.insert_text_at_caret(converted_text , i)
		print(converted_text)
		
		
		##選択を復元
		if caret_position_is_to_selection_position:
			code_edit.select(from_line, from_column, code_edit.get_caret_line(i), code_edit.get_caret_column(i), i)
		else:
			code_edit.select(code_edit.get_caret_line(i), code_edit.get_caret_column(i), from_line, from_column, i)
		
	
	code_edit.end_multicaret_edit()
	code_edit.end_complex_operation()


func convert_text(text:String, case:Case) -> String:
	match case:
		Case.PASCAL:
			return text.to_pascal_case()
		Case.SNAKE:
			return text.to_snake_case()
		Case.CAMEL:
			return text.to_camel_case()
		Case.KEBAB:
			return text.to_kebab_case()
	
	return text
