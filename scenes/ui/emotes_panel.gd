# EmotePanel.gd
# Handles playing emote animations for a character, including idle emotes.
extends Panel

# References to nodes
@onready var animated_sprite_2d: AnimatedSprite2D = $Emote/AnimatedSprite2D
@onready var emote_idle_timer: Timer = $EmoteIdleTimer

# List of idle emote animations
var idle_emotes: Array = ["emote_1_idle", ] 

func _ready() -> void:
	# Play the default idle emote on ready
	animated_sprite_2d.play("emote_1_idle")


# Play a specific emote animation
func play_emote(animation: String) -> void: 
	animated_sprite_2d.play(animation)


# Triggered when the idle timer times out
func _on_emote_idle_timer_timeout() -> void:
	# Pick a random idle emote from the list
	var index = randi_range(0, 0)
	var emote = idle_emotes[index]
	
	# Play the selected idle emote
	animated_sprite_2d.play(emote)
