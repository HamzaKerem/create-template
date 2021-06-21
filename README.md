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
