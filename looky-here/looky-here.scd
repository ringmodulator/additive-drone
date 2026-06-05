// Server.default.options.numInputBusChannels = 0; // For use with AirPlay
Server.default.options.memSize = 65536;
s.boot;

/* 

Version for 2026-03-05 Looky Here performance that includes a ring modulating looper for guitar.

Guitar tuning for this piece (low to high):
* D (root)
* A (fifth)
* D (root)
* F - 33.2 cents (septimal minor third)
* Bb - 35.1 cents (septimal subminor sixth)
* C - 31.2 cents (harmonic seventh)

*/

(
// Drone instrument
// Plays a note at a given frequency
// Envelope has initial silent pause, 4 second attack, parameterized sustain time, 8 second fade.

SynthDef(
	\drone,
	{
	| out = 8, freq = 440, amp = 0.1, pause = 1, sus = 3, pan = 0.5 |
	var env = Env.new(levels: [0, 0, 1, 1, 0], times: [pause, 4, sus, 8], curve: \sine);
	// Nice, simple dditive synth stolen from Stanford SC "gentle introduction" and modified a bit
	var snd = Mix.fill(12, {
			arg counter; // counts iterations starting from zero
			var partial = counter + 1; // don't start partials from zero
			SinOsc.ar(partial * freq * rrand(0.999, 1.001), mul: 1/partial.squared) * (amp * env.kr(doneAction: 2));});
		snd = Pan2.ar(snd, SinOsc.kr(pan));
		Out.ar(out, snd);
	}
).add;

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
		Out.ar(out, snd);
	}
).add;

)

