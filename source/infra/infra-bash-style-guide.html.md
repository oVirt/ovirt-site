---
title: Infra Bash style guide
category: infra
authors: dcaroest
wiki_category: Infrastructure
wiki_title: Infra Bash style guide
wiki_revision_count: 18
wiki_last_updated: 2014-03-25
---

# Infra bash scripts style guide

These are some coding guidelines in order to have a reference when submitting patches. It's based on the guidelines here <http://wiki.bash-hackers.org/scripting/style>

This is not an enforcement, it's meant to be just a reference, of course, compliance is preferred.

Some good code layout helps you to read your own code after a while. And of course it helps others to read the code.

### Indentation guidelines

To indent, use 4 spaces per indentation level, similar to python indentation.

Avoid hard-tabs them if possible. I can imagine one case where they're useful: Indenting here-documents.

But in any case, **DO NOT MIX THEM**. If you decide to use tabs instead of spaces, be consistent.

#### Breaking up lines

Whenever you need to break lines of long code, you should follow one of these two ways:

**Indention using command width:**

      activate some_very_long_option \
               some_other_option

**Indention using four spaces:**

      activate some_very_long_option \
          some_other_option

#### Breaking compound commands

Compound commands form the structures that make a shell script different from a stupid enumeration of commands. Usually they contain a kind of "head" and a "body" that contains command lists. This kind of compound command is relatively easy to indent.

The general layout:

*   put the introducing keyword and the initial command list or parameters on one line ("head")
*   put the "body-introducing" keyword on the same line
*   the command list of the "body" on separate lines, indented by two spaces
*   put the closing keyword on a separated line, indented like the initial introducing keyword

#### Symbolic

      HEAD_KEYWORD parameters; BODY_BEGIN
          BODY_COMMANDS
      BODY_END

##### if/then/elif/else

This construct is a bit special, because it has keywords (*elif*, *else*) "in the middle". The visually nice way is to indent them like the *if*:

      if ...; then
          ...
      elif ...; then
          ...
      else
          ...
      fi

##### for

      for f in /etc/*; do
          ...
      done

##### while/until

      while [[ $answer != [YyNn] ]]; do
          ...
      done

##### The case construct

The *case* construct might need a bit more discussion here, since the structure is a bit more complex.

In general it's the same: Every new "layer" gets a new indention level:

      case $input in
          hello) echo "You said hello";;
          bye)
              echo "You said bye"
              if foo; then
                  bar
              fi
          ;;
          *)
              echo "You said something weird..."
          ;;
      esac

Some notes:

*   if not 100% needed, the optional left parenthesis on the pattern is not written
*   the patterns (*hello)*) and the corresponding action terminator (*;;*) are indented at the same level
*   the action command lists are indented one more level (and continue to have their own indention, if needed)
*   though optional, the very last action terminator is given
*   for very short bodies, the case can be written in one line

### Syntax and coding guidelines

#### Basic structure

The basic structure of a script simply reads:

      #!SHEBANG
      GLOBAL_CONFIGURATION_CONSTANTS
      FUNCTION_DEFINITIONS
      MAIN_CODE
        PARSING_OPTIONS
        VERIFYING_OPTIONS
        SIMPLE_MAIN_CODE

##### The shebang

If possible (I know it's not always possible!), use a shebang. Be careful with */bin/sh*: The argument that "on Linux */bin/sh* is a Bash" **is a lie** (and technically irrelevant) The shebang serves two purposes for me:

*   it specifies the interpreter when the script file is called directly: If you code for Bash, specify *bash*!
*   it documents the desired interpreter (so: use *bash* when you write a Bash-script, use *sh* when you write a general Bourne/POSIX script, ...)

Whenever able, use the *-e* flag, that will make sure your script fails if any of the commands fail:

      #!/bin/bash -e

If you don't really care about one of the commands failing (or returning != 0) you can use this:

      mycommand || :

#### Cryptic constructs

Cryptic constructs, we all know them, we all love them. If they are not 100% needed, avoid them, since nobody except you may be able to decipher them. It's - just like in C - the middle between smartness, efficiency and readablity. If you need to use a cryptic construct, place a small comment that actually tells what your monster is for.

#### Configuration variables

