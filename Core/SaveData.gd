extends Resource
class_name SaveData
## Resource that stores all our save data. See SaveManager for details on how this is used.


# Player save data
var player_data: PlayerPersistentData = null

# Card save data
var saved_deck: Array[CardBase] = []

