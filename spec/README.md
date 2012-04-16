# Jarvis Testing

This is where all of the Jarvis tests and testing framework lives. There are a
number of files that will help support writing new tests, including RSpec shared
contexts and rake tasks.

## Running Tests

Tests are run using the standard rake command:

    $ rake

This will fire off an RSpec testing suite with the command line options -cfs
(coloured output and specdoc format).

## Shared Contexts

Jarvis has two (technically three but two are usually used in conjunction with
each other) shared contexts that help with testing.

### "server" and "timidity"

This context is aimed at making writing tests that communicate with an external
Jarvis process really, really easy.

If you include these lines (in this order) in your RSpec describe block:

    include_context 'timidity'
    include_context 'server'

You will get given a variety of helper methods and some before and after hooks
will automatically run for you. First, a timidity server will be run in the
background. It won't make any sound, instead it will output everything to an Ogg
Vorbis file. This ogg file can be accessed using the `test_ogg` helper method.

The `ogginfo` gem is used to extract information about the ogg file.
Documentation for `ogginfo` can be found
[here](https://github.com/moumar/ruby-ogginfo). If `test_ogg` returns nil it
means that either the ogg file does not exist or timidity never wrote to it,
which indicates that communication between Jarvis and timidity is not working.

When timidity is up and running, a Jarvis process will be spawned. There are
calls to `sleep` involved in booting Jarvis and timidity to give them time to
load up.

When both of these are running, the content of your test is run. There are two
very useful helper methods that will aid in your test writing: `send_command`
and `last_response`. Both of them are quite self explanatory. `send_command`
will take a string and send it to the server and return the server response.
`last_response` is a way of accessing that response numerous times.

Here's an example:

``` ruby
  describe "Server" do
    it "should respond to start" do
      send_command "start"
      last_response.should include('successfully')
    end
  end
```

When your test has finished executing the Jarvis and timidity processes will be
killed.

**Note:** This context is quite noisy. All of the server boot up logs are put
into stdout for debugging purposes (in case something goes wrong, you will want
to look at the server logs). Test output is often very busy with this context.

### test_server

The "test_server" context will give you exactly the same `send_command` and
`last_response` helper methods as the "server" context described above, but it
will not spawn external processes.

This context will monkey patch the MusicServer class so that it does not try and
send any data to clients. Instead, it stores that data and makes it accessible
through the `last_response` helper.

Tests written with this context will look almost exactly the same as tests
written with the "server" context. The only difference is that there is no
timidity server running and, therefore, no ogg file to test against. This
context is just for doing granular tests against the server object that doesn't
require any interprocess communication.
