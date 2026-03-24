Server.default.options.memSize = 65536;

(
SynthDef(
	\looper,
	{
	| out = 0, seconds = 1200, inputTime = 300|
	var env = Env.new(levels: [1, 1, 0, 0], times: [inputTime, 1, seconds - inputTime - 1], curve: \sine),
	    in = SoundIn.ar(0) * env.kr(doneAction: 2),
		freq = Pitch.kr(in),
		vol = Amplitude.kr(in, 0.5, 0.5),
		voice = LFTri.ar(freq: freq, mul: vol),
		delay1 = CombC.ar(voice, 10, 10, 5000, 1),
		delay2 = CombC.ar(voice, 10.6, 10.6, 5000, 1),
		snd = delay1 * delay2;
		Out.ar(out, snd);
	}
).add;
)

Synth.new(\looper, [\out, 0, \seconds, 1200, \inputTime, 300]);