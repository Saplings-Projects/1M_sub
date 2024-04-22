extends Node
## Use this file to set variables that will basically give you god mode [br]
##
## This is useful for testing and debugging [br]
## ! Nothing in this file should be set to true for the release [br]
## All variable names should start with DEBUG_ [br]

## Player can move freely on the map without having to finish the current event or move in the range of its normal movement
const DEBUG_FREE_MOVEMENT: bool = false

# Clicking on any room will show the test dialog script, check res://Dialog/test.dialogue
const DEBUG_TEST_DIALOGUE: bool = false

## List of all debug variables [br]
## This is used to run the tests checking that every DEBUG is set to false
## ! If you add a new DEBUG variable, add it to this list
const LIST_OF_DEBUG: Array[bool] = [DEBUG_FREE_MOVEMENT, DEBUG_TEST_DIALOGUE]
