# Jarvis Java Client Library Tests

## Assumptions

The tests assume a couple of things of your system. Notably, your system must be
able to spawn new processes from inside the JVM and you must have the "jarvis"
executable in your PATH somewhere.

If these assumptions are not met, the tests will not work properly. The tests
depend on spawning a new Jarvis server process and sending messages to it and
asserting conditions on the responses.

## Running the tests

The Java client library is managed using Apache's Ant tool. To run tests, simply
run the following command in the `client_libs/java/` directory:

    ant test
