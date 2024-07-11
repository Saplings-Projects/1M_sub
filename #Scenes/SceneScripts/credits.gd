extends Node2D

## All the possible team roles
enum Roles {
	Art,
	Design,
	Music,
	Programming,
	Testing,
	Writing,
	Special_thanks,
	Team_lead,
	Team_lead_design,
	Team_lead_music,
	Team_lead_prog,
	Team_lead_writing,
}

## Re-export of the global enum variable to type a shorter name
const sapling_type: GlobalEnums.SaplingType = GlobalEnums.SaplingType

## All the team members, their roles and their avatar
const TEAM_MEMBERS: Dictionary = {
	"Adrian": [[Roles.Team_lead_music, Roles.Music], sapling_type.Old],
	"Ago": [[Roles.Art], sapling_type.Maid],
	"Akatsukin": [[Roles.Design], sapling_type.Nerd],
	"Amamii": [[Roles.Art], sapling_type.Maid],
	"Arkhand": [[Roles.Music], sapling_type.None],
	"Atmama": [[Roles.Art], sapling_type.None],
	"Biosquid": [[Roles.Programming], sapling_type.None], #! no participation yet
	"Bishop": [[Roles.Programming], sapling_type.None],
	"Cheesyfrycook": [[Roles.Programming], sapling_type.None],
	"Dat": [[Roles.Art], sapling_type.None],
	"Dio": [[Roles.Art], sapling_type.None],
	"EndyStarBoy": [[Roles.Art], sapling_type.Milf],
	"Fork": [[Roles.Music], sapling_type.Maid], #! no participation yet
	"Hakase": [[Roles.Art], sapling_type.None],
	"Jason": [[Roles.Music], sapling_type.None], #! no participation yet
	"Jimance": [[Roles.Team_lead_writing, Roles.Writing], sapling_type.Old],
	"Jona": [[Roles.Programming], sapling_type.None],
	"Jusagi": [[Roles.Art], sapling_type.None],
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
	"ROBBERGON": [[Roles.Team_lead_design, Roles.Design], sapling_type.Snow],
	"Saphu": [[Roles.Art, Roles.Design], sapling_type.Sleepy],
	"Sappysque": [[Roles.Art], sapling_type.Emo],
	"Tomzkk": [[Roles.Design, Roles.Programming], sapling_type.Old],
	"Tradgore": [[Roles.Design, Roles.Writing], sapling_type.Sleepy],
	"Turtyo": [[Roles.Team_lead, Roles.Team_lead_prog, Roles.Programming], sapling_type.Gamer],
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
	"cool_in_1": 2.3,
	"emo_in_1": 0, #enters by the left, will need to wait for previous out animation to completely finish
	"gamer_in_1": 1.1,
	"maid_in_1": 0.7,
	"milf_in_1": 2.6,
	"nerd_in_1": 1.7,
	"old_in_1": 1.5,
	"sleepy_in_1": 0.4,
	"snow_in_1": 0.4,
}

## Time needed for an animation to free the space at the center of the screen [br]
## Delay the previous animation by this duration if the time it takes to reach the center is smaller
## than the time it takes the "out" animation to free the screen center
const ANIMATION_TIME_OUT_SCREEN_CENTER: Dictionary = {
	"cool_out_1": 1,
	"emo_out_1": 2.1,
	"gamer_out_1": 1.3,
	"maid_out_1": 0.5,
	"milf_out_1": 0.6,
	"nerd_out_1": 0.4,
	"old_out_1": 0.9,
	"sleepy_out_1": 2.2,
	"snow_out_1": 1.1,
}

## Launch the loop of the scene
func _ready() -> void:
	pass
	

## The main animation loop, controls the entry timing of all the saplings [br]
## This is done by controling the two animation player of the scene
func _animation_loop() -> void:
	pass
