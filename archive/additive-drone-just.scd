s.boot;

// Define synths and buses
(
// Audio bus for master fader
~faderBus = Bus.audio(s, 2);

// Load boiler sound into buffer
~boiler = Buffer.read(s, "/Users/aaron/Dropbox/Music Recordings/SuperCollider/neighbors/boiler.wav");

// Boiler playback
SynthDef.new(\boiler, {
	arg amp = 1, out = 0, buf, rate = 1, da = 2;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, doneAction:da) * amp;
	Out.ar(out, sig);
}).add;

// Guitar playthrough with EQ to help horrible peizo pickup plus reverb
SynthDef(
	"audioIn",
	{
	var in = SoundIn.ar(0);
	var lowPass = LPF.ar(in: in, freq: 1500, mul: 3);
	var reverb = FreeVerb.ar(in: lowPass, mix: 0.4, room: 0.9, damp: 0.5);
	Out.ar ([0, 1], reverb).softclip;
	}
).add;

// Drone instrument
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

// Master envelope
SynthDef(
	\fader,
	{
		arg in = 0, gate = 1;
		var env, input;
		env = Env.asr(60, 1.0, 60, curve: 4.0).kr(gate: gate);
		input = In.ar(in, 2);
		Out.ar([0, 1], input * env)
	}
).add;

(
// Function to play a drone with root, fifth, octave, and twelfth; cheated with Copilot to figure this out.
~playDroneChord = {
	arg out = 0, root = 82;
    var fifth = (3/2) * root;
    var octave = root * 2;
    var twelfth = fifth * 2;

    [
		[root, rrand(1.0, 5.0), rrand(4.0, 8.0), rrand(0.1, 0.5)],
        [fifth, rrand(1.0, 5.0), rrand(4.0, 8.0), rrand(0.1, 0.5)],
        [octave, rrand(1.0, 5.0), rrand(4.0, 8.0), rrand(0.1, 0.5)],
        [twelfth, rrand(1.0, 5.0), rrand(4.0, 8.0), rrand(0.1, 0.5)]
    ].do { |params|
        var freq = params[0], pause = params[1], sus = params[2], pan = params[3];
        Pbind(
            \instrument, \drone,
			\out, out,
            \freq, freq,
            \pause, pause,
            \sus, sus,
            \dur, pause + sus + 8,
			\pan, pan
        ).play;
    };
};
)
)

(
// Start drones
var root = 82.41, fourth = e * (4/3);

~playDroneChord.(~faderBus, root);
~playDroneChord.(~faderBus, fourth);

x = Synth.new(\fader, [
	\in, ~faderBus,
	\gate, 1
]);
)

// End drone
x.release;

// Guitar playthrough
(
Synth("audioIn");
)

// Play boiler sound
(
Synth.new(\boiler, [\buf, ~boiler.bufnum, \rate, 0.25, \amp, 0.75]);
)
