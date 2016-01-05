# Overview

![fenestro icon](https://raw.githubusercontent.com/masukomi/fenestro/master/Fenestro/fenestro.iconset/icon_256x256.png)


Fenestro is a simple OS X app that takes HTML in via the command line, and
renders it in a window. 

## Common use cases:

### Saving terminal output for reference
It's not uncommon to run a grep, ls, or find on the command line which you end
up scrolling back up to again and again as you take action based on its output.
Fenestro will let you shunt that output into a window for reference. Just pipe
it through an app like [aha](https://github.com/theZiz/aha) which can convert
the output to HTML.

```bash
# save off a list of all the instances of "foo"
ack --color foo activesupport/test | aha | fenestro
```

### Quick view of HTML files on your system
Fenestro provides an easy way to quickly view HTML files on the command line. 
Maybe you've downloaded a repo, and the README is in HTML. Yes, you could do 
this with your web browser. Fenestro keeps it from opening as yet another tab in
one of your 20 windows spread across 4 desktops with 30 tabs each. ;)

```bash
fenestro --path path/to/README.html
```

### Better tool output

The deeper you go down the rabbit hole of command line awesomeness, the more
powerful your tools become. The more powerful your tools become the more poorly
suited the terminal is to outputting the details. Now your command line tools
can create visually complex, and useful output with crazy things like... \*gasp\*
images.

----

**Compilation & Installation instructions are at the bottom of this document.**

-----
# Usage
## Command line options

### Path To A File 
	-p file_path
	--path=file_path

Load HTML to be rendered from the specified file

### Display name for the html file
	-n name
	--name=name

The name that should be displayed in the sidebar. For example

	fenestro -p path/to/foo.html -n "foo.rb"

would display `foo.rb` in the sidebar.

### Version
	-v
	--version

Load an HTML page that displays the current version of the app.

----
# Compilation & Installation

```bash
$ git submodule update --init
$ make
$ mv build/Release/Fenestro.app /Applications/
```

Then double-click `Fenestro.app`. It will present you with a dialog, asking
where you'd like to install the command line tool.
