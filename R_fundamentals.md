# R Fundamentals

[Help System](#help)
[Package Management](#package)
[Working Directory Management](#wd)
[NaN, NA & NULL: Special Values](#naNull)

## <a id="help">Help System</a>
Command | Description
------------ | ---------
`help(cmd)` | Brings up a help entry for the specified command.
`?cmd` | 
`help.start()` | Open the help system default browser.
`help.search("string")` | Search the Help System for the provided "string". 
`apropos(pattern)` | Show all of the commands that contains provided pattern. Note pattern can be a regular expression or a string.
`example(cmd)` | Run examples section from the online help.

## <a id="package">Package Management</a>
Command | Description
------------ | --------
`search()` | Show a list of packages (and other objects) that are loaded and available for use.
`installed.packages()` | Show a list of packages that are installed. __Note! Installed does not mean that is loaded & ready for use__.
`install.package("name")` | Install a package (library) from the CRAN website.
`library(name)` | Load a package (previously installed), making it available for use. 
`detach(package:name)` | Make the package unavailable for use. Replace name with the package name to be detached.

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

##<a id="naNull">NaN, NA & NULL: Special Values</a>
Missing values are expressed as 

* `NA`: Not Available
* `NaN`: Not a Number
* __Note!__ `NaN` is `NA` (but the opposite is not true)

Non existing values are expressed using `NULL`.

###Working with __NA__
In R there are multiple `NA`values, one for each mode:
>`>x <- c(1,2,NA) # create a numeric vector`
>`>mode(x[3])`
>`[1] "numeric"`
>`>y <- c("a", "b", NA, "c")`
>`>mode(y[3])`
>`[1] "character"`

We need to be very careful when checking if a value is `NA`(quite naive `x == NA`; correct approach `is.na(x)`).

>`>y[3] == NA`
> `[1] NA`

###Working with `NULL`
`NULL` is generally used to build up vectors in loops, adding elements to the vector during each iteration.
  
Checking if a value is NULL: `is.null(x)`

###Working with `NaN`
Checking if a value is `NaN`: `is.nan(x)`