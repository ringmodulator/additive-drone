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
	arg out = 0, freq = 440, amp = 0.1, pause = 1, sus = 3, pan = 1;
	var env = Env.new(levels: [0.001, 0.001, 1, 1, 0.001], times: [pause, 4, sus, 4], curve: \sine);
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

// Play instrument

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

// Oscillator frequencies
freqs = [root, septimalMinorThird, perfectFifth],

// Duration of each loop
loopDurs = [120, 120, 120],

// How long to wait until the next loop starts
waitTimes = [20, 20, 20];

r = Routine({
	freqs.do({|freq, c|
		var loopDur = loopDurs.wrapAt(c),
		dur = pause + sus + 8,
		repeats = (loopDur/dur).round;

		("Note" ++ c).postln;
		("Frequency: " ++ freq).postln;
		("Loop duration: " ++ loopDur).postln;
		("Note duration: " ++ dur).postln;
		("Repeats: " ++ repeats).postln;
		("").postln;

		Pbind(
			\instrument, \drone,
			\out, out,
			\freq, Pseq([freq], repeats),
			\pause, pause,
			\sus, sus,
			\dur, dur,
			\pan, pan
		).play;

		// wait to start next loop
		waitTimes.wrapAt(c).wait;
	});
});
)

r.play