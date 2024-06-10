extends TextureProgressBar

@onready var previous_buff_label: Label = $"Previous buff"
@onready var next_buff_label: Label = $"Next buff"
@onready var current_xp_label: Label = $"Current XP"

## The filling of the bar will not go above 90%
const MAX_BAR_VALUE_VISUAL: float = 90

## The filling of the bar will not go below 10%
const MIN_BAR_VALUE_VISUAL: float = 10

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
	self.value = 10
	_update_progress_bar_text_on_new_level(XpManager.current_xp, XpManager.previous_xp_level, XpManager.next_xp_level, false)
	XpManager.xp_changed.connect(_choose_update_method)
	
## Choose between the methods to update the bar (since the visual change is different)
func _choose_update_method(current_xp: int, previous_xp: int, next_xp: int, level_up: bool) -> void:
	if level_up:
		_update_progress_bar_text_on_new_level(current_xp, previous_xp, next_xp, level_up)
	else:
		var bar_transition_duration: float = 1 
		_change_progress_bar_value(current_xp, bar_transition_duration, previous_xp, level_up)

## Update the value of the progress bar to fill it
func _change_progress_bar_value(new_xp: int, max_duration: float, previous_xp: int, level_up: bool) -> void:
	# first 10% are always filled
	current_xp_label.text = "%s XP" % new_xp
	var tween: Tween = create_tween()
	var final_value: float = MAX_BAR_VALUE_VISUAL
	if not level_up:
		final_value = MIN_BAR_VALUE_VISUAL + (new_xp - previous_xp) * xp_delta
	var duration: float = max_duration
	if not level_up:
		duration = max_duration * abs(final_value - self.value)/(MAX_BAR_VALUE_VISUAL - MIN_BAR_VALUE_VISUAL)
	else:
		duration = max_duration * (90 - self.value)/80
	tween.tween_property(self, "value", final_value, duration)
	await tween.finished

## When a new level of XP is reached, update the progress bar to display the information about the next level		
func _update_progress_bar_text_on_new_level(current_xp: int, previous_xp: int, next_xp: int, level_up: bool) -> void:
	# Calculate the amount by which the progress bar fills every time we win an XP point
	# Make it so that the bar uses only 80% of the total filling
	# which allows us to leave the first as always used and the last 10% as always empty
	var bar_transition_max_duration: float = 1
	if not level_up:
		bar_transition_max_duration = 0
	await _change_progress_bar_value(previous_xp, bar_transition_max_duration, previous_xp, level_up)
	xp_delta = 80 / (next_xp - previous_xp)
	# change opacity to transparent over 1s
	if level_up:
		await _tween_label_opacity([previous_buff_label, next_buff_label], 0, 0.5)
	# change strings to "Buff name \n xp_amount XP"
	if current_xp >= 1:
		previous_buff_string = "%s\n%s XP" % [XpManager.xp_levels[previous_xp][0], previous_xp]
	next_buff_string = "%s\n%s XP" % [XpManager.xp_levels[next_xp][0], next_xp]
	previous_buff_label.text = previous_buff_string
	next_buff_label.text = next_buff_string
	
	_change_progress_bar_value(current_xp, bar_transition_max_duration, previous_xp, false)
	
	# change opacity back to fully opaque
	if level_up:
		_tween_label_opacity([previous_buff_label, next_buff_label], 1, 0.5)
	

func _tween_label_opacity(labels_to_change: Array[Label], end_opacity: float, duration : float) -> void:
	var tween: Tween = create_tween().set_parallel(true)
	for label in labels_to_change:
		tween.tween_property(label, "modulate:a", end_opacity, duration)
	await tween.finished

