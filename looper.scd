(
SynthDef(
	\looper,
	{
	| out = 0, seconds = 1200, inputTime = 300|
	var env = Env.new(levels: [1, 1, 0, 0], times: [inputTime, 1, seconds - inputTime - 1], curve: \sine),
	    in = SoundIn.ar(0) * env.kr(doneAction: 2),
		delay1 = CombC.ar(in, 10, 10, 5000, 1),
		delay2 = CombC.ar(in, 10.6, 10.6, 5000, 1),
		snd = delay1 * delay2;
		Out.ar(out, snd);
	}
).add;
)

Synth.new(\looper, [\out, 0, \seconds, 1200, \inputTime, 300]);