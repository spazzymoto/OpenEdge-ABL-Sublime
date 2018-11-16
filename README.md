# OpenEdge ABL 4GL support for Sublime Text 3

Inspired By [GabSoftware](http://www.gabsoftware.com/)

## Building

  - Linux: Run /build.sh in the root directory
  - Windows: Open to pull request for bat file :)
  
## Installing or modifying

1. Close Sublime Text if necessary
2. Locate the data directory of Sublime Text 3 :
   * On Windows, it is located in `%APPDATA%\Sublime Text 3`
   * On Linux, it is located in `~/.config/sublime-text-3`
   * On OS X, it is located in `~/Library/Application Support/Sublime Text 3`
3. In the data directory, place the package `OpenEdge ABL.sublime-package` in the `Installed Packages` directory.
4. In the data directory (but in `%LOCALAPPDATA%\Sublime Text 3` in Windows!), delete the `Cache/OpenEdge ABL` directory
5. Restart Sublime Text
6. You may need to open each progress file type (.p, .cls, .i, .w...) and associate them with the new syntax scheme:
   `View > Syntax > Open all with current extension as... > OpenEdge ABL`

## AppBuild Color Theme

1. `Preferences > Color Scheme... > OpenEdge AppBuilder`

## "Check Syntax,Compile,Run" support with auto capitalization of keywords

It is possible to get the "Check Syntax,Compile,Run,Run GUI/CHUI" feature of OpenEdge working in Sublime Text. To do so, you can follow these steps :

1. Makes sure you have saved your project, this creates a <project_name>.sublime-project
2. In this file create an abl json node in the settings node with the following options
```
  {
    "folders":
    [
      {
        "path": "."
      }
    ],
    "settings":
    {
      "abl":
      {
        "dlc": "/path/to/dlc",
        "hooks":  
        {
          "pre": "hooks/pre.p",
          "post": "hooks/post.p"
        },
        "pf": "conf/sublime.pf",
        "propath":
        [
          "src/module1",
          "src/module2"
        ],
        "db": [
          "-db /path/to/db -ld somedb -1",
          "-db /path/to/db2 -ld somedb2 -1"
        ],
        "uppercase_keywords": true
      }
    }
  }
```

Options
=======
  - dlc:                Path to your DLC. If not provided this will be resolved from the system DLC environment variable.
  - hooks.pre           Fired after the propath node has been set and before the desired actions run, check_syntax, etc...
  - hooks.post          Fired after the desired actions run, check_syntax, etc...
  - pf                  PF file for the progress session
  - propath             Sets the propath in the progress session
  - db                  List of DB connections
  - uppercase_keywords  This will uppercase the OpenEdge ABL keywords as you type

3. Hitting CTRL + SHIFT + B will give you a list
  - ABL                  : checks syntax
  - ABL - Check Syntax   : checks syntax
  - ABL - Compile        : compiles
  - ABL - Run Batch      : runs code in an \_progres -b session and returns messages to the sublime console
  - ABL - Run GUI/CHUI   : runs the code in an prowin/32.exe or \_progres session
3. You can now repeat your last choice by hitting CTRL + B

## Notes

This product is not supported by Progress.