# The First Prototype

The first prototype of my final year project, affectionately named Jarvis,
demonstrates the client server model and a modular approach to generating notes.

# Client Server Model

The idea behind this project is to have a music server running perpetually and
have a client connect to the server and tell it what to do. The server will be
able to generate music on the fly and the client will be able to control it in
whatever way is supported by the current method of note generation.

# Note Generation

The note generation method is very modular. Thanks to Ruby's ability to have
objects duck typed, all the note generator classes need to do currently is
supply a `next` method that returns a Note object. Through this rather elegant
interface, it is possible to generate music that is indefinitely long. Depending
on how you implement the `next` method, different music will be generated.

What this project wants to explore is the different methods of implementing that
`next` method.

# How to Run

Currently this code is only tested on my own machine. Theoretically, if you have
a MIDI software synthesizer, Ruby 1.8 installed and the required gems
(eventmachine and midiator) it should work, but I'm guessing that in practice it
is probably going to be a tad harder to achieve cross compatibility.

Here's how I run the code:

First I start up the `timidity` MIDI software synthesiser like so

    $ timidity -iA

Timidity++ should come as standard on Ubuntu. On Arch, I had to install it with
`pacman -S timidity++`.

Then you should be able to run the `./bin/jarvis` server fine. Nothing will play
at first, you need to connect to the server with a client by running
`./bin/jarvis-client`. A default note generator will be loaded in (it isn't
defined which will be the default at this moment in time). If you type "start"
at the jarvis-client command line, music should start playing.

# I don't hear anything.

There are a wide variety of reasons that you might not hear anything. The one I
come across most often is that I've forgotten to run the MIDI server. Make sure
you followed the step above to load up the MIDI server.

It is also possible that your MIDI ports did not link up correctly. In the
`./lib/jarvis/server.rb` file there is a line that looks like this:

   fork { `aconnect 129:0 128:0` }

This line is creating a new process to connect a MIDI input to a MIDI output,
because MIDI inputs need to be told where to send their output to. It's entirely
possible that these numbers will need to be changed on your machine. To list
your MIDI outputs, run this command:

    $ aconnect -ol

If you have Timidity running, it should be showing that it's running on 128:0 to
128:3. I believe those are its defaults. You'll need to be running jarvis to see
what input port it is using, do that with this command:

    $ aconnect -il

Once you know both MIDI ports, you can alter the line of code in the fork block
accordingly. Input comes first, then output.

# Using the default jarvis-client

The default jarvis-client is just an EventMachine keyboard listener. It listens
for keyboard input and then sends messages to the server every time you hit
enter.

To start music, use:

    start

To stop music, use:

    stop

To load a new note generator use:

    load GeneratorName

Replacing generator name for a class in the `./lib/jarvis/generators/`
directory.
