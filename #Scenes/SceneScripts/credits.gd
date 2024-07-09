extends Node2D

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

const sapling_type: GlobalEnums.SaplingType = GlobalEnums.SaplingType

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
	"Marineline": [[Roles.Programming], sapling_type.None], #! almost no contribution
	"Mikotey": [[Roles.Special_thanks], sapling_type.Maid],
	"Minik": [[Roles.Design], sapling_type.Emo],
	"Multi-arm": [[Roles.Programming], sapling_type.None],
	"nára": [[Roles.Art], sapling_type.Emo],
	"Palenque": [[Roles.Programming], sapling_type.Nerd], #! would make more sense as design
	"Papier": [[Roles.Programming], sapling_type.Milf],
	"Pterion": [[Roles.Art, Roles.Design], sapling_type.Maid],
	"ROBBERGON": [[Roles.Team_lead_design, Roles.Design], sapling_type.Snow],
	"Saphu": [[Roles.Art, Roles.Design], sapling_type.Sleepy],
	"Sappysque": [[Roles.Art], sapling_type.Emo],
	"Tomzkk": [[Roles.Design, Roles.Programming], sapling_type.Old],
	"Tradgore": [[Roles.Design, Roles.Writing], sapling_type.Sleepy],
	"TripleCubes": [[Roles.Programming], sapling_type.None], #! almost no contribution
	"Turtyo": [[Roles.Team_lead, Roles.Team_lead_prog, Roles.Programming], sapling_type.Gamer],
	"TyTy": [[Roles.Programming], sapling_type.Old],
	"Vsiiesk ": [[Roles.Art], sapling_type.Nerd],
	"Vyto (Vytonium)": [[Roles.Music], sapling_type.Old],
	"Walles": [[Roles.Design], sapling_type.None],
	"Zannmaster": [[Roles.Design], sapling_type.Milf],
}

## Launch the loop of the scene
func _ready() -> void:
	pass
	

## The main animation loop, controls the entry timing of all the saplings [br]
## This is done by controling the two animation player of the scene
func _animation_loop() -> void:
	pass
