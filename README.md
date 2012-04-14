# Jarvis

The Jarvis project is part of my final year project at university to create a
way of generating music with code.

The approach Jarvis takes is very high level. Inside note generators (explained
in a moment) you can use expressive constants such as `MiddleC` and `E2` to
reference notes.

Jarvis makes use of MIDI to play notes. Because of this, Jarvis requires a MIDI
synthesizer be installed and running to work. Two MIDI software synths are
supported out of the box, [Timidity++](http://timidity.sourceforge.net/) and
[qsynth](http://qsynth.sourceforge.net/qsynth-index.html). Both are open source
and likely to be in your Linux distribution's repositories.

# Install

First, make sure you have one of the two software synths listed above installed.
Both should be residing in your package manager, whatever system you are using.
People have reported success with Mac but I have not personally tested it. If
you run into problems or would like to explain the setup process on Mac, please
feel free to open an issue or a pull request modifying this README.

Jarvis itself is packaged up nicely as a RubyGem. Installation is quick and
easy:

    gem install jarvis

**It is recommended that you use the Ruby 1.8 series to run Jarvis.** The reason
why is explained in the FAQ file in this directory.

# Running

Jarvis ships with a number of note generators already installed as part of the
core library. The academic reason is because that was what my research was on;
different ways of generating notes.

Academic talk aside, to run Jarvis you need to first make sure either Timidity
or qsynth is running. One of these should suffice:

    # Timidity
    $ timidity -iA

    # qsynth
    $ qsynth

Then run Jarvis itself:

    $ jarvis

By default it starts listening on port 1337. You can change this with a command
line argument:

    $ jarvis --port 9090

Then you run the keyboard client to connect to the server. If you listened on a
different port with the server, the syntax is exactly the same to connect to a
different port with the client:

    $ jarvis-client --port 9090

And from here, you should get a prompt that looks like this (and if you have a
good terminal environment, should appear a light blue):

    jarvis-client>

By default, a MarkhovChain generator is loaded up. This was part of my research
and by default it doesn't sound too bad as an attempt to generate music. Try it
out with:

    jarvis-client> start

If it starts to grate on you, which it might, you can stop it like so:

    jarvis-client> stop

If you want to see a list of the generators that you can play with, try this
command:

    jarvis-client> generators

This should give you a list of the default, core generators. But what about
writing your own generators? This is where the fun begins.

# Custom generators

Writing custom generators is designed to be an easy process. One of the end
goals of the system is that it should be easy to extend. When Jarvis boots, it
scans the directory `~/.jarvis/generators/` for .rb files and loads them.
Technically, they don't need to be generators but a little directory
organisation never goes amiss.

Here's the hello world of note generators:

    class Jarvis::Generators::HelloWorld < Jarvis::Generators::NoteGenerator
        def next
            Jarvis::Note.new MiddleC
        end
    end

If you save that under `~/.jarvis/generators/helloworld.rb` and fire up Jarvis:

    $ jarvis

Then fire up a Jarvis client:

    $ jarvis-client

Load up this new generator:

    jarvis-client> load HelloWorld

And play:

    jarvis-client> start

You should hear a middle C note played over and over again. Huzzah! We're
programming music.

## What's happening under the hood

We're going to take a brief detour here and explain what's happening inside
Jarvis when you load and start your HelloWorld generator.

When you boot the server, Jarvis uses a library called EventMachine to handle
client connections. When a client connects via a socket or whatever it decides
to connect via (the client libraries use sockets), EventMachine creates a new
instance of an object called MusicServer, which is the object that handles
sending message to the midi synth.

Each MusicServer has two very important attributes: @generator and @thread. When
you load a new generator, an instance of your generator class is stored inside
@generator. Then, when you run the `start` command, a new thread is created that
gets a copy of your @generator and start repeatedly polling its `next` method.

Here's what the thread looks like:

    @thread = Thread.new(@generator, Jarvis::MIDI.instance) do |generator, output|
        loop do
            output.play_note generator.next
        end
    end

Error handling code has been omitted for brevity. The `Jarvis::MIDI.instance`
call returns a singleton of the MIDI interface to the system, so only one MIDI
interface can exist at any given time. This MIDI interface knows how to play
`Jarvis::Note` objects, which have a number of useful attributes that we can
set.

## Anatomy of a Jarvis::Note

A `Jarvis::Note` has the following attributes:

    note = Jarvis::Note.new
    note.notes
    #=> By default, an empty array. Add notes to this array to form chords.

    note.duration
    #=> By default, Jarvis::Note::QUARTER. Can be any floating point value.

    note.velocity
    #=> By default 100. Volume, basically.

    note.channel
    #=> By default 0. Advanced use, you won't need to worry about it.

So we can control the key aspects of a note very easily through this object and
the MIDI interface knows exactly how to deal with it.

Note that while a note is playing, the thread sleeps. MIDI notes are "played" by
a pair of note on and note off signals. The MIDI interface will fire a note on
event, then sleep for the note.duration and then fire a note off event.

## What is a note under the hood?

It's an integer, plain and simple. In the MIDIator library by Ben Bleything,
there was a class that had constants mapping a note's name to its integer
representation in MIDI. This class has been copied over to Jarvis and can be
found in `lib/jarvis/notes.rb` if you're curious :)

# Hooking into the server from a note generator

Note generators wouldn't be nearly as interesting if you couldn't interact with
them. Because of this, Jarvis has a really nice way of hooking your own commands
into the server. Let's see an example:

    module Jarvis::Generators
        class ServerHookExample < NoteGenerator
            attr_accessor :note

            def initialize
                @note = MiddleC
            end

            def next
                Jarvis::Note.new @note
            end

            server_command "change_note" do |server, args, generator|
                note = Jarvis::Notes.const_get args[1]
                generator.note = note
                server.send_data "Note successfully changed to #{note}."
            end
        end
    end

Right, there's a lot of new stuff going on here so let's take it step by step.

The first thing you might notice that is different is the call to "module" up at
the top. This just makes things a little more readable in my opinion. No more
fully qualified class names, we can work directly inside `Jarvis::Generators`.

Next, we have a constructor. There's no magic going on here. As was explained
earlier, note generators get instantiated when they're loaded via the `load`
command, so you can still do any setup you need as normal inside the
constructor. In this example, the constructor simply creates a default @note
attribute. Also note that @note has an `attr_accessor` line at the top. This is
important for later.

The `next` method is more or less the same as it was inside the HelloWorld
example, only this time we pass in the instance value @note instead of a
constant. This is so we can change the note during playback.

### The server_command

This is the juicy bit: the call to `server_command`. This is a helper method
that ties a command to the server for us. It takes a command name and then a
block that represents what the command does.

The block we pass in can take up to three arguments. The first argument will be
the MusicServer object that handled the call to this command. The second
argument will be the arguments that were passed to the command. The arguments
work just like ARGV does. The first argument, `args[0]`, will be the name of the
command itself. The rest of the array is the result of a call to Shellwords on
the full command string received by the server. Look up Shellwords if you are
uncertain. Lastly, the generator (which you can think of as a "this" keyword)
gets passed in.

Because the block gets stored elsewhere and called later on, you cannot just
call instance methods as you would in a normal instance method. They need to be
called via the `generator` block argument.

### What does this command do?

Well, the first thing it does is take the first argument, which will be a string
(like all of the other arguments), and try and grab a note constant with it. The
`const_get` method looks for a constant by that name and return it if it exists.

Next, we simply set the @note attribute to the newly found note (error checking
code has, again, been omitted for brevity. In a real world generator you would
want to make sure the constant exists). So the next time the server thread polls
the `next` method for a note, it will get the newly loaded one.

Lastly, the command sends a string response back to the client.

### How do I call this command?

Generator commands get namespaced. The proper syntax for calling this new
command is as follows:

    jarvis-client> ServerHookExample.change_note E1

Arguments are delimited with a space, like at the terminal. Not a comma, like in
Ruby. If you want to include a space in your single argument, that works like
the terminal too: wrap it in double quotes.

## Go forth!

This ends the whirlwind tour of using and extending Jarvis. Now you can go forth
and generate cool music without needing to worry about interfacing with MIDI,
manage threads and all that malarky :)
