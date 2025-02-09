extends Node
class_name HandSignalConnector

##Emitted when the player uuses your hand. Can be usable for making non-launchable hands such as the flare gun work.
signal hand_used
##Emitted when the player launches your hand. If your hand is not launchable, this signal does nothing.
signal hand_launched
##Emitted when a hand is launched and reaches its target. If your hand is not launchable, this signal does nothing.
signal hand_reached_target
##Emitted when your hand finishes retracting and is reatached to the grabapck.  If your hand is not launchable, this signal does nothing.
signal hand_finished_retract
##Emitted when your hand starts to retract. If your hand is not launchable, this signal does nothing.
signal hand_started_retract

func unused():
	emit_signal("hand_used")
	emit_signal("hand_launched")
	emit_signal("hand_reached_target")
	emit_signal("hand_finished_retract")
	emit_signal("hand_started_retract")
