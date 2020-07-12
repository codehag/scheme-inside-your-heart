# incc

This project is my implementation of Abdulaziz Ghuloum's paper ["An Incremental Approach to Compiler
Construction"](./papers/an_incremental_approach_to_compiler_construction.pdf). It takes some of it's instruction from the [expanded tutorial](./papers/backend_to_frontend_to_backend_again.pdf), and some hints from the Nada Amin's [implementation](https://github.com/namin/inc/).

See the [Full Original Instructions](./full_original_instructions.md) for details about running
tests.

This is a scheme compiler for x86 intel architecture. This was written for my enjoyment, but it
might be useful for others. I wrote this in 2020, on a macOS, and it has certain quirks. I have
tracked those in [quirks.md](./quirks.md).

The "start" branch of this repository only contains the tests and a modified driver (the original
didn't work), and basic infrastructure. I tracked my progress in branches associated with the
passing test cases as I followed the paper. If you are doing your won implementation, you can check your progress against other
branches in this repository to see how you are doing, or to help you get unstuck.

##  Requirements

"An Incremental Approach to Compiler Construction" requires a couple of tools, that aren't
immediately obvious. You can't just follow the paper and run the project. You need to know a bit of
scheme. The tutorial provided a test driver that outputs the necessary file, and a number of tests.
On top of that, you need the following:

### gcc
Check if you have `gcc` installed  by running `gcc -v`. If you are on a mac, you may think you have `gcc` installed already. This may not be the case, as
mac ships with a version of `clang` (anothere compiler) which pretends to be gcc. In order to ensure
that you have gcc, run `brew install gcc`.

For other operating systems, you may want to check if it is available, and follow the guidelines in
order to install it if it is missing.

### Chez petit scheme

The implementation language of this project is `scheme` but more specifically chezscheme. You can
install it with `brew install chezscheme`. At the time of writing, it is version 9, the paper was
written for version 7. It works fine though.

## Inspection tools

You may be interested in seeing what your computer is doing as you run things. To see the binary
output of an object file (files with `.o` extension) or your final binary, you can use `xxd
<insert program name>`. This
program will allow you to see the code, and will print strings for things that can be converted to
strings. Another interesting tool is `otool`. For example with `otool -L <insert program name>` you
can see what system libraries have been linked.

## System documentation

The language is being compiled down to x86. If you are interested in reading more about this
architecture you can find documentation [here](https://software.intel.com/sites/default/files/managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf). It is huge and overwhelming, don't try to read it all. Instead use it as a reference. I recommend reading the index and finding what you are looking for. For example, if you want to learn about the register EAX, look up "general purpose registers" in chapter 3.4.1, on page 75. Similar documents exist for other architectures.

While this paper deals with x86, this computer architecture is not great for learners. If you
haven't had experience with system programming yet, or are new to how computers are built, i
recommend checking out the [nand2tetris](https://www.nand2tetris.org/) course.

If you want to get more comfortable with assembly programming, check out `TIS-100P` - a game about
programming assembly.

## See something missing from this repo?

I wrote this in a weekend after realizing that for a lot of people, the paper might be
inaccessible. If you are struggling with something in this repository, open an issue or a pull
request. That way we can make this project better and help more people learn.

