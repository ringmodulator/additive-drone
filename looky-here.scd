Server.default.options.numInputBusChannels = 0; // For use with AirPlay

s.boot;

// Version for Looky Here performance. Consider adding a noise generator to the instrument that can be controlled with the score. Or could add a separate noise instrument with its own score. I think ending this in dark noise could be good.

(
// Drone instrument
// Plays a note at a given frequency
// Envelope has initial silent pause, 4 second attack, parameterized sustain time, 8 second fade.

SynthDef(
	\drone,
	{
	| out = 0, freq = 440, amp = 0.1, pause = 1, sus = 3, pan = 0.5 |
	var env = Env.new(levels: [0, 0, 1, 1, 0], times: [pause, 4, sus, 8], curve: \sine);
	// Nice, simple dditive synth stolen from Stanford SC "gentle introduction" and modified a bit
	var snd = Mix.fill(12, {
			arg counter; // counts iterations starting from zero
			var partial = counter + 1; // don't start partials from zero
			SinOsc.ar(partial * freq * rrand(0.999, 1.001), mul: 1/partial.squared) * (amp * env.kr(doneAction: 2));});
		snd = Pan2.ar(snd, SinOsc.kr(pan));
		Out.ar([out], snd);
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

minutes = 22,
seconds = minutes * 60,
scaledMinute = seconds/20,

//Score
// [freq, amplitude, duration, wait time to start next loop, message]

score = [
	[septimalMinorThird, -20, seconds - (scaledMinute * 4), 0, "minor third"],
	[septimalMinorThird, -20, seconds - (scaledMinute * 4), 0, "minor third"],
	[septimalMinorThird, -20, seconds - (scaledMinute * 4), 0, "minor third"],
	[septimalMinorThird, -20, scaledMinute * 4, 0, "minor third"],
	[septimalMinorThird, -20, scaledMinute * 4, 0, "minor third"],
	[septimalMinorThird, -20, scaledMinute * 4, scaledMinute, "minor third"],

	[minorSeventh * 2, -32, seconds - (scaledMinute * 10), 0, "minor seventh"],
	[minorSeventh * 2, -32, seconds - (scaledMinute * 10), 0, "minor seventh"],
	[minorSeventh * 2, -32, seconds - (scaledMinute * 10), 0, "minor seventh"],
	[minorSeventh * 2, -32, seconds - (scaledMinute * 10), scaledMinute, "minor seventh"],

	[septimalMinorThird * 2, -20, seconds - (scaledMinute * 5), 0, "minor third"],
	[septimalMinorThird * 2, -20, seconds - (scaledMinute * 5), 0, "minor third"],
	[septimalMinorThird * 2, -20, seconds - (scaledMinute * 5), 0, "minor third"],
	[septimalMinorThird * 2, -20, seconds - (scaledMinute * 5), scaledMinute, "minor third"],

	[subminorSixth, -32, seconds - (scaledMinute * 11), 0, "minor sixth"],
	[subminorSixth, -32, seconds - (scaledMinute * 11), 0, "minor sixth"],
	[subminorSixth, -32, seconds - (scaledMinute * 11), 0, "minor sixth"],
	[subminorSixth, -32, seconds - (scaledMinute * 11), scaledMinute, "minor sixth"],

	[septimalMinorThird * 4, -32, seconds - (scaledMinute * 6), 0, "minor third"],
	[septimalMinorThird * 4, -32, seconds - (scaledMinute * 6), 0, "minor third"],
	[septimalMinorThird * 4, -32, seconds - (scaledMinute * 6), 0, "minor third"],
	[septimalMinorThird * 4, -32, seconds - (scaledMinute * 6), scaledMinute, "minor third"],

	[minorSeventh * 8, -46, seconds - (scaledMinute * 12), 0, "minor seventh"],
	[minorSeventh * 8, -46, seconds - (scaledMinute * 12), 0, "minor seventh"],
	[minorSeventh * 8, -46, seconds - (scaledMinute * 12), 0, "minor seventh"],
	[minorSeventh * 8, -46, seconds - (scaledMinute * 12), scaledMinute, "minor seventh"],

	[septimalMinorThird * 8, -40, seconds - (scaledMinute * 7), 0, "minor third"],
	[septimalMinorThird * 8, -40, seconds - (scaledMinute * 7), 0, "minor third"],
	[septimalMinorThird * 8, -40, seconds - (scaledMinute * 7), 0, "minor third"],
	[septimalMinorThird * 8, -40, seconds - (scaledMinute * 7), scaledMinute, "minor third"],

	[subminorSixth * 4, -40, seconds - (scaledMinute * 13), 0, "minor sixth"],
	[subminorSixth * 4, -40, seconds - (scaledMinute * 13), 0, "minor sixth"],
	[subminorSixth * 4, -40, seconds - (scaledMinute * 13), 0, "minor sixth"],
	[subminorSixth * 4, -40, seconds - (scaledMinute * 13), scaledMinute, "minor sixth"],

	[root, -20, seconds - (scaledMinute * 8), 0, "root"],
	[root, -20, seconds - (scaledMinute * 8), 0, "root"],
	[perfectFifth, -20, seconds - (scaledMinute * 8), 0, "fifth"],
	[perfectFifth, -20, seconds - (scaledMinute * 8), scaledMinute, "fifth"],

	[(minorSeventh * (3/2)), -26, seconds - (scaledMinute * 13), 0, "fifth above minor seventh"],
	[(minorSeventh * (3/2)), -26, seconds - (scaledMinute * 13), 0, "fifth above minor seventh"],
	[(minorSeventh * (3/2)), -32, seconds - (scaledMinute * 13), 0, "fifth above minor seventh"],
	[(minorSeventh * (3/2)), -32, seconds - (scaledMinute * 13), scaledMinute, "fifth above minor seventh"],

	[root * 2, -20, seconds - (scaledMinute * 10), 0, "root"],
	[root * 2, -20, seconds - (scaledMinute * 10), 0, "root"],
	[perfectFifth * 2, -20, seconds - (scaledMinute * 10), 0, "fifth"],
	[perfectFifth * 2, -20, seconds - (scaledMinute * 10), scaledMinute, "fifth"],

	[subminorSixth * (3/2) * 4, -32, seconds - (scaledMinute * 14), 0, "fifth above minor sixth"],
	[subminorSixth * (3/2) * 4, -32, seconds - (scaledMinute * 14), 0, "fifth above minor sixth"],
	[subminorSixth * (3/2) * 4, -40, seconds - (scaledMinute * 14), 0, "fifth above minor sixth"],
	[subminorSixth * (3/2) * 4, -40, seconds - (scaledMinute * 14), scaledMinute, "fifth above minor sixth"],

	[root * 4, -32, seconds - (scaledMinute * 12), 0, "root"],
	[root * 4, -32, seconds - (scaledMinute * 12), 0, "root"],
	[perfectFifth * 4, -32, seconds - (scaledMinute * 12), 0, "fifth"],
	[perfectFifth * 4, -32, seconds - (scaledMinute * 12), scaledMinute, "fifth"],

	[(minorSeventh * (3/2)) * 2, -26, seconds - (scaledMinute * 15), 0, "fifth above minor seventh"],
	[(minorSeventh * (3/2)) * 2, -26, seconds - (scaledMinute * 15), 0, "fifth above minor seventh"],
	[(minorSeventh * (3/2)) * 2, -32, seconds - (scaledMinute * 15), 0, "fifth above minor seventh"],
	[(minorSeventh * (3/2)) * 2, -32, seconds - (scaledMinute * 15), scaledMinute, "fifth above minor seventh"],

    [root * 8, -40, seconds - (scaledMinute * 14), 0, "root"],
	[root * 8, -40, seconds - (scaledMinute * 14), 0, "root"],
	[perfectFifth * 8, -40, seconds - (scaledMinute * 14), 0, "fifth"],
	[perfectFifth * 8, -40, seconds - (scaledMinute * 14), scaledMinute, "fifth"],

	[(minorSixth * (3/2)) * 8, -46, seconds - (scaledMinute * 16), 0, "fifth above minor sixth"],
	[(minorSixth * (3/2)) * 8, -46, seconds - (scaledMinute * 16), 0, "fifth above minor sixth"],
	[(minorSixth * (3/2)) * 8, -72, seconds - (scaledMinute * 16), 0, "fifth above minor sixth"],
	[(minorSixth * (3/2)) * 8, -72, seconds - (scaledMinute * 16), 0, "fifth above minor sixth"],
];

r = Routine({
	Synth.new(\fader, [\in, 2, \out, 0, \seconds, seconds]);
	score.do({|note, c|
		var freq = note[0],
		db = note[1],
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

r.play
