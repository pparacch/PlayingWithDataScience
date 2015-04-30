# R Plumbing: Fundamentals

[Getting Help](#help)

[Package Management](#package)

[Working Directory Management](#wd)

[Managing Loaded Named-Objects](#loadedObjects)

[Managing Available Data Sets](#dataset)

## <a id="help">Getting Help</a>

[R website](http://cran.r-project.org/)
[Stackoverflow](http://stackoverflow.com/)
### Locale
####Reminder
__[From edx.org]__ If you downloaded and installed R in a location other than the United States, you might encounter some formating issues later in this class due to language differences. To fix this, you will need to type in your R console:

Sys.setlocale("LC_ALL", "C")

This will only change the locale for your current R session.

### The Help command in R

Command | Description
------------ | ---------
`help(cmd)` | Brings up a help entry for the specified command.
`?cmd` | 
`help.start()` | Open the help system default browser.
`help.search("string")` | Search the Help System for the provided "string". 
`apropos(pattern)` | Show all of the commands that contains provided pattern. Note pattern can be a regular expression or a string.
`example(cmd)` | Run examples section from the online help.
`?Syntax` | To get a complete refence on operator syntax & precedences

## <a id="package">Package Management</a>
Command | Description
------------ | --------
`search()` | Show a list of packages (and other objects) that are loaded and available for use.
`installed.packages()` | Show a list of packages that are installed. __Note! Installed does not mean that is loaded & ready for use__.
`install.packages("name")` | Install a package (library) from the CRAN website.
`source("http://bioconductor.org/biocLite.R"); biocLite("packageName")` | Install a package (library) from the Bioconductor website.
`library(name)` | Load a package (previously installed), making it available for use. 
`detach(package:name)` | Make the package unavailable for use. Replace name with the package name to be detached.

The basic installation of R provides a set of commands that allow to carry out many of the task you might need. Sometimes you will need to run/ perform a specific task and the commands you need are not available. If you find out that the basic installation of R does not have the appropiate commands available, then remember that the [CRAN](http://cran.r-project.org/web/packages/available_packages_by_name.html) and [Bioconductor](http://bioconductor.org/) websites have additional packages available __ready to be used__.

### How to Install Extra packages
* Package Installer available in R for CRAN/ Bioconductor packages
* `install.packages()`command for CRAN package
* `source("http://bioconductor.org/biocLite.R"); biocLite("packageName")`commands for Bioconductor packages

### Running and manipulating packages
* You can see which packages have been installed using `installed.packages()`.

* You can search which packages are loaded and running in the current session using `search()`.

* You can load packages in the current session using `library(package)` Note!! package must be an installed package.

* You can make a package unavailable (removing or unloading) in the current session using `detach(package)`.

## <a id="wd">Working Directory Management</a>
The working directory is the location - in your file system - where file are looked and stored by default.

Command | Description
------------|--------------
`getwd()` | Return the current working directory.
`setwd("location")` | Set the current directory to the provided location. "location" can be an absolute path or relative path (relative to the current working directory).

__Note!__ If you want to change the working directory on a permanent basis look at the "Preferences" for R/ RStudio.

### Other Commands
Command | Description
------------ | ---------
`dir()` | List all files/ directories in the working directory.
`dir("location")` | List all files/ directories in the provided directory.
`dir(all.files = T)` | List all files/ directories including hidden ones.

##<a id="loadedObjects">Managing loaded Named-Objects</a>
Command | Description
------------ | ---------
`ls()` | List all objects available in the current session. Objects are ordered in alphabetically order.
`ls(pattern = "<pattern>)"` | List all of the objects available in the current session with a name matching the provided pattern. E.g. `ls(pattern = "b")` list all objects with a name containing __b__; `ls(pattern = "be")` list all objects with a name containing __be__; `ls(pattern = "^b")` list all objects with a name starting with __b__; `ls(pattern = "^[be]")` list all objects with a name starting with __b__ or __e__; `ls(pattern = "txt$")` list all objects with a name ending with __txt__; `ls(pattern = "a.b")` list all objects with a name containing   __a__'anyCharacter'__b__.
`rm(list)` same as `remove(list)` | Remove loaded objects, whose name is in the provided list, from the current session.

* Remove all loaded objects available in the current session `rm(list = ls()`
* Remove all loaded objects whose name matches the provided pattern `rm(list = ls("pattern"))`.
* Remove specific objects `rm(objectName1, objectName2, objectName3, ..)`.

##<a id="dataset">Managing Available data Sets</a>
Command | Description
------------ | ---------
`data()` | List all of the available data sets, all packages in teh search path are used.
`data(package = .packages(all.available = TRUE))`|List of all the available data sets for all of the available packages.
