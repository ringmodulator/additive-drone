s.boot;

/*
Initial goals for this piece:

- Synth is a simple additive instrument with an ASR envelope that includes an initial silent pause.
- Piece will be made up of loops that fall out of alignment because the pause and sustain segments are randomized.
- There will be a "score" that says when each loop starts and ends and specifies frequency and any other parameters.
- Piece will use the same tuning system as "7 limit drone".
*/

(
// Drone instrument
// Plays a note at a given frequency
// Envelope has initial silent pause, 4 second attack, parameterized sustain time, 4 second fade.

SynthDef(
	\drone,
	{
	| out = 0, freq = 440, amp = 0.1, pause = 1, sus = 3, pan = 1 |
	var env = Env.new(levels: [0, 0, 1, 1, 0], times: [pause, 4, sus, 4], curve: \sine);
	// Nice, simple additive synth stolen from Stanford SC "gentle introduction" and modified a bit
	var snd = Mix.fill(12, {
			arg counter; // counts iterations starting from zero
			var partial = counter + 1; // don't start partials from zero
			SinOsc.ar(partial * freq * rrand(0.999, 1.001), mul: 1/partial.squared) * (amp * env.kr(doneAction: 2));});
		snd = Pan2.ar(snd, SinOsc.kr(pan));
		Out.ar(out, snd);
	}
).add;

)

(
// Calculate note frequencies
var root = 65.41, // Low C
minorSecond = root * (15/14),
majorSecond = root * (8/7),
septimalMinorThird = root * (7/6), // tune minor third in logic to this
minorThird = root * (6/5),
majorThird = root * (5/4),
perfectFourth = root * (4/3),
augmentedFourth = root * (7/5), // Logic piano is tuned to this tritone, not 10/7
diminishedFifth = root * (10/7),
perfectFifth = root * (3/2),
minorSixth = root * (8/5),
majorSixth = root * (5/3),
minorSeventh = root * (7/4),
majorSeventh = root * (15/8),
out = 0,
freq = 880,
pause = rrand(1.0, 5.0),
sus = rrand(4.0, 8.0),
dur = rrand(0.1, 0.5),
pan = 0,

//Score
// [freq, duration, wait time to start next loop]

score = [
	// Thick root/fifth drone for duration of piece. Octaves introduce gradually.
	[root, 0.1, 1200, 0],
	[root, 0.1, 1200, 0],
	[perfectFifth, 0.1, 1200, 0],
	[perfectFifth, 0.1, 1200, 60],

	// Second group of root/fifth drones
	[root * 2, 0.1, 1140, 0],
	[root * 2, 0.1, 1140, 0],
	[perfectFifth * 2, 0.1, 1140, 0],
	[perfectFifth * 2, 0.1, 1140, 60],

	// Third group of root/fifth drones
	[root * 4, 0.025, 1080, 0],
	[root * 4, 0.025, 1080, 0],
	[perfectFifth * 4, 0.025, 1080, 0],
	[perfectFifth * 4, 0.025, 1080, 60],

	// Fourth group of root/fifth drones
	[root * 8, 0.01, 1020, 0],
	[root * 8, 0.01, 1020, 0],
	[perfectFifth * 8, 0.01, 1020, 0],
	[perfectFifth * 8, 0.01, 1020, 60],

	// Introduce notes in chord, then rotate through octaves.
	// Round 1
	// Septimal minor third
	[septimalMinorThird * 2, 0.05, 180, 0],
	[septimalMinorThird * 2, 0.05, 180, 60],

	// Perfect fourth
	[perfectFourth * 4, 0.01, 180, 0],
	[perfectFourth * 4, 0.01, 180, 60],

	// Minor seventh
	[minorSeventh * 8, 0.005, 180, 0],
	[minorSeventh * 8, 0.005, 180, 60],


    // Round 2
	// Septimal minor third
	[septimalMinorThird * 4, 0.01, 180, 0],
	[septimalMinorThird * 4, 0.01, 180, 60],

	// Perfect fourth
	[perfectFourth * 8, 0.005, 180, 0],
	[perfectFourth * 8, 0.005, 180, 60],

	// Minor seventh
	[minorSeventh * 2, 0.05, 180, 0],
	[minorSeventh * 2, 0.05, 180, 60],


	// Round 3
	// Septimal minor third
	[septimalMinorThird * 8, 0.005, 180, 0],
	[septimalMinorThird * 8, 0.005, 180, 60],

	// Perfect fourth
	[perfectFourth * 2, 0.05, 180, 0],
	[perfectFourth * 2, 0.05, 180, 60],

	// Minor seventh
	[minorSeventh * 4, 0.01, 180, 0],
	[minorSeventh * 4, 0.01, 180, 60],

	// Round 4 (repeat first)
	// Septimal minor third
	[septimalMinorThird * 2, 0.05, 180, 0],
	[septimalMinorThird * 2, 0.05, 180, 60],

	// Perfect fourth
	[perfectFourth * 4, 0.01, 180, 0],
	[perfectFourth * 4, 0.01, 180, 60],

	// Minor seventh
	[minorSeventh * 8, 0.005, 180, 0],
	[minorSeventh * 8, 0.005, 180, 60],


	// Very high root/fifth drones
	[root * 16, 0.005, 240, 0],
	[root * 16, 0.005, 240, 0],
	[perfectFifth * 16, 0.005, 240, 0],
	[perfectFifth * 16, 0.005, 240, 0],
];

r = Routine({
	score.do({|note, c|
		var freq = note[0],
		amp = note[1],
		loopDur = note[2],
		waitTime = note[3],
		pause = rrand(1.0, 5.0),
		sus = rrand(4.0, 8.0),
		pan = rrand(-0.5, 0.5),
		dur = pause + sus + 8,
		repeats = (loopDur/dur).round;

		("Note " ++ (c + 1)).postln;
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
			\amp, amp,
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

r.play