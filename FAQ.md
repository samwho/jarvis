# Why Ruby 1.8.7?

Unfortunately it seems like the MIDIator Ruby library only runs under Ruby
1.8.7. I haven't been able to find a way around this. If MIDIator updates to
support the latest version of Ruby and I'm a bit slow on the uptake, please let
me know.

There _is_ support for the Ruby 1.9 series and it uses a library called UniMIDI
by Ari Russo. Unfortunately, I personally experience a strange affect when
attempting to play chords that sounds rather unpleasant. Ari has not been able
to reproduce the issue himself, so you are welcome to try out 1.9 if you wish.

If you do try 1.9, you will want to take a look at the REAME_virmidi file. It
explains what you will need to do to connect to virtual raw midi devices, which
is a requirement of UniMIDI.

# How do I run the code for development, from the GitHub repo?

Currently this code is only tested on my own machine. Theoretically, if you have
a MIDI software synthesizer, Ruby 1.8 installed and the required gems
(eventmachine and midiator) it should work, but I'm guessing that in practice it
is probably going to be a tad harder to achieve cross compatibility.

Disclaimer: I use RVM for my development process. The following instructions
apply to using RVM. If you don't use RVM then please change accordingly.

First thing you need to do is have Ruby 1.8.7 installed. You can acquire the
code online or, if you use RVM, you can use this command:

    $ rvm install 1.8.7

When you've done that, switch to Ruby 1.8.7 like so:

    $ rvm use 1.8.7

Then, switch to the global gemset and install bundler:

    $ rvm gemset use global
    $ gem install bundler

Then create a gemset for Jarvis:

    $ rvm gemset create jarvis
    $ rvm gemset use jarvis

Then run bundler when inside the same directory as this README file:

    $ cd path/to/jarvis/
    $ bundle install

That will install all of the required gems.

Then you will need to run some kind of MIDI synthesiser. I very much recommend
using "Timidity". To install, do one of the following:

## Ubuntu

    apt-get install timidity++

## Fedora

    yum install timidity++

## Arch

    pacman -S timidity++

Then run it as a server like so:

    $ timidity -iA

Timidity will just sit there waiting for input then. You will need to open a new
terminal to run the next command and leave Timidity as it is.

Then you should be able to run the `./bin/jarvis` server fine. Nothing will play
at first, you need to connect to the server with a client by running
`./bin/jarvis-client`. A default note generator will be loaded in (it isn't
defined which will be the default at this moment in time). If you type "start"
at the jarvis-client command line, music should start playing.

# I don't hear anything.

There are a wide variety of reasons that you might not hear anything. The one I
come across most often is that I've forgotten to run the MIDI server. Make sure
you followed the step above to load up the MIDI server.

It is also possible that your MIDI ports did not link up correctly. Jarvis
currently only supports two MIDI software synths out of the box and these are
Timidity and QSynth. Adding support for more MIDI synths is easy enough but
requires you, the user, to supply me with some data.

To figure out what your MIDI synth is called, run this command:

    aconnect -ol

This lists your MIDI outputs. You should see whatever synth you use listed there
and you can send me that output and ask me to add support for your synth server.

## I can't hear anything and I'm using Timidity on Ubuntu

It has been recently reported to me that timidity doesn't output sound on later
versions of Ubuntu for some people. However, qsynth worked pretty much out of
the box. It's a bigger download but it works.

# It's complaining that it can't find libasound.so

This is because you don't have the ALSA development libraries.

## Fedora Fix

    yum install alsa-lib-devel

## Ubuntu Fix

    apt-get install libasound2-dev

This is confirmed to work on 11.04. Other Ubuntu versions may vary.

## Arch Linux Fix

    pacman -S alsa-lib

# It's complaining that it can't find the program 'cowsay'

Yeah. Whoops. Cowsay is just a simple program that displays a cow (or another
animal) saying something in a speech bubble. Just a bit of fun. Two ways to fix
this: install cowsay (adjust this line to fit whatever package manager you use):

    $ apt-get install cowsay

Or run Jarvis with the `--no-welcome` flag:

    $ jarvis --no-welcome

# Using the default jarvis-client

The default `./bin/jarvis-client` is just an EventMachine keyboard listener. It listens
for keyboard input and then sends messages to the server every time you hit
enter.

To start the server (needs to be done first), run:

    $ jarvis

To start the client, run this in another terminal:

    $ jarvis-client

Then you will be dropped into a jarvis-client prompt. To start music, use:

    jarvis-client> start

To stop music, use:

    jarvis-client> stop

To load a new note generator use:

    jarvis-client> load GeneratorName

Replace `GeneratorName` with one of the available generators. To see a list of
the available generators use:

    jarvis-client> generators

If you really want to, you can kill the server from the client with this
command:

    jarvis-client> kill_server
