# Jarvis Java Client Library

Welcome to the Jarvis Java client library! This library is intended to make
programmatic access to Jarvis from Java very easy and smooth.

There are examples of use in the `src/examples/` directory. They are heavily
documented and aim to show you how the library works in a pragmatic fashion.

# Usage

To use the Jarvis library in your code, include the `build/jar/Jarvis.jar` file
in your own lib directory and link to it in your classpath.

# Making sure it works

If you want to make sure that the library you have downloaded does work, you can
run the `build/jar/Jarvis.jar` file like so:

    java -jar build/jar/Jarvis.jar

And it will test itself by cycling through the default generators and play 5
seconds worth of notes from each of them in turn. This will require you to have
a jarvis server running locally on the default port of your machine, otherwise
you will get a "Connection refused" style error.

# Modifying

If you feel like modifying the code and building a new jar file out of it,
simply run the following command in the same directory of this README:

    ant jar

# Automated Testing

For more information on how the Java client library is tested, see the README in
the `test/` directory.
