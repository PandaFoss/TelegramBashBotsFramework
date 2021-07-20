# Contributing

While the project is at an early stage of its development, this document may be reformulated or edited in order to adopt the most optimal criteria for the smooth running of the project.

## How to contribute

In general, it is usually sufficient to observe the structure of the code and continue in the same way. However, we can list some criteria that we take into account from day one:

* Lines must be a maximum of 80 characters long. Longer lines should be shortened, making sure that the line break slash is positioned at the 80th character.

* POSIX-compatible syntax should be maintained as far as possible. This can be checked using the [`shellcheck`](https://github.com/koalaman/shellcheck) tool.

* When a command has a long option, it takes precedence. For example, `curl` allows both `-F` and `--form`, so we will choose the latter.

* When defining "methods", the order in which they are listed in the [official documentation](https://core.telegram.org/bots/api#available-methods) should be maintained.
