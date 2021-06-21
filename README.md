# POSIX Compliant Text Template Creator

`create-template`, or `ct` for short, is a POSIX compliant text template creator.
It allows users to quickly create files that are based on specific templates.

For instance, `./ct.sh main.c default lib1 lib2 extension` will create a `main.c` file which
has the templates `default`, `lib1`, `lib2`, `extension` loaded in order. As an example, in this
scenario `default` could contain `#include` guards for standard libraries while	`lib1` and `lib2`
could contain `#include` guards for external libraries, and `extension` could contain code to initialize
these libraries. This is only an example, users can incorporate templates into their projects however 
they wish.

## Usage

```
./ct.sh [-g|--generate] [-n|--no-edit] [-m|--make-executable]
[-q|--quiet] [-s|--no-messages] [-h|--help] [-v|--version] FILE [TEMPLATE]
```

In order to get started right away, copy my personal configuration files to your local configuration 
directory:
`cp -r hamza_ct_config ~/.config/ct`. Now run `./ct.sh -h` or `./ct.sh --help` to see what templates
are on the system. The following templates will be displayed: 
```
c: stdlib main 
java: driver class interface 
sh: default
```

Apply those templates to a file. `./ct.sh main.c stdlib main` will create a file `main.c` and place the given standard library
and main function templates into it in the given order. It is also possible to use template indices instead of the template names.
For instance, `./ct.sh main.c stdlib main` is equivilant to `./ct.sh main.c 0 1`. The user is free and encouraged to use the templates
however they wish. `./ct.sh main.c 1 0 1 1 0 1` is a prefectly valid way to load templates into `main.c`. Please try the examples out to 
better understand what occurs when the previous commands are executed.

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

Also if no template indeces or names are passed, such as with `./ct.sh main.c`, the default template belonging to template index `0`
is loaded into the file. Finally, by default `ct.sh` is not allowed to overwrite files. Overwriting will produce the following fatal message:
```
File FILE exists. Refusing to overwrite. Exitting
```
where `FILE` is the file name passed to `ct.sh`.

## Configuration and Creating Templates

This program encourages the user to configure it in whichever way they please to do so. By default `~/.config/ct` is the configuration 
directory, `~/.config/ct/.ct.conf` is the configuration file, and `~/.config/ct/.ct.info` is the template information file. These can be 
changed easily by modifying the source under the `# Configuration Data` section in `ct.sh`. 

Please follow the these steps to add your own templates to your local system:
1. Open up `~/.config/ct/.ct.conf` in your editor of choice and enter the following line:
```
LANGUAGE:EXTENSION:TEMPLATE1:TEMPLATE2:TEMPLATE3...
```
where `LANGUAGE` is the name of the programming language the template will belong to, `EXTENSION` is the file extension of the given language,
`TEMPLATE1` is the name of the first (default) template, `TEMPLATE2` is the name of the second template, and so on ...

Here's an example from my personal configuration file:
```
# C: standard library and main function
c:c:stdlib:main

# Java: driver class, implementation class, and interface
java:java:driver:class:interface

# POSIX sh: production environment template
sh:sh:default
```
There is no limit on the number of templates that can be used. Comments (indicated by `#`) and empty lines are allowed.
However, no field regardless of whether it is the field of `LANGUAGE`, `EXTENSION`, or `TEMPLATE...` can have any whitespace
or a colon (`:`) in it. 

2. Run `./ct.sh -g` or `./ct.sh --generate` to generate the necessary directories for the languages and files for the templates.

3. (Optional) Run `tree -a ~/.config/ct` and `cat ~/.config/ct/.ct.info` to better understand what files are created and what templates
are now available to the system. After step 2, `./ct.sh --help` will display the contents of `~/.config/ct/.ct.info` in order to remind the 
user what languages and templates are ready to use.

4. Finally modify your template file which can be found under `~/.config/ct/LANGUAGE/TEMPLATE` where `LANGUAGE` is the name of the language
that the template belongs to and `TEMPLATE` is the name of the template. Any modifications made to file will apear when applying the template
to a new file to work on. 

`$file` is a special string that can be added to template files in order for the `$file` string in the result file to be searched and replaced 
with the class or file name. Please skim the contents of the files under `hamza_ct_config/java/` and then create templates of java files 
such as `./ct.sh MyTesterClass.java driver` to better understand the role `$file` plays.

## Options and Features

- `-n` or `--no-edit` can be passed in order for `ct.sh` not to open the file for editing once the templates are loaded into the file.
By default, `$EDITOR`, or `vim` if `$EDITOR` is empty, is used as the text editor to edit the created file. This can be found and 
configured under the section `# Configuration Data`.
- `-m` or `--make-executable` can be passed in order for `ct.sh` to make the file executable once the templates are loaded into the file.
The file permissions `chmod` uses to make the file executable can be found and configured under the section `# Configuration Data`.
- `-q` or `--quiet` can be passed in order for `ct.sh` not to display any warning messages. This flag does not affect error messages.
- `-s` or `--no-messages` can be passed in order for `ct.sh` not to display any error messages. This flag does not affect warning messages.
- `-h` or `--help` displays the help menu.
- `-v` or `--version` displays version information.

The order of the passed options makes no difference. `ct.sh` currently does not support stacking up short options. Please use
`./ct.sh file.extension -s -q -n -m` instead of `./ct.sh file.extension -sqnm`.

### LICENSE and AUTHOR

- `create-template` is free/libre software. This program is released under the GPLv3 license, which you can find in the file `LICENSE.txt`. 
LICENCE.txt).

- `create-template` and its documentation is written entirely by Hamza Kerem Mumcu. Version 1.1 was released June 21 2021. You can reach me 
at hamzamumcu@protonmail.com.

### TODO

All contributions are welcome.

1. Add an append mode. Templates should be able to get applied to already existing files, perhaps with a `--append` flag.
2. Add multiple file extension support. For instance, C header files should be recognized as a C file. This what it could look like in the 
configuration file: `c:c,h:TEMPLATE...` where `c` and `h` are file extensions.
