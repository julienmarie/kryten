# Kryten

[![Kryten - from Wikipedia](kryten.jpg)](http://en.wikipedia.org/wiki/Kryten)

kryten - Be a good internet citizen and only crawl pages that site authors
indicate that are crawlable. A robots.txt parser for Elixir.

## Usage

### Installation

To install Kryten into your project, add the dependency into your `mix.exs`
file:

    defp deps do
      [
        {:kryten, "~> 0.1.0"}
      ]
    end

and run `$ mix do deps.get, compile`

### Starting Kryten

Kryten is an [OTP Application](http://en.wikipedia.org/wiki/Open_Telecom_Platform), and as such
needs to be started before it can be used. You can either add `:kryten` to the
list of applications to start on startup in your `mix.exs` file:

    def application do
      [applications: [:logger, :kryten],
      ...
    end

or start it explicitly from within your own code:

    Application.start :kryten

### Using Kryten in your application

Firstly, you can ask Kryten to read the `robots.txt` file from a website. You
can pass any URL to Kryten and it will work out where the `robots.txt` file for
that site should be.

    Kryten.add_host "http://example.com"

Once Kryten has added the host/s that you're interested in, you can ask Kryten
whether or not your bot is allowed to crawl any specific URL.

    Kryten.allow? "MyBotName", "http://example.com/secret/page.html"

This function will return true or false indicating whether a bot with the given
user-agent string is allowed to crawl that particular page. It will also take
into account the rules for all bots.

## Contributing

1. [Check for issues](https://github.com/BennyHallett/kryten/issues) in our
Github issue tracker, or open a new issue and start a discussion around a
change. There's a _contributor-friendly_ tag that marks issues that would be
good for new contributors to tackle.
2. For the [Kryten library](https://github.com/BennyHallett/kryten) and make
your changes.
3. Write tests that show that the feature works as intended, or the bug was
fixed.
4. Write _@doc_ and _@moduledoc_ documentation for any new modules or functions
that you add, explaining the purpose of the module or function. Code examples
in this documentation is encouraged.
5. Send a pull request to have your changes merged into _master_. Don't forget
to add yourself to the [CONTRIBUTORS file](https://github.com/BennyHallett/kryten/blob/master/CONTRIBUTORS)

## License

Kryten is licensed under the [MIT License](https://github.com/BennyHallett/kryten/blob/master/LICENSE)
