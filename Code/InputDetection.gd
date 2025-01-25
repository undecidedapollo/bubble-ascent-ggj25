extends Node

func is_pressed(action: StringName) -> bool:
	var result = false
	for event: InputEvent in InputMap.action_get_events(action):
		if event is InputEventKey:
			result = Input.is_key_pressed(event.keycode)
		elif event is InputEventJoypadButton:
			result = Input.is_joy_button_pressed(event.device, event.button_index)
		elif event is InputEventMouseButton:
			result = Input.is_mouse_button_pressed(event.button_index)
		elif event is InputEventJoypadMotion:
			result = Input.get_action_strength(action)
				#add more elif to treat the type accordingly
		else:
			continue
		
		if result:
			break

	return result
