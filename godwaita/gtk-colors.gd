extends Control


const IMG_RECOLOR_KEY = 'accent_color'
# { TypeName: [icon_name,], }
const IMAGES = {
	'CheckBox': [
		'checked', 'checked_disabled', 'radio_checked',
		'radio_checked_disabled', 'unchecked', 'unchecked_disabled',
		'radio_unchecked', 'radio_unchecked_disabled'
	],
	'CheckButton': ['on', 'on_disabled', 'off', 'off_disabled'],
	'OptionButton': ['arrow'],
	'WindowDialog': ['close', 'close_highlight'],
	'Tree': ['checked'],
	'PopupMenu': ['radio_checked', 'checked']
}
# { color_key: [ [TypeName, box_name, [prop_name], (alpha_override)], ], }
const BOX_PROPS = {
	'window_fg_color': [
		['Button', 'normal', ['bg_color'], 0.2],
		['Button', 'hover', ['bg_color'], 0.3],
		['Button', 'pressed', ['bg_color'], 0.4],
		['Button', 'disabled', ['bg_color'], 0.1],
	],
	'window_bg_color': [
		['Panel', 'panel', ['bg_color']],
		['TabContainer', 'panel', ['bg_color']],
		['WindowDialog', 'panel', ['bg_color']],
		['PopupMenu', 'panel', ['bg_color']],
		['PopupDialog', 'panel', ['bg_color']],
	],
	'accent_color': [
		['ProgressBar', 'fg', ['bg_color']],
		['VSlider', 'slider', ['bg_color']],
		['HSlider', 'slider', ['bg_color']],
		['Button', 'focus', ['border_color']],
		['LineEdit', 'focus', ['border_color']],
		['TextEdit', 'focus', ['border_color']],
		['CheckButton', 'focus', ['border_color']],
		['CheckBox', 'focus', ['border_color']],
	],
	'card_bg_color': [
		['PanelContainer', 'panel', ['bg_color']],
		['PopupMenu', 'hover', ['bg_color']],
		['Tree', 'selected', ['bg_color']],
		['Tree', 'selected_focus', ['bg_color']],
		['VSeparator', 'separator', ['color']],
		['HSeparator', 'separator', ['color']],
		['VScrollBar', 'grabber', ['bg_color']],
		['VScrollBar', 'grabber_highlight', ['bg_color']],
		['VScrollBar', 'grabber_pressed', ['bg_color']],
		['HScrollBar', 'grabber', ['bg_color']],
		['HScrollBar', 'grabber_highlight', ['bg_color']],
		['HScrollBar', 'grabber_pressed', ['bg_color']],
	],
	'view_bg_color': [
		['LineEdit', 'normal', ['bg_color']],
		['TextEdit', 'normal', ['bg_color']],
		['ProgressBar', 'bg', ['bg_color']]
	]
}
# { color_key: { TypeName: [color_name,], }, }
const COLORS = {
	'accent_color': {
		'LineEdit': ['selection_color'],
		'TextEdit': ['selection_color'],
	},
	'accent_fg_color': {
		'LineEdit': ['font_color_selected'],
		'TextEdit': ['font_color_selected'],
	},
	'window_fg_color': {
		'Label': ['font_color'],
		'RichTextLabel': ['default_color'],
		'TabContainer': ['font_color'],
		'WindowDialog': ['title_color'],
		'PopupMenu': ['font_color'],
		'CheckBox': ['font_color'],
		'CheckButton': ['font_color'],
		'Tree': ['font_color', 'font_color_selected'],
		'FileDialog': ['file_icon_modulate', 'folder_icon_modulate'],
	},
	'card_fg_color': {
		'PanelContainer': ['font_color'],
	},
	'view_fg_color': {
		'LineEdit': ['font_color', 'cursor_color', 'clear_button_color'],
		'Button': ['font_color'],
		'TextEdit': ['font_color'],
		'ProgressBar': ['font_color']
	}
}


