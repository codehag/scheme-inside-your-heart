# Quirks.

Building and running

* names get mangled when I build. The tutorial had the following output:

    ```asm
        .text
        .globl scheme_entry
        .type scheme_entry, @function
    scheme_entry:
        movl $~s, %eax" x
     ret"
    ```
    gcc mangles it. It becomes:

    ```asm
        .text
        .globl _scheme_entry
        .type scheme_entry, @function
    _scheme_entry:
        movl $~s, %eax" x
     ret"
    ```
* `.type` diretive not recognized on mach. So, what was

    ```asm
        .text
        .globl _scheme_entry
        .type scheme_entry, @function
    _scheme_entry:
        movl $~s, %eax" x
     ret"
    ```
    should instead be
    ```asm
        .text
        .globl _scheme_entry

    _scheme_entry:
        movl $~s, %eax" x
     ret"
    ```
* tests-driver.scm was missing a definition, `add-tests-with-string-output-noboot `, which caused
    the test driver to fail. I just copied over `add-tests-with-string-output` and it works fine
    now.
* `compile-program` needed to be defined at the top of test runner, or chez would complain that it
    wasn't defined.

