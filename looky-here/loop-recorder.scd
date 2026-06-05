Server.default.options.memSize = 65536;
s.boot;

// Utility for recording guitar loop for Looky Here piece. Accepts audio input for 315 seconds, loops for 21 minutes. 

(

// Master fader synth
// Adds volume fades at the beginning and end of the piece
SynthDef(
	\fader,
	{
		|in = 8, out = 0, seconds = 1200|
		var sig, env;
		env = Env.new(levels: [0, 1, 1, 0], times: [30, seconds - 90, 60], curve: \sine);
		sig = In.ar(in, 2) * env.kr(doneAction: 2);
		Out.ar(out, sig);
	}
).add;

// Guitar ring modulating looper synth
SynthDef(
	\looper,
	{
	| out = 8, seconds = 1200, inputTime = 300|
	var env = Env.new(levels: [1, 1, 0, 0], times: [inputTime, 1, seconds - inputTime - 1], curve: \sine),
	    in = SoundIn.ar(0) * env.kr(doneAction: 2),
		// freq = Pitch.kr(in),
		// vol = Amplitude.kr(in, 0.5, 0.5),
		// voice = LFTri.ar(freq: freq, mul: vol),
		delay1 = CombC.ar(in, 10, 10, 5000, 0.8),
		delay2 = CombC.ar(in, 10.6, 10.6, 5000, 0.8),
		snd = delay1 * delay2;
		Out.ar(out, [snd, in]);
	}
).add;

)

(

// Set duration of piece in minutes and calculate total seconds and basic time unit (scaledMinute) of 1/20 of piece length. (The piece was originally 20 minutes long and scaledMinute that minute scaled to an arbitrary length.)

minutes = 21,
seconds = minutes * 60,
scaledMinute = seconds/20,

r = Routine({
	Synth.new(\looper, [\out, 8, \seconds, seconds, \inputTime, scaledMinute * 5]);
}
)

(
r.play;
s.record(duration: 1260)
)