# colorizes img of type in theme with col
func colorize_texture(type: String, img: String, col: Color):
	var tex = theme.get_icon(img, type)
	var data = tex.get_data()

	data.lock()
	for x in range(data.get_width()):
		for y in range(data.get_height()):
			# recolor non-grayscale pixels
			var pix = data.get_pixel(x, y)
			if not (pix.a and pix.v and pix.s):
				continue

			# blend
			pix.h = col.h
			pix.s *= col.s
			pix.v *= col.v
			data.set_pixel(x, y, pix)

	data.unlock()
	tex = ImageTexture.new()
	tex.create_from_image(data)
	theme.set_icon(img, type, tex)


# sets multiple colors of type to value,
# automatically creates colors for other potential states
func set_colors(type: String, cols: Array, value: Color):
	for c in cols:
		for appendix in ['', '_fg', '_accel', '_separator']:
			theme.set_color(c + appendix, type, value)

		theme.set_color(
			c + '_focus', type,
			Color(value.r, value.g, value.b, max(value.a - 0.1, 0.1))
		)
		theme.set_color(
			c + '_bg', type,
			Color(value.r, value.g, value.b, max(value.a - 0.6, 0.1))
		)
		theme.set_color(
			c + '_disabled', type,
			Color(value.r, value.g, value.b, max(value.a - 0.7, 0.1))
		)
		theme.set_color(
			c + '_uneditable', type,
			Color(value.r, value.g, value.b, max(value.a - 0.7, 0.1))
		)
		theme.set_color(
			c + '_readonly', type,
			Color(value.r, value.g, value.b, max(value.a - 0.7, 0.1))
		)
		theme.set_color(
			c + '_hover', type,
			Color(value.r, value.g, value.b, max(value.a - 0.3, 0.1))
		)
		theme.set_color(
			c + '_pressed', type,
			Color(value.r, value.g, value.b, max(value.a - 0.5, 0.1))
		)


# sets multiple color props of type->box to value
func set_box_props(type: String, box: String, props: Array, value: Color):
	var stylebox = theme.get_stylebox(box, type)
	for prop in props:
		stylebox.set(prop, value)

	theme.set_stylebox(box, type, stylebox)


# changes theme colors based on user's gtk.css
func update_theme_colors():
	# try to read gtk.css
	var file = File.new()
	var path = OS.get_environment('XDG_CONFIG_HOME') + '/gtk-3.0/gtk.css'
	var ret_code = file.open(path, File.READ)
	if ret_code != OK:
		push_warning(
			'Failed to read gtk.css (' + str(ret_code)
			+ '), keeping default colors'
		)
		return

	# parse gtk.css
	for line in file.get_as_text().split('\n'):
		if not (line.begins_with('@def') and ('rgb' in line or '#' in line)):
			continue

		# prepare for color parsing
		var color_value = Color.transparent
		var key = ''
		line = line.replace('@define-color ', '')

		if 'rgb' in line:
			# convert rgb(); or rgba(); to Color
			var parts = line.split(' rgb')
			key = parts[0]
			var csv = parts[1].rstrip(');').lstrip('a(').replace(' ', '')
			var values = csv.split(',')

			color_value = Color8(
				int(values[0]), int(values[1]), int(values[2]),
				int(float(values[3]) * 255) if len(values) > 3 else 255
			)
		else:
			# convert hex to Color
			var parts = line.rstrip(';').split(' ')
			key = parts[0]
			color_value = Color(parts[-1])

		# recolor images
		if key == IMG_RECOLOR_KEY:
			for type in IMAGES:
				for img in IMAGES[type]:
					colorize_texture(type, img, color_value)

		# set font/misc colors
		for c in COLORS:
			if c == key:
				for item in COLORS[c]:
					set_colors(item, COLORS[c][item], color_value)

		# recolor appropriate boxes
		for c in BOX_PROPS:
			if c == key:
				for item in BOX_PROPS[c]:
					if len(item) > 3:
						color_value.a = item[3]
					set_box_props(item[0], item[1], item[2], color_value)

				break


func _ready():
	update_theme_colors()
