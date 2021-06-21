# POSIX Compliant Text Template Creator

`create-template` or `ct` for short is a POSIX compliant text template creator.
It allows users to quickly create files that are based on specific templates.

For instance, `./ct.sh main.c default lib1 lib2 extension` will create a `main.c` file which
has the templates `default`, `lib1`, `lib2`, `extension` loaded in order. As an example, in this
scenario `default` could contain `#include` guards for standard libraries while	`lib1` and `lib2'`
could contain `#include` guards for external libraries, and `extension` could contain code to initialize
these libraries. This is only an example, users can incorporate templates into their projects however 
they wish.

## Usage

```
./ct.sh [-g|--generate] [-n|--no-edit] [-m|--make-executable]
[-q|--quiet] [-s|--no-messages] [-h|--help] [-v|--version] FILE 
```

In order to get started right away, copy my personal configuration files to your local configuration 
directory: `cp hamza_ct_config ~/.config/ct`. Now run `./ct.sh -h` or `./ct.sh --help` to see what templates
are on the system. The following templates will be displayed: 
```
c: stdlib main 
java: driver class interface 
sh: default
```

Apply those templates to a file. `./ct.sh main.c stdlib main` will create a file `main.c` and place the given standard library
and main function templates into it in the given order. It is also possible to use template indices instead of the template names.
For instance, `./ct.sh main.c stdlib main` is equivilant to `./ct.sh main.c 0 1`. The user is free and encouraged to use the templates
however they wish. `./ct.sh main.c 1 0 1 1 0 1` is a prefectly valid way to load templates into `main.c`. 

Entering invalid template indeces or names simply produces a non-fatal warning message such as 
```
Template INDEX is not a valid template index. Skipping.
```
or 
```
Template NAME is not a valid template name. Skipping.
```
where `INDEX` and `NAME` are passed template index and name values.

The passed invalid template indeces or names do not affect the file. For instance running `./ct.sh main.c 0 300 main asdfgh` 
will apply the valid templates `0` and `main` in the given order, however it will also produce the following warning messages:
```
Template 300 is not a valid template index. Skipping.
Template asdfgh is not a valid template name. Skipping.
```

Also if no template indeces or names are passed, such as with `./ct.sh main.c`, the default template belonging to template index 0
is loaded into the file. Finally, by default `ct.sh` is not allowed to overwrite files. Overwriting will produce the following fatal message:
```
File FILE exists. Refusing to overwrite. Exitting
```
where `FILE` is the file name passed to `ct.sh`.
