extends VBoxContainer

@onready var beep_player = $GridContainer/BeepPlayer
@onready var cur_num = $CurNum


var number_sequence = Global.cur_num_seq

var cur_bot = null


func _ready() -> void:
	# Connect button signals
	for button in $GridContainer.get_children():
		if button.is_in_group("NumBtn"):
			button.connect("pressed", Callable(self, "_on_button_pressed_dial").bind((button.name.to_int())))
	
	load_bot()
	
	
func load_bot():
	cur_bot = load(Global.all_bots[Global.cur_num]).instantiate()
	self.add_child(cur_bot)
	
	cur_num.text = Global.cur_num #Show what number you're calling

func _on_button_pressed_dial(value):
	beep_player.play()
	if value == 9: #Set broken number button
		return
	if cur_bot.target != [] and len(cur_bot.cur_num) +1 > len(cur_bot.target[0]):
		cur_bot.cur_num = ""
		print("len is greater")
	if cur_bot != null and cur_bot.can_proceed:
		cur_bot.cur_num += str(value)
		cur_bot.input_changed()

func _on_button_hang_pressed() -> void:
	beep_player.play()
	Global.cur_num = ""
	Global.cur_num_seq = []
	Global.change_scene("res://game_scenes/watch_screen_dialing.tscn")
