# R Fundamentals
## Help System
Command | Description
------------ | ---------
help(cmd) | Brings up a help entry for the specified command.
?cmd | 
help.start() | Open the help system default browser.
help.search("string") | Search the Help System for the provided "string". 
apropos(pattern) | Show all of the commands that contains provided pattern. Note pattern can be a regular expression or a string.
example(cmd) | Run examples section from the online help.

## Package Management
Command | Description
------------ | --------
search() | Show a list of packages (and other objects) that are loaded and available for use.
installed.packages() | Show a list of packages that are installed. __Note! Installed does not mean that is loaded & ready for use__.
install.package("name") | Install a package (library) from the CRAN website.
library(name) | Load a package (previously installed), making it available for use. 
detach(package:name) | Make the package unavailable for use. Replace name with the package name to be detached.


> Written with [StackEdit](https://stackedit.io/).