I call variables that are meant to be changed by the user "configuration variables" here. Make them easy to find (directly at the top of the script), give them useful names and maybe a short comment. Use *UPPERCASE* for them and avoid modifying them inside the script if you don't need to, it's really easy to loose track of where/when a global variable it's being modified.

When parsing the parameters, if you use a function, initialize all the global variables with the default values (or unset) before the function so when reading the script you know what globals the function does modify. For example:

      CONFIG_FILE="~/.config"
      unset REQUIRED_PARAM
      parse_params "$@"

#### Local variables

Since all reserved variables are *UPPERCASE*, the safest way is to only use *lowercase* variable names. This is true for reading user input, loop counting variables, etc., ... (in the example: *file*)

*   prefer *lowercase* variables
*   if you use *UPPERCASE* names, \*\*do not use reserved variable names\*\* (see [SUS](http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap08.html#tag_08) for an incomplete list)
*   if you use *UPPERCASE* names, at best prepend the name with a unique prefix (*MY_* in the example below)

If used inside a function, declare as many variables as possible to be local, that will avoid name collision wherever you use that function.

      #!/bin/bash
      # global with the prefix 'MY_'
      MY_LOG_DIRECTORY=/var/adm/
      my_nice_function() {
          local file="${1?}"
          echo "This file variable $file is not the same as the one used outside"
          return 0
      }
      # local variable lowercase
      for file in "$MY_LOG_DIRECTORY"/*; do
          echo "Found Logfile: $file"
          my_nice_function "whatever"
      done

#### Variable initialization

As in C, it's always a good idea to initialize your variables, though, the shell will initialize fresh variables itself (better: Unset variables will generally behave like variables containing a nullstring). It's no problem to \*\*pass a variable\*\* you use \*\*as environment\*\* to the script. If you \*\*blindly assume\*\* that all variables you use are empty for the first time, somebody can \*\*inject\*\* a variable content by just passing it in the environment. The solution is simple and effective: \*\*Initialize them\*\*

      my_input=""
      my_array=()
      my_number=0

If you do that for every variable you use, then you also have a kind of documentation for them.

#### Parameter expansion

Unless you are really sure what you're doing, \*\*quote every parameter expansion\*\*. There are some cases where this isn't needed from a technical point of view, e.g.

*   inside *[[ ... ]]*
*   the parameter (*WORD*) in *case $WORD in ....*
*   variable asssignment: *VAR=$WORD*

But quoting these is never a mistake. If you get used to quote every parameter expansion, you're safe. If you need to parse a parameter as a list of words, you can't quote, of course, like

      list="one two three"
      # you MUST NOT quote $list here
      for word in $list; do
          ...
      done

#### Function definitions

Unless the code has reasons to not do, all needed function definitions should be declared before the main script code is run. This gives a far better overview and ensures that all function names are known before they are used. Since a function isn't parsed before it is executed, you usually don't even have to ensure a specific order. The portable form of the function definition should be used, without the *function* keyword (here using the grouping compound command):

      getargs() {
          ...
      }

Speaking about the command grouping in function definitions using *{ ...; }*: If you don't have a good reason to use another compound command directly, you should always use this one.

#### Function names

Function names should be all *lowercase* and have a good name. The function names should be human readable ones.

A function named *f1* may be easy and quick to write down, but for debugging and especially for other people, it will tell nothing. Good names help to document the code without using extra comments.

A more or less funny one: If not intended to do so, **do not name your functions like common commands**, typically new users tend to name their scripts or functions *test*, which collides with the UNIX *test* command!

Unless absolutely necessary, only use alphanumeric characters and the underscore for function names. */bin/ls* is a valid function name in Bash, but it only makes limited sense.

#### Function parameters

When able, passs all the needed information to the functions you use using parameters instead of global variables, that helps keeping track of what infermation does the function require to run. If you ever need to use global variables inside the function, make sure that the function comments specify which ones you use. The parameters passed to the function should be stored in local variables at the start of the function, adding any required checks (the easiest one being just "${1?}" to make sure the param is not empty)

#### Function return statements

Most functions should not use the exit statements, instead, they should use the return statement and let the caller of the function handle the error. Some exceptions include the *die* function. You should always write a return statement explicitly, to make sure that you return what you want and make it clear what the function will return. So usually, your functions will end with a return 0 statement.

##### Example

For example the following function, will return 1 when finishing correctly:

      my_func() {
          local res=0
          do_something
          res=$(($res + $?))
          [[ $res -ne 0 ]] && die "custom message"
      }

Because the last statement return code will be the return code of the function, so to avoid confusions you should use:

      my_func() {
          local res=0
          do_something
          res=$(($res + $?))
          [[ $res -ne 0 ]] && die "custom message"
          return 0
      }

#### Command substitution

As noted in [ the article about command substitution](http://wiki.bash-hackers.org/syntax/expansion/cmdsubst) you should use the *$( ... )* form. Though, if portability is a concern, you might have to use the backquoted form *\` ... \`*. In any case, if other expansions and word splitting are not wanted, you should quote the command substitution!

#### Conditionals

When testing an expression, use double brackets as much as possible, they behave better that the old test command (single square brackets) and you'll have a lot less trouble handling spaces.

#### Builtins

If able use builtin constructs instead of spawning external commands, for example:

      myfile="${fullpath##*/}" # replaces dirname
      mydir="${fullpath%/*}"  # replaces basename

#### Eval

**"If eval is the answer, surely you are asking the wrong question."** Avoid if, unless absolutely neccesary:

      * `*`eval`*` can be your neckshot
      * there are most likely other ways to achieve what you want
      * if possible, re-think the way your script works, if it seems you can't avoid `*`eval`*` with your current way
      * if you really really have to use it, then you should take care and know what you do (**if** you know what you do, then `*`eval`*` is not evil at all)

### Behaviour and robustness

#### Fail early

**Fail early**, this sounds bad, but usually is good. Failing early means to error out as early as possible when checks indicate some error or unmet condition. Failing early means to error out **before** your script begins its work in a potentially broken state.

#### Availability of commands

If you use commands that might not be installed on the system, check for their availability and tell the user what's missing. Example:

      my_needed_commands="sed awk lsof who"
      missing_counter=0
      for needed_command in $my_needed_commands; do
          if ! hash "$needed_command" >/dev/null 2>&1; then
              echo "Command not found in PATH: $needed_command" >&2
              missing_counter=$(($missing_counter + 1))
          fi
      done
      if (($missing_counter > 0)); then
          echo "Minimum $missing_counter commands are missing in PATH, aborting" >&2
          exit 1
      fi

#### Exit meaningfully

The exit code is your only way to directly communicate with the calling process without any special things to do. If your script exits, provide a meaningful exit code. That minimally means:

*   *exit 0* (zero) if everything is okay
*   *exit 1* - in general non-zero - if there was an error

This, **and only this**, will enable the calling component to check the operation status of your script.

You know:

"One of the main causes of the fall of the Roman Empire was that, lacking zero, they had no way to indicate successful termination of their C programs."

//-- Robert Firth//

# Misc

### Output and appearance

*   if the script is interactive, if it works for you and if you think this is a nice feature, you can try to save the terminal content and restore it after execution
*   output clean and understandable messages to the screen
*   if applicable, you can use colors or specific prefixes to tag error and warning messages
    -   makes it more easy for the user to identify those messages
*   write normal output to *STDOUT* and error, warning and diagnostic messages to *STDERR*
    -   this gives the possibility to filter
    -   this doesn't make the script poison the real output data with diagnostic messages
    -   if the script gives syntax help (*-?* or *-h* or *--help* arguments), it should go to *STDOUT*, since it's expected output in this moment
*   if applicable, write a logfile that contains all the details
    -   it doesn't clutter the screen then
    -   the messages are saved for later and don't get lost (diagnostics)

### Input

Never blindly assume anything. If you want the user to input a number, **check the input** for being a number, check for leading zeros, etc... As we all know, users are users and not programmers. They will do what they want, not what the program wants. If you have specific format or content needs, **always check the input**

### Potability

If you can imagine a reason where you script is going to be executed on a machine where bash is not available (most common linux distributions and gnu based systems have bash as default shell), you should use the POSIX standard. For example, when creating a script that is going to be included in a project as part of the official build process.

# Other Coding style guidelines

*   <http://www.opensolaris.org/os/project/shell/shellstyle/>

<Category:Infrastructure>