(
// Calculate note frequencies
var root = 73.42, // Low D
minorSecond = root * (15/14),
majorSecond = root * (8/7),
septimalMinorThird = root * (7/6),
minorThird = root * (6/5),
majorThird = root * (5/4),
perfectFourth = root * (4/3),
augmentedFourth = root * (7/5),
diminishedFifth = root * (10/7),
perfectFifth = root * (3/2),
subminorSixth = root * (14/9),
minorSixth = root * (8/5),
majorSixth = root * (5/3),
minorSeventh = root * (7/4),
majorSeventh = root * (15/8),

// Set duration of piece in minutes and calculate total seconds and basic time unit (scaledMinute) of 1/20 of piece length. (The piece was originally 20 minutes long and scaledMinute that minute scaled to an arbitrary length.)

minutes = 21,
seconds = minutes * 60,
scaledMinute = seconds/20,

//Score
// [freq, amplitude, duration, wait time to start next loop, message]

score = [
	[septimalMinorThird, -20, seconds, 0, "septimal minor third (1)"],
	[septimalMinorThird, -20, seconds - (scaledMinute * 2), 0, "septimal minor third (1)"],
	[septimalMinorThird, -20, seconds - (scaledMinute * 4), 0, "septimal minor third (1)"],
	[septimalMinorThird, -20, seconds - (scaledMinute * 6), 0, "septimal minor third (1)"],
	[septimalMinorThird, -20, scaledMinute * 4, 0, "septimal minor third (1)"],
	[septimalMinorThird, -20, scaledMinute * 4, scaledMinute, "septimal minor third (1)"],

	[minorSeventh * 2, -28, seconds - (scaledMinute * 4), 0, "harmonic seventh (2)"],
	[minorSeventh * 2, -28, seconds - (scaledMinute * 6), 0, "harmonic seventh (2)"],
	[minorSeventh * 2, -28, seconds - (scaledMinute * 8), 0, "harmonic seventh (2)"],
	[minorSeventh * 2, -28, seconds - (scaledMinute * 10), scaledMinute, "harmonic seventh (2)"],

	[septimalMinorThird * 2, -24, seconds - (scaledMinute * 3), 0, "septimal minor third (2)"],
	[septimalMinorThird * 2, -24, seconds - (scaledMinute * 5), 0, "septimal minor third (2)"],
	[septimalMinorThird * 2, -24, seconds - (scaledMinute * 7), 0, "septimal minor third (2)"],
	[septimalMinorThird * 2, -24, seconds - (scaledMinute * 9), scaledMinute, "septimal minor third (2)"],

	[subminorSixth, -22, seconds - (scaledMinute * 5), 0, "subminor sixth (1)"],
	[subminorSixth, -22, seconds - (scaledMinute * 7), 0, "subminor sixth (1)"],
	[subminorSixth, -22, seconds - (scaledMinute * 9), 0, "subminor sixth (1)"],
	[subminorSixth, -22, seconds - (scaledMinute * 11), scaledMinute, "subminor sixth (1)"],

	[septimalMinorThird * 4, -32, seconds - (scaledMinute * 6), 0, "septimal minor third (3)"],
	[septimalMinorThird * 4, -32, seconds - (scaledMinute * 8), 0, "septimal minor third (3)"],
	[septimalMinorThird * 4, -32, seconds - (scaledMinute * 10), 0, "septimal minor third (3)"],
	[septimalMinorThird * 4, -32, seconds - (scaledMinute * 12), scaledMinute, "septimal minor third (3)"],

	[minorSeventh * 8, -46, seconds - (scaledMinute * 6), 0, "harmonic seventh (3)"],
	[minorSeventh * 8, -46, seconds - (scaledMinute * 8), 0, "harmonic seventh (3)"],
	[minorSeventh * 8, -46, seconds - (scaledMinute * 10), 0, "harmonic seventh (3)"],
	[minorSeventh * 8, -46, seconds - (scaledMinute * 12), scaledMinute, "LOOP INPUT DEAD"],

	[septimalMinorThird * 8, -40, seconds - (scaledMinute * 10), 0, "septimal minor third (4)"],
	[septimalMinorThird * 8, -40, seconds - (scaledMinute * 12), 0, "septimal minor third (4)"],
	[septimalMinorThird * 8, -40, seconds - (scaledMinute * 14), 0, "septimal minor third (4)"],
	[septimalMinorThird * 8, -40, seconds - (scaledMinute * 16), scaledMinute, "septimal minor third (4)"],

	[subminorSixth * 4, -36, seconds - (scaledMinute * 10), 0, "subminor sixth (2)"],
	[subminorSixth * 4, -36, seconds - (scaledMinute * 12), 0, "subminor sixth (2)"],
	[subminorSixth * 4, -36, seconds - (scaledMinute * 14), 0, "subminor sixth (2)"],
	[subminorSixth * 4, -36, seconds - (scaledMinute * 16), scaledMinute, "subminor sixth (2)"],

	[root, -20, seconds - (scaledMinute * 8), 0, "root (1)"],
	[root, -20, seconds - (scaledMinute * 8), 0, "root (1)"],
	[perfectFifth, -20, seconds - (scaledMinute * 8), 0, "fifth (1)"],
	[perfectFifth, -20, seconds - (scaledMinute * 8), scaledMinute, "fifth (1)"],

	[(minorSeventh * (3/2)), -28, seconds - (scaledMinute * 9), 0, "fifth above harmonic seventh (1)"],
	[(minorSeventh * (3/2)), -28, seconds - (scaledMinute * 10), 0, "fifth above harmonic seventh (1)"],
	[(minorSeventh * (3/2)), -28, seconds - (scaledMinute * 11), 0, "fifth above harmonic seventh (1)"],
	[(minorSeventh * (3/2)), -28, seconds - (scaledMinute * 12), scaledMinute, "fifth above harmonic seventh (1)"],

	[root * 2, -24, seconds - (scaledMinute * 10), 0, "root (2)"],
	[root * 2, -24, seconds - (scaledMinute * 10), 0, "root (2)"],
	[perfectFifth * 2, -24, seconds - (scaledMinute * 10), 0, "fifth (2)"],
	[perfectFifth * 2, -24, seconds - (scaledMinute * 10), scaledMinute, "fifth (2)"],

	[subminorSixth * (3/2) * 4, -40, seconds - (scaledMinute * 11), 0, "fifth above subminor sixth (3)"],
	[subminorSixth * (3/2) * 4, -40, seconds - (scaledMinute * 12), 0, "fifth above subminor sixth (3)"],
	[subminorSixth * (3/2) * 4, -40, seconds - (scaledMinute * 13), 0, "fifth above subminor sixth (3)"],
	[subminorSixth * (3/2) * 4, -40, seconds - (scaledMinute * 14), scaledMinute, "fifth above subminor sixth (3)"],

	[root * 4, -32, seconds - (scaledMinute * 12), 0, "root (3)"],
	[root * 4, -32, seconds - (scaledMinute * 12), 0, "root (3)"],
	[perfectFifth * 4, -32, seconds - (scaledMinute * 12), 0, "fifth (3)"],
	[perfectFifth * 4, -32, seconds - (scaledMinute * 12), scaledMinute, "fifth (3)"],

	[(minorSeventh * (3/2)) * 2, -32, seconds - (scaledMinute * 13), 0, "fifth above harmonic seventh (2)"],
	[(minorSeventh * (3/2)) * 2, -32, seconds - (scaledMinute * 14), 0, "fifth above harmonic seventh (2)"],
	[(minorSeventh * (3/2)) * 2, -32, seconds - (scaledMinute * 15), 0, "fifth above harmonic seventh (2)"],
	[(minorSeventh * (3/2)) * 2, -32, seconds - (scaledMinute * 16), scaledMinute, "fifth above harmonic seventh (2)"],

    [root * 8, -40, seconds - (scaledMinute * 14), 0, "root (4)"],
	[root * 8, -40, seconds - (scaledMinute * 14), 0, "root (4)"],
	[perfectFifth * 8, -40, seconds - (scaledMinute * 14), 0, "fifth (4)"],
	[perfectFifth * 8, -40, seconds - (scaledMinute * 14), scaledMinute, "fifth (4)"],

	[(minorSixth * (3/2)) * 8, -52, seconds - (scaledMinute * 15), 0, "fifth above subminor sixth (4)"],
	[(minorSixth * (3/2)) * 8, -52, seconds - (scaledMinute * 16), 0, "fifth above subminor sixth (4)"],
	[(minorSixth * (3/2)) * 8, -52, seconds - (scaledMinute * 17), 0, "fifth above subminor sixth (4)"],
	[(minorSixth * (3/2)) * 8, -52, seconds - (scaledMinute * 18), 0, "fifth above subminor sixth (4)"],
];

r = Routine({
	Synth.new(\fader, [\in, 8, \out, 0, \seconds, seconds]);
	Synth.new(\looper, [\out, 8, \seconds, seconds, \inputTime, scaledMinute * 5]);
	score.do({|note, c|
		var freq = note[0],
		db = note[1],
		loopDur = note[2],
		waitTime = note[3],
		message = note[4],
		out = 8,
		pause = rrand(1.0, 5.0),
		sus = rrand(4.0, 8.0),
		pan = rrand(0.1, 0.5),
		dur = pause + sus + 12,
		repeats = (loopDur/dur).round;

		("Note " ++ (c + 1) ++ ": "  ++ message).postln;
		("Frequency: " ++ freq).postln;
		("Approximate loop duration: " ++ loopDur).postln;
		("Note duration: " ++ dur).postln;
		("Repeats: " ++ repeats).postln;
		("Actual loop duration: " ++ (dur * repeats)).postln;
		("").postln;

		Pbind(
			\instrument, \drone,
			\out, out,
			\freq, Pseq([freq], repeats),
			\amp, dbamp(db),
			\pause, pause,
			\sus, sus,
			\dur, dur,
			\pan, pan
		).play;

		// wait to start next loop
		waitTime.wait;
	});
});
)

(
r.play;
s.record(duration: 1260)
)
