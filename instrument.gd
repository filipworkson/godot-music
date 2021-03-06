extends Node

export var polyphony : int = 32

var instrument_data = null
var voices = []
var playing = {}

func _ready():
	for i in range(polyphony):
		var voice = Voice.new()
		add_child(voice)
		voices.append(voice)
		voice.connect("stopped", self, "on_voice_stopped")

func play(note : int, volume : float):
	if volume > 0.0:
		print(note)
		if !voices.empty():
			var voice
			if playing.has(note):
				voice = playing[note]
			else:
				voice = voices.pop_back()
			for b in instrument_data.bags:
				if !b.has("sample"):
					continue
				if b.key_min <= note && b.key_max >= note:
					#print(b)
					voice.play_note(note, volume, b)
					break
			playing[note] = voice
		else:
			print("no available voice")
	elif playing.has(note):
		playing[note].stop_note()

func set_instrument(data):
	instrument_data = data

func on_voice_stopped(voice):
	voices.append(voice)
	playing.erase(voice.current_note)
	print("Voice released")
