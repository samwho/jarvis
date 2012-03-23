# The Virmidi Module

If you're on linux, you'll need to snd-virmidi module to be enabled. The
following command will do that (you may need to run this as root):

    modprobe snd-virmidi index=1

The index variable will change if you have more than one sound card. Run the
following commands to see your sound cards:

    cat /proc/asound/cards

If there is 1 item in the list, use 1 as your index. If 2, use 2 etc.

This will give you some virtual midi devices that unimidi will be able to
connect to and send output to.

# Setting it up to do this automatically on boot

I personally use the Arch Linux distribution and setting up your machine to
perform this module loading on boot is easy. In your favourite text editor,
load up the file `/etc/rc.conf` and add snd-virmidi to your list of modules, so
your MODULES array might look something like this:

    MODULES=(snd-virmidi)

To make sure it gets the right argument, you will need to open up a new
configuration file in your modprobe.d directory like this:

    vim /etc/modprobe.d/virmidi.conf

And put the following line in it:

    options snd-virmidi index=1

Obviously change the number after index to reflect what you chose in the section
above.

# Connecting it up

After you've sorted all of that out (you might need to reboot your machine to
check it all works) you will need to connect a virtual midi device to an output
device.

First, make sure you have an appropriate output device running. I'm using
timidity++:

    timidity -iA

Then, list your virtual midi devices with `aconnect -il`:

    client 0: 'System' [type=kernel]
        0 'Timer           '
        1 'Announce        '
    client 14: 'Midi Through' [type=kernel]
        0 'Midi Through Port-0'
    client 24: 'Virtual Raw MIDI 2-0' [type=kernel]
        0 'VirMIDI 2-0     '
    client 25: 'Virtual Raw MIDI 2-1' [type=kernel]
        0 'VirMIDI 2-1     '
    client 26: 'Virtual Raw MIDI 2-2' [type=kernel]
        0 'VirMIDI 2-2     '
    client 27: 'Virtual Raw MIDI 2-3' [type=kernel]
        0 'VirMIDI 2-3     '

We'll take the first one there, 24:0. Then check what port timidity is running
on with `aconnect -ol`:

    client 14: 'Midi Through' [type=kernel]
        0 'Midi Through Port-0'
    client 24: 'Virtual Raw MIDI 2-0' [type=kernel]
        0 'VirMIDI 2-0     '
    client 25: 'Virtual Raw MIDI 2-1' [type=kernel]
        0 'VirMIDI 2-1     '
    client 26: 'Virtual Raw MIDI 2-2' [type=kernel]
        0 'VirMIDI 2-2     '
    client 27: 'Virtual Raw MIDI 2-3' [type=kernel]
        0 'VirMIDI 2-3     '
    client 128: 'TiMidity' [type=user]
        0 'TiMidity port 0 '
        1 'TiMidity port 1 '
        2 'TiMidity port 2 '
        3 'TiMidity port 3 '

Okay, that's 128:0. Then we connect the two up:

    aconnect 24:0 128:0

And whatever comes from the first virtual midi device (the one that unimidi will
connect to) will be sent straight to timidity and timidity will send it to your
speakers.
