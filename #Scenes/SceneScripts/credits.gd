extends Node2D

@onready var anim_in: AnimationPlayer = $AnimationPlayerIn
@onready var anim_out: AnimationPlayer = $AnimationPlayerOut
@onready var name_role_label: Label = $TextureRect/CenterContainer/Label

const CENTER_SCREEN_TIME: float = 2
const TEXT_FADE_IN_DURATION: float = 0.2
const TEXT_FADE_OUT_DURATION: float = 0.2
const COLOR_FADE_OUT: Color = Color(0,0,0,0)
const COLOR_FADE_IN: Color = Color(0,0,0,1)
const TIME_SCALING_TEXT_LENGTH: float = 0.05

## All the possible team roles
enum Roles {
	Art,
	Design,
	Music,
	Programming,
	Testing,
	Writing,
	Special_thanks,
	Team_lead_design,
	Team_lead_music,
	Team_lead_programming,
	Team_lead_writing,
	Project_lead,
}

## Re-export of the global enum variable to type a shorter name
const sapling_type: GlobalEnums.SaplingType = GlobalEnums.SaplingType

## All the team members, their roles and their avatar
const TEAM_MEMBERS: Dictionary = {
	"Adrian": [[Roles.Team_lead_music], sapling_type.Old],
	"Ago": [[Roles.Art], sapling_type.Maid],
	"Akatsukin": [[Roles.Design], sapling_type.Nerd],
	"Amamii": [[Roles.Art], sapling_type.Maid],
	"Arkhand": [[Roles.Music], sapling_type.Nerd],
	"Atmama": [[Roles.Art], sapling_type.None],
	"Biosquid": [[Roles.Programming], sapling_type.None], #! no participation yet
	"Bishop": [[Roles.Programming], sapling_type.None],
	"Cheesyfrycook": [[Roles.Programming], sapling_type.None],
	"Dat": [[Roles.Art], sapling_type.None],
	"Dio": [[Roles.Art], sapling_type.Sleepy],
	"EndyStarBoy": [[Roles.Art], sapling_type.Milf],
	"Fork": [[Roles.Music], sapling_type.Maid], #! no participation yet
	"Hakase": [[Roles.Art], sapling_type.None],
	"Jason": [[Roles.Music], sapling_type.None], #! no participation yet
	"Jimance": [[Roles.Team_lead_writing, Roles.Design], sapling_type.Old],
	"Jona": [[Roles.Programming], sapling_type.Gamer],
	"Jusagi": [[Roles.Art], sapling_type.Cool],
	"Kayessi": [[Roles.Testing], sapling_type.Old], #! no participation yet
	"Kebbie": [[Roles.Special_thanks], sapling_type.None],
	"Kotoschneep": [[Roles.Art], sapling_type.None],
	"Lann": [[Roles.Programming], sapling_type.Nerd],
	"Lunar": [[Roles.Art], sapling_type.Gamer],
	"Mikotey": [[Roles.Design], sapling_type.Maid],
	"Minik": [[Roles.Design], sapling_type.Emo],
	"Multi-arm": [[Roles.Programming], sapling_type.None],
	"nára": [[Roles.Art], sapling_type.Emo],
	"Palenque": [[Roles.Design], sapling_type.Nerd],
	"Papier": [[Roles.Programming], sapling_type.Milf],
	"Pterion": [[Roles.Art, Roles.Design], sapling_type.Maid],
	"ROBBERGON": [[Roles.Team_lead_design], sapling_type.Snow],
	"Saphu": [[Roles.Art, Roles.Design], sapling_type.Sleepy],
	"Sappysque": [[Roles.Art], sapling_type.Emo],
	"Tomzkk": [[Roles.Programming, Roles.Design], sapling_type.Old],
	"Tradgore": [[Roles.Writing, Roles.Design], sapling_type.Sleepy],
	"Turtyo": [[Roles.Project_lead, Roles.Team_lead_programming, Roles.Design], sapling_type.Gamer],
	"TyTy": [[Roles.Programming], sapling_type.Old],
	"Vsiiesk ": [[Roles.Art], sapling_type.Nerd],
	"Vyto (Vytonium)": [[Roles.Music], sapling_type.Old],
	"Walles": [[Roles.Design], sapling_type.Sleepy],
	"Zannmaster": [[Roles.Design], sapling_type.Milf],
}

