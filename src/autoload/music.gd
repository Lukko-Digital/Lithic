extends Node

signal start_music
signal ending_music
signal stop_music

@onready var main_track: AudioStreamPlayer = $MainTrack
@onready var ending_track: AudioStreamPlayer = $EndingTrack

func _on_start_music():
	main_track.play()


func _on_ending_music():
	main_track.stop()
	ending_track.play()


func _on_stop_music():
	main_track.stop()
	ending_track.stop()
