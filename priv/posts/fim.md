---
title: Elixir's Function-Injection Macro Pattern
date: 2019-03-01
intro: Exploring a the hygeine and power of an growing Elixir macro pattern
---

An increasingly common pattern to see in Elixir libraries is the offer of a
`__using__/1` macro that makes your module _into_ something.

For some abstractions, we want to inject useful functions so that a
module _is a_ generic `<fill in this blank>`. These generic modules provide
functions that would be awkward to call because of verbose options or long
parameter lists.

## Libraries

Libraries are good for commonly used code. They replace ugly or long code with
less code (just a function call). Why not use a vanilla library? Often we have
a repetitive parameter that we wish could be compiled in. In this example, we
have a `file_repo` abstraction that stores files locally, on S3, by FTP, git,
etc.:

```elixir
{:ok, remote_filename} =
  FileRepo.store(
    "file.txt",
    :s3,
    bucket: Application.fetch_env!(:my_app, :bucket),
    region: Application.fetch_env!(:my_app, :region)
  )
```

If we know ahead of time that we only want our app to commit files to S3 at a
certain bucket in a certain region, then any time we want to call this `store/3`
function, we have to specify all these repetitive parameters. Instead, we'd
rather do this:

```elixir
{:ok, remote_filename} = MyApp.FileRepo.store("file.txt")
```

and define our `FileRepo` instance like so:

```elixir
# lib/my_app/file_repo.ex
defmodule MyApp.FileRepo do
  use FileRepo,
    strategy: :s3,
    bucket: Application.fetch_env!(:my_app, :bucket),
    region: Application.fetch_env!(:my_app, :region)
end
```

## Example: Extreme

A perfect example is the new style introduced in `v1.0.0` of
[Extreme](https://github.com/exponentially/extreme/tree/v1.0.0), the Event Store
client library for Elixir. Taking a look into
[`lib/extreme.ex`](https://github.com/exponentially/extreme/blob/v1.0.0/lib/extreme.ex),
we see a huge `__using__/1` macro. That macro injects a whole bunch of useful
functions like `ping/0` and `subscribe_to/4`. These allow us to reason about our
connections to Event Store as modules ("I want to write an event using my
`MyApp.EventStoreClient` module").

You might have one module for each Event Store you want to interact with:

```elixir
defmodule MyApp.UserActivityEventStore do
  use Extreme
end

defmodule MyApp.OtherBackEndActivityEventStore do
  use Extreme
end

# the hosts, ports, etc. are given in `lib/my_app/application.ex`

MyApp.UserActivityEventStore.execute(write_user_events)
```

Here the different modules represent access points to separate instances of
Event Store.

## Example: Arc

An even better example is an [Arc
definition](https://github.com/stavro/arc/blob/e2871e02c8aab0aaba885c8d141ed3a51a1ec8a8/README.md#local-configuration).
Arc allows you to work with files abstractly. You define modules which `use
Arc.Definition` and optionally configure that _instance_ by defining functions.
In short, you write a module like this:

```elixir
defmodule MyApp.FileRepo do
  use Arc.Definition
end
```

And now you can treat the file repository like <s>an object</s> a module. In a
few ways, this is pretty reminiscent of Object Oriented programming. This module
_is a_ something. Similar to having many objects, you can have many generic
modules:

```elixir
defmodule MyApp.ArchiveRepo do
  use Arc.Definition
  def __storage, do: Arc.Storage.Local
end
```

With this, we can handle separate, consistent configurations with ease by
labeling the configurations as modules. Without this pattern, we might be forced
to write throughout the project:

```elixir
defmodule MyApp.FileUploadedListener do
  def heard_file(file) do
    # for archives
    File.cp!(file, some_dir)
    # for something else
    file
    |> ExAws.S3.Upload.stream_file()
    |> ExAws.S3.upload(Application.fetch_env!(:my_app, :bucket), Path.basename(file))
    |> ExAws.request(region: Application.fetch_env!(:my_app, :region))
  end
end
```

when we might write with the abstract modules:

```elixir
defmodule MyApp.FileUploadedListener do
  def heard_file(file) do
    MyApp.ArchiveRepo.store(file)
    MyApp.FileRepo.store(file)
  end
end
```

The "library" version requires much more code. And the code is boring too. If we
wanted to execute similar functions all over our app, we would be repeating the
same configuration over and over. Since the configuration does not change over
time, repeating it is useless.

In general, this pattern makes it easy to represent separate configurations
which do not change over time.

## Hiding Configuration: Function-Injection Macros

Because we're writing a macro, we can _hide_ that repetitive
information when we define the function.

When we do this, we make long macro blocks:

```elixir
# in library
defmodule MyAbstraction do
  defmacro my_macro(opts) do
    quote do
      def one_func(arg) do
        # do something with `opts`
        GenServer.call(unquote(opts.server), {:one_func, arg})
        ..
      end

      def another_func(arg) do
        # do something else with `opts`
        ..
      end

      .. # etc.
    end
  end
end

# in project
defmodule MyApp.AbstractionImplementation do
  use MyAbstraction, server: MyApp.SomethingServer
end
```

But when we write the macro like this, we run into a few problems:

- `credo` complains about long quoted blocks
- `coveralls` can't touch quoted blocks
  - it's hard to tell if you're really testing _all_ that code in there
- it's (beam-code-wise) not DRY across projects (but is usually DRY within the
  project)
  - suddenly we have 25 modules (across projects) with the _almost_ same beam
    code doing _almost_ the same thing

## Macros

Refresher on why macros are good:

1. to withhold execution
1. to replace ugly code with simple code (just a macro invocation)
1. more abstractly, to do transformations on the code
  - e.g. the pipe operator `|>`

Macros can hide things and that's good for configuration but bad for
readability and hygiene (code cleanliness like `coveralls` and `credo`).

## The Point
{: #the-point}

When we create a macro that defines a generic module, we can minimize the size
of the macro and maximize the hygiene, all while keeping our ability to inject
compact, generic functions by proxying a library.

```elixir
# in library
defmodule MyAbstraction do
  defmacro my_macro(opts) do
    quote do
      def one_func(arg),
        do: MyAbstraction.one_func(unquote(opts.server), arg)

      def another_func(arg),
        do: MyAbstraction.another_func(unquote(opts.something, arg))

      .. # etc.
    end
  end
  
  def one_func(server, arg) do
    GenServer.call(server, {:one_func, arg})
    # other things
    ..
  end
  
  def another_func(opt, arg) do
    # things with `opt` and `arg`
    ..
  end
  
  # etc..
end

# in project
defmodule MyApp.AbstractionImplementation do
  use MyAbstraction, server: MyApp.SomethingServer
end
```

With this, `coveralls` and `credo` have access to the _important_ code. The
injected functions are one-liners. The library code is _accessible_, albeit in a
raw format. And now because the quote block is so small, the definition is
readable. So when you write a function-injection macro, please do this.
