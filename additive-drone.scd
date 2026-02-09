Server.default.options.numInputBusChannels = 0; // For use with AirPlay

s.boot;

/*
Initial goals for this piece:

- Synth is a simple additive instrument with an ASR envelope that includes an initial silent pause.
- Piece will be made up of loops that fall out of alignment because the pause and sustain segments are randomized.
- There will be a "score" that says when each loop starts and ends and specifies frequency and any other parameters.
- Piece will use the same tuning system as "7 limit drone".

Next goals:

- Add an overall volume envelope so that the piece fades out instead of the last loop just ending
- Add an output bus with filtering and/or other effects.

*/

(
// Drone instrument
// Plays a note at a given frequency
// Envelope has initial silent pause, 4 second attack, parameterized sustain time, 8 second fade.

SynthDef(
	\drone,
	{
	| out = 0, freq = 440, amp = 0.1, pause = 1, sus = 3, pan = 0.5 |
	var env = Env.new(levels: [0, 0, 1, 1, 0], times: [pause, 4, sus, 8], curve: \sine);
	// Nice, simple additive synth stolen from Stanford SC "gentle introduction" and modified a bit
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
		|in = 2, out = 0, seconds = 1200|
		var sig, env;
		env = Env.new(levels: [0, 1, 1, 0], times: [30, seconds - 90, 60], curve: \sine);
		sig = In.ar(in, 2) * env.kr(doneAction: 2);
		Out.ar(out, sig);
	}
).add;
)

(
// Calculate note frequencies
// var root = 61.73, // Low B
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
minorSixth = root * (8/5),
majorSixth = root * (5/3),
minorSeventh = root * (7/4),
majorSeventh = root * (15/8),

// Set duration of piece in minutes and calculate total seconds and basic time unit (scaledMinute) of 1/20 of piece length. (The piece was originally 20 minutes long and scaledMinute that minute scaled to an arbitrary length.)

minutes = 20,
seconds = minutes * 60,
scaledMinute = seconds/20,

//Score
// [freq, duration, wait time to start next loop]

score = [
	// Thick root/fifth drone for duration of piece. Octaves introduce gradually.
	[root, 0.1, seconds, 0, "root"],
	[root, 0.1, seconds, 0, "root"],
	[perfectFifth, 0.1, seconds, 0, "fifth"],
	[perfectFifth, 0.1, seconds, scaledMinute, "fifth"],

	// Second group of root/fifth drones
	[root * 2, 0.1, seconds - scaledMinute, 0, "root"],
	[root * 2, 0.1, seconds - scaledMinute, 0, "root"],
	[perfectFifth * 2, 0.1, seconds - scaledMinute, 0, "fifth"],
	[perfectFifth * 2, 0.1, seconds - scaledMinute, scaledMinute, "fifth"],

	// Third group of root/fifth drones
	[root * 4, 0.025, seconds - (scaledMinute * 2), 0, "root"],
	[root * 4, 0.025, seconds - (scaledMinute * 2), 0, "root"],
	[perfectFifth * 4, 0.025, seconds - (scaledMinute * 2), 0, "fifth"],
	[perfectFifth * 4, 0.025, seconds - (scaledMinute * 2), scaledMinute, "fifth"],

	// Fourth group of root/fifth drones
	[root * 8, 0.01, seconds - (scaledMinute * 3), 0, "root"],
	[root * 8, 0.01, seconds - (scaledMinute * 3), 0, "root"],
	[perfectFifth * 8, 0.01, seconds - (scaledMinute * 3), 0, "fifth"],
	[perfectFifth * 8, 0.01, seconds - (scaledMinute * 3), scaledMinute, "fifth"],

	// Introduce notes in chord, then rotate through octaves, switching between major and minor thirds and sevenths.

	// Round 1
	[perfectFourth * 2, 0.05, scaledMinute * 3, 0, "fourth"],
	[perfectFourth * 2, 0.05, scaledMinute * 3, scaledMinute, "fourth"],

	[septimalMinorThird * 4, 0.01, scaledMinute * 3, 0, "minor third"],
	[septimalMinorThird * 4, 0.01, scaledMinute * 3, scaledMinute, "minor third"],

	[minorSeventh * 8, 0.005, scaledMinute * 3, 0, "minor seventh"],
	[minorSeventh * 8, 0.005, scaledMinute * 3, scaledMinute, "minor seventh"],


    // Round 2
	[perfectFourth * 4, 0.01, scaledMinute * 3, 0, "fourth"],
	[perfectFourth * 4, 0.01, scaledMinute * 3, scaledMinute, "fourth"],

	[majorThird * 8, 0.005, scaledMinute * 3, 0, "Major third"],
	[majorThird * 8, 0.005, scaledMinute * 3, scaledMinute, "Major third"],

	[majorSeventh * 2, 0.05, scaledMinute * 3, 0, "Major seventh"],
	[majorSeventh * 2, 0.05, scaledMinute * 3, scaledMinute, "Major seventh"],


	// Round 3
	[perfectFourth * 8, 0.005, scaledMinute * 3, 0, "fourth"],
	[perfectFourth * 8, 0.005, scaledMinute * 3, scaledMinute, "fourth"],

	[septimalMinorThird * 2, 0.05, scaledMinute * 3, 0, "minor third"],
	[septimalMinorThird * 2, 0.05, scaledMinute * 3, scaledMinute, "minor third"],

	[minorSeventh * 4, 0.01, scaledMinute * 3, 0, "minor seventh"],
	[minorSeventh * 4, 0.01, scaledMinute * 3, scaledMinute, "minor seventh"],


	// Round 4
	[perfectFourth * 2, 0.05, scaledMinute * 3, 0, "fourth"],
	[perfectFourth * 2, 0.05, scaledMinute * 3, scaledMinute, "fourth"],

	[majorThird * 4, 0.01, scaledMinute * 3, 0, "Major third"],
	[majorThird * 4, 0.01, scaledMinute * 3, scaledMinute, "Major third"],

	[majorSeventh * 8, 0.005, scaledMinute * 3, 0, "Major seventh"],
	[majorSeventh * 8, 0.005, scaledMinute * 3, scaledMinute, "Major seventh"],


	// Ending: very high root/fifth drones
	[root * 16, 0.005, scaledMinute * 4, 0, "root"],
	[root * 16, 0.005, scaledMinute * 4, 0, "root"],
	[perfectFifth * 16, 0.005, scaledMinute * 4, 0, "fifth"],
	[perfectFifth * 16, 0.005, scaledMinute * 4, 0, "fifth"],
];

r = Routine({
	Synth.new(\fader, [\in, 2, \out, 0, \seconds, seconds]);
	score.do({|note, c|
		var freq = note[0],
		amp = note[1],
		loopDur = note[2],
		waitTime = note[3],
		message = note[4],
		out = 2,
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