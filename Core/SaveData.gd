extends Resource
class_name SaveData
## Resource that stores all our save data. See SaveManager for details on how this is used.

# Game version
var version: String = ProjectSettings.get_setting("application/config/version")

# Player save data
var player_data: PlayerPersistentData = null

# Card save data
var saved_deck: Array[CardBase] = []

