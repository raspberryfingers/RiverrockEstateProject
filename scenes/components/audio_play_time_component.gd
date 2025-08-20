# audio_play_timer_component.gd
# Extends Timer so that when the timer times out, it plays a sound effect.
extends Timer

# Editor Exports 
@export var audio_stream_player_2D: AudioStreamPlayer2D  # The sound player that will be triggered on timeout


# Signals 
func _on_timeout() -> void:
	# Play the assigned sound when the timer finishes
	audio_stream_player_2D.play()
