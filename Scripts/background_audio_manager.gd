extends AudioStreamPlayer

@export var _pitch_scale_min:float = 0.7
@export var _pitch_scale_max:float = 1.5
@export var _pitch_scale_per_second:float = 0.001

func _ready():
	self.pitch_scale = _pitch_scale_min

func _process(delta: float):
	if self.playing:
		self.pitch_scale = min(_pitch_scale_max,
			self.pitch_scale + _pitch_scale_per_second*delta)

func restart():
	self.play(0.)
	self.pitch_scale = _pitch_scale_min
