extends Node2D
## This is meant for having signals that can come from multiple instance of the same class [br]
##
## Only add signals in this file

## Emit when the player clicked on a valid room of the MapUI
signal clicked_next_room_on_map(clicked_room: RoomUI)