## The time needed for an animation to reach the center of the screen [br]
## This is especially useful for animations that are very fast and we need to delay them [br]
## This lets the previous animation time to get out of the screen center
const ANIMATION_TIME_TO_SCREEN_CENTER: Dictionary = {
	"In/cool_in_1": 2.3,
	"In/emo_in_1": 0, #enters by the left, will need to wait for previous out animation to completely finish
	"In/gamer_in_1": 1.5,
	"In/maid_in_1": 0.7,
	"In/milf_in_1": 2.6,
	"In/nerd_in_1": 1.7,
	"In/old_in_1": 1.5,
	"In/sleepy_in_1": 0.4,
	"In/snow_in_1": 0.4,
}

## Time needed for an animation to free the space at the center of the screen [br]
## Delay the previous animation by this duration if the time it takes to reach the center is smaller
## than the time it takes the "out" animation to free the screen center
const ANIMATION_TIME_OUT_SCREEN_CENTER: Dictionary = {
	"Out/cool_out_1": 1,
	"Out/emo_out_1": 2.1,
	"Out/gamer_out_1": 1.3,
	"Out/maid_out_1": 0.5,
	"Out/milf_out_1": 0.6,
	"Out/nerd_out_1": 0.7,
	"Out/old_out_1": 0.9,
	"Out/sleepy_out_1": 2.2,
	"Out/snow_out_1": 1.1,
}

## Launch the loop of the scene
func _ready() -> void:
	name_role_label.text = ""
	name_role_label.add_theme_color_override("font_color", COLOR_FADE_OUT)
	_animation_loop()
	

## The main animation loop, controls the entry timing of all the saplings [br]
## This is done by controling the two animation player of the scene
func _animation_loop() -> void:
	var timer: SceneTreeTimer = get_tree().create_timer(1)
	var team_members_names: Array = _choose_member_order()
	#var team_members_names: Array = TEAM_MEMBERS.keys()
	#team_members_names.shuffle()
	await timer.timeout
	
	# play first animation with animation player in
	var first_member: String = team_members_names[0]
	var roles_and_avatar: Array = TEAM_MEMBERS[first_member]
	var roles: Array = roles_and_avatar[0]
	var roles_string: String = _role_array_to_string(roles)
	var previous_avatar: GlobalEnums.SaplingType = roles_and_avatar[1]
	var sapling_type_values: Array = GlobalEnums.SaplingType.values()
	while previous_avatar == sapling_type.None :
		previous_avatar = sapling_type_values[randi() % sapling_type_values.size()]
	var animation_name: String = _choose_animation(previous_avatar, true)
	anim_in.play(animation_name)
	await anim_in.animation_finished
	name_role_label.text = first_member + "\n" + roles_string
	var text_time_on_screen: float = _get_text_time_on_screen(name_role_label.text)
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(name_role_label, "theme_override_colors/font_color", COLOR_FADE_IN, TEXT_FADE_IN_DURATION)
	await get_tree().create_timer(text_time_on_screen).timeout
	
	var out_animation: String
	
	for member_name: String in team_members_names.slice(1):
		out_animation = _choose_animation(previous_avatar, false)
		var in_tween: Tween = get_tree().create_tween()
		in_tween.tween_property(name_role_label, "theme_override_colors/font_color", COLOR_FADE_OUT, TEXT_FADE_OUT_DURATION)
		await in_tween.finished
		anim_out.play(out_animation)
		name_role_label.text = ""
		anim_in.play("RESET")
		# check duration to know when to start the next in animation
		roles_and_avatar = TEAM_MEMBERS[member_name]
		var new_roles: Array = roles_and_avatar[0]
		var new_avatar: GlobalEnums.SaplingType = roles_and_avatar[1]
		var new_roles_string: String = _role_array_to_string(new_roles)
		while new_avatar == sapling_type.None :
			new_avatar = sapling_type_values[randi() % sapling_type_values.size()]
		var in_animation: String = _choose_animation(new_avatar, true)
		var in_signal: Signal
		# special rule for the emo sapling since it enters from the left
		# so we need to wait for the out animation to finish
		if new_avatar == sapling_type.Emo or previous_avatar == sapling_type.Emo:
			in_signal = anim_out.animation_finished
		else:
			var time_center_out: float = ANIMATION_TIME_OUT_SCREEN_CENTER[out_animation]
			var time_center_in: float = ANIMATION_TIME_TO_SCREEN_CENTER[in_animation]
			# calculate the time to leave between entry and exit to prevent sprites going into each other
			var time_difference: float = max (0, time_center_out - time_center_in)
			in_signal = get_tree().create_timer(time_difference).timeout
		await in_signal
		anim_in.play(in_animation)
		
		await anim_in.animation_finished
		var out_tween: Tween = get_tree().create_tween()
		name_role_label.text = member_name + "\n" + new_roles_string
		text_time_on_screen = _get_text_time_on_screen(name_role_label.text)
		out_tween.tween_property(name_role_label, "theme_override_colors/font_color", COLOR_FADE_IN, TEXT_FADE_IN_DURATION)
		await get_tree().create_timer(text_time_on_screen).timeout
		previous_avatar = new_avatar
		
		# loop and play all animations checking for entry / exit timing
	# play the last out animation
	out_animation = _choose_animation(previous_avatar, false)
	var last_tween: Tween = get_tree().create_tween()
	last_tween.tween_property(name_role_label, "theme_override_colors/font_color", COLOR_FADE_OUT, TEXT_FADE_OUT_DURATION)
	await last_tween.finished
	name_role_label.text = ""
	anim_out.play(out_animation)
	# put back the sprite for the animation going in, out of the screen
	anim_in.play("RESET")
		
		
