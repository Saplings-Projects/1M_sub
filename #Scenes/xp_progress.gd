extends TextureProgressBar

@onready var previous_buff_label: Label = $"Previous buff"
@onready var next_buff_label: Label = $"Next buff"
@onready var current_xp_label: Label = $"Current XP"

## The text to display for the previously reached buff
var previous_buff_string: String = ""

## The text to display for the next buff
var next_buff_string: String = ""

## The amount by which the progress bar fills every time we win an XP point
var xp_delta: float = 0.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.max_value = 100
	self.min_value = 0
	_update_progress_bar_text_on_new_level(XpManager.previous_xp_level, XpManager.next_xp_level)
	_change_progress_bar_value(XpManager.current_xp)
	XpManager.new_xp_level_reached.connect(_update_progress_bar_text_on_new_level)
	XpManager.xp_changed.connect(_change_progress_bar_value)
	

## Update the value of the progress bar to fill it
func _change_progress_bar_value(new_xp: int) -> void:
	# first 10% are always filled
	current_xp_label.text = "%s XP" % new_xp
	self.value = 10 + (new_xp - XpManager.previous_xp_level) * xp_delta
	

## When a new level of XP is reached, update the progress bar to display the information about the next level		
func _update_progress_bar_text_on_new_level(previous_xp: int, next_xp: int) -> void:
	# Calculate the amount by which the progress bar fills every time we win an XP point
	# Make it so that the bar uses only 80% of the total filling
	# which allows us to leave the first as always used and the last 10% as always empty
	xp_delta = 80 / (next_xp - previous_xp)
	# change strings to "Buff name \n xp_amount XP"
	if previous_xp >= 1:
		previous_buff_string = "%s\n%s XP" % [XpManager.xp_levels[previous_xp][0], previous_xp]
	next_buff_string = "%s\n%s XP" % [XpManager.xp_levels[next_xp][0], next_xp]
	previous_buff_label.text = previous_buff_string
	next_buff_label.text = next_buff_string
	# reset the progress bar to 10% filled
	_change_progress_bar_value(XpManager.current_xp)

