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

    $ timidity -iA -B2,8 -Os1l -s 44100

Then my code is more or less good to go. This may not necessarily be the case
for everyone, though, even with my setup. MIDI software synthesisers act as
servers and they use an interesting port notation. This code acts as a client to
that MIDI server and it needs to be told explicitly that it needs to connect to
it, which is done with the following call:

    $ aconnect 128:0 129:0

Which I have hard coded in (messy, I know). To find out your MIDI servers, you
can run:

    $ aconnect -ol

Which lists MIDI outputs. To list inputs:

    $ aconnect -il

You need to take the two port numbers and connect them up. I don't fully
understand the process just yet, I just know that it is necessary and the
numbers don't seem to change for me every time, so hard coding it in was a
simple solution that I aim to fix before the final version that I hand in at the
end of the project.