func _choose_member_order() -> Array:
	var team_members_names: Array = TEAM_MEMBERS.keys()
	var teams: Dictionary = {
		Roles.Art: [],
		Roles.Design: [],
		Roles.Music: [],
		Roles.Programming: [],
		Roles.Testing: [],
		Roles.Writing: [],
		Roles.Special_thanks: [],
	}
	for member_name: String in team_members_names:
		var member_roles: Array = TEAM_MEMBERS[member_name][0]
		
		var team_to_add: Roles
		for role: Roles in Roles.values():
			if role in member_roles:
				match role:
					Roles.Design:
						# only add to team Design if it's the only role
						if member_roles.size() == 1:
							team_to_add = role
							break
					Roles.Team_lead_design:
						team_to_add = Roles.Design
						break
					Roles.Team_lead_music:
						team_to_add = Roles.Music
						break
					Roles.Team_lead_programming:
						team_to_add = Roles.Programming
						break
					Roles.Team_lead_writing:
						team_to_add = Roles.Writing
						break
					_:
						# for everyone else, their respective roles
							team_to_add = role
							break
		teams[team_to_add].append(member_name)
	# shuffle inside each team
	for team: Roles in teams:
		teams[team].shuffle()
	var final_list: Array = []
	for sub_team: Array in teams.values():
		final_list.append_array(sub_team)
	return final_list
		
func _choose_animation(avatar: GlobalEnums.SaplingType, is_in: bool) -> String:
	var avatar_name: String = GlobalEnums.SaplingType.keys()[avatar].to_lower()
	var animations_list: Array
	if is_in:
		animations_list = ANIMATION_TIME_TO_SCREEN_CENTER.keys()
	else:
		animations_list = ANIMATION_TIME_OUT_SCREEN_CENTER.keys()
	var animation_for_avatar: Array = animations_list.filter(
			func(list_name: String) -> bool: 
				return avatar_name in list_name
	)
	var chosen_animation: String = animation_for_avatar[randi() % animation_for_avatar.size()]
	return chosen_animation
	
func _role_array_to_string(roles: Array) -> String:
	var all_roles_string: PackedStringArray = []
	for role: Roles in roles:
		all_roles_string.append(_role_to_string(role))
	if roles.size() <= 2:
		return ", ".join(all_roles_string)
	else:
		return ", ".join(all_roles_string.slice(0, 2)) + "\n" + ", ".join(all_roles_string.slice(2))

func _role_to_string(role: Roles) -> String:
	return Roles.keys()[role].replace("_", " ") 
	

func _get_text_time_on_screen(text: String) -> float:
	return CENTER_SCREEN_TIME + text.length() * TIME_SCALING_TEXT_LENGTH
