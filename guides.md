# Guides & Constraints

### Development language

We decided to write the CLI in Ruby. Our assumption is
that most of our customers have Ruby preinstalled, or that they have the
knowledge to set it up. Ruby is language that offers excellent tools for
developing command line interfaces (e.g thor), and we have deep understanding of
the language and the ecosystem.

We want to support Ruby versions >= 2.0, and set up continuous integration for
every significant Ruby version (2.0, 2.1., 2.2, 2.3, 2.4).

The choice of the language dictates the preferable installation method of `gem
install semaphore-cli`.



### Simple setup

Developers like to set up and test tools fast. In this area, docker serves as
a good example as it can be installed with one command:

```
wget -qO- https://get.docker.com/ | sh
```

As our client will be written in Ruby, we will have to rely on the user to
install it before installing our CLI. However, this doesn't mean that we can't
make the installation step simple and intuitive.

Installation methods for SemaphoreCli:

- `gem install semaphore-cli`
- (optional) `wget -qO- https://cli.semaphoreci.com | sh`
- (optional) `sudo apt-get install semaphore-cli`

The shell script installation method should warn if Ruby is not installed, or if
the installed version is not supported. For clarity and proper versioning, we
should support installation of specific versions of the client. For example,
`wget -qO- https://cli.semaphoreci.com/v1.0.3 | sh` will install the `v1.0.3`
version on the user's system.



### Authentication

For start, we don’t want to store raw credentials, like a
username and password. Yes, the developer is responsible for their own machine’s
security, but there are better methods that ensure your CLI and user info will
stay secure.

Storing the access token in a resource file `~/.semaphoreci` is a better choice.
If the key falls into the wrong hands, it can be revoked without affecting the
user’s primary login.

HTTPS is a must.

Users would authenticate with the `semaphore login` command. This is an
interactive command that asks for the username, password and 2fa code and stores
the auth token in the `~/.semaphoreci` file.

Non-interactive usage of the `login` command will not be supported as it would
encourage unsafe practices for the CLI. In a non-interactive environments (e.g
CI builds) users should inject the `~/.semaphoreci` file in the environment.



### Excellent help screens

Getting started with a CLI is unlike using other software for the first time.
There is not always a welcome screen, no confirmation email with a link to
documentation. Only through the command itself can developers explore what’s
possible.

This experience begins with the help screen. Ideally, we should include multiple
ways to come across the help screen. For example, git provides `git --help` and
`git help` both of which shows the same screen. Even better, the help screen
should be accessible with short flags, such as `-h` or `-?`.

The CLI help screen is essentially a getting started documentation for the
command line. We should list out the possible commands in logical groups, with
each group in alphabetical order. Along with each command, give a quick and
thorough explanation. It’s a balancing act of saying enough without saying too
much.

As an addition to the main help screen, the users should be able to explore
further and get help for specific actions. For example, `semaphore help
team:create` should go in details about the `team:create` command, explaining
the required and optional parameters, the preconditions for successful
execution, and the expected results.



### Command line Tab Completion

Using the command line is all about controlling a computer at the speed of
thought. CLIs aren’t typically seen on the same level as other interfaces. Yet,
they share the commonality that a good interface helps users get things done.

Tab completion significantly improves the usability of a command line tool. Bash
and Zsh completion should be implemented and installed out of the box.


### Errors and warnings

A command line tool should not fail silently, neither should it fail with a `0`
exit status. We should provide meaningful exit statuses accompanied with
descriptive descriptions that provide context and possible corrections for the
failure.

Example of descriptive failure:

```
$ semaphore teams:list
[ERROR] Can't connect to the remote server semaphoreci.com.

$ echo $?
19
```

No Ruby error should be allowed to propagate to the user directly. In case of
unexpected failures, the command should describe that an unexpected error has
occurred, a link where the failure can be reported, and a tracelog of the
command with followed by the context in which it was invoked.

Example of descriptive unexpected failure:

```
$ semaphore teams:list
[ERROR] Unexpected error. Please report this issue to semaphoreci.com/support.

Context:
  Called with: sempahore teams:list
  Resource file `~/.semaphoreci` not-empty
  Timestamp: 1500000312321
  Version: v1.0.4

Trace:
  ZeroDivisionError: divided by 0
    from (irb):2:in `/'
    from (irb):2
    from /usr/local/rbenv/versions/2.3.4/bin/irb:11:in
    `<main>'

$ echo $?
1
```


### Configuration

__TODO__

### Output

__TODO__ json, yaml
