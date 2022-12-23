# Enhanced Bash System

## Modular and Library enforced BASH Environment

The entire documentation can be found in the [Wiki](../../wiki/Home) (Currently under construction)

+--------] EBv3 Help System [----------------------------------------------------------------------+
|                                                                                                  |
|  EBv3 (Extended BASH version 3) is a modular approach for building easy to use scripts, aliases, |
|  and prompts to allow users to quickly complete tasks from the command line. Each item listed    |
|  below are made of of modules, libraries, and aliases which are color coded the same below.      |
|                                                                                                  |
|  Modules and aliases are ran from the cli just like a program. Libraries can be ran from the     |
|  command line but are intended to help with building BASH scripts.                               |
|                                                                                                  |
|   File System          Data and Reference         String Manipulation         System             |
|     backup               systeminfo                 eb_trim_string              sysstart         |
|     dirjump (d)          userlist                   eb_trim_all                 sysrestart       |
|     empty                weather                    eb_regex                    sysstop          |
|     extract              viewcode                   eb_split                    sysstatus        |
|     inpath                                          eb_lower                    please           |
|     home               Logging System               eb_upper                    systeminfo       |
|     root                 eb3log                     eb_reverse_case                              |
|     resetperms           taillog                    eb_trim_quotes            Interface System   |
|                          viewlog                    eb_strip                    choices          |
|                                                     eb_strip_all                cls | c | clear  |
|                                                     eb_lstrip                   prettytable      |
|                                                     eb_rstrip                   start_spinner    |
|                                                     eb_urlencode                stop_spinner     |
|                                                     eb_urldecode                drawscreen       |
|                                                     eb_sqeeze                                    |
+--------------------------------------------------------------------------------------------------+

* backup - Easily creates backups of files or folders
* dirjump (d) - quickly jumps around to the last 15 directories you have visited
* empty - quickly empty a file without losing permissions
* extract - Extracts automagically (*almost) any compression type
* inpath - checks for a file quickly through out the path
* home - just like ${HOME}
* root - same as cd ${dir_separator}
* resetperms - resets the permissions of a folder to 755 and 644 for files
* systeminfo - quick way of finding system information
* userlist - An advanced user list on the system
* weather - A quick weather forecast for your terminal and prompt
* viewcode - automagically colors many types of languages and displays them
* viewlog - automagically colors and displays log files
* taillog - automagically colors and tails log files
* eb3log - automagically colors and displays EBv3 log files
* please - takes the last command and adds sudo to it
* prettytable - Turn arrays into a table
* start and stop spinner - A graphical way of showing a loading or progress indicator
* full 256 color support with names
* easy menu system (currently under construction)
* Many text and array functions
* plus much, much more!

## What is this?

**ebv3** (Enhanced BASH v3), started in theory and became several mini scripts cluttered throughout my directory structure for easy quick commands to run routine tasks as a system administrator; whereas now **eb3** has evolved over a long period of time for ease of use, manipulation, and portability. Although this particular version is still fairly new, over the past decade I have been collecting, building, customizing and designing scripts to make the terminal experience easier to use by reducing mundane commands with long arguments as well as make it universal between different distributions of Linux as possible.

Previous versions started with scripting on [Oracle Linux](https://www.oracle.com/linux/) (RHEL distro), which later switched to [RedHat](https://www.redhat.com/) 6. At home my primary distro to use was [Debian](https://www.debian.org/) Linux, and finally experimented with [Gentoo](https://www.gentoo.org/) and [Slackware](https://www.slackware.com/). I also installed [ZSH](https://zsh.sourceforge.net/) on my home lab, which I abandoned rather quickly for continued scripting on other environments.

Because the majority of the development of this script has been from home (since it seems out of 1200 people at work there is always a fire to put out), much of my testing has been done on a [custom made](https://www.linuxfromscratch.org/) Debian distro. I have researched other systems by using [Google](https://www.google.com/), and [Stack Overflow](https://www.stackoverflow.com/), as well as talked with other admins about compatibility, including fetching a new version on my work PC once a week.

Something very important to say here, although I have came up with the concept of this modular approach, I have not 100% created each of these scripts many have come from [Awesome Shell](https://github.com/alebcay/awesome-shell), [DylanRaps](https://github.com/dylanaraps), and many contributors from [Stack Overflow](https://www.stackoverflow.com/) although I have created many of them myself. As I continue to build this system, I will be going through and giving credit to each of those people for their scripts. This was once in mind just a way to keep some of the scripts I found throughout the internet and use them for my personal use. I believe this concept is too good of an idea to let it not be shared. If you are someone who has created one of the scripts in this, please let me know if you approve of me using and so I can give you credit where it is due.

## The Concept

I have been borrowing other peoples scripts, building my own script, using different environments for root, development and it seems like my Linux commands would change and then I would forget, and then I feel like a noob scouring the net to find the right argument for this particular distro and version. I wanted to have the ability to have a configuration file that can be easily modified when I change locations or servers I do not have to modify the code in a million different places to match my location. I work in one city and live in another, one of my modules is a nice little weather and calendar function. By changing the city in the config file updates all of my other Geo-location information.

## Installation

[Installation documentation](../../wiki/Installation)

```sh
git clone https://github.com/girls-whocode/eb3.git
cd eb3
./install.sh # sudo will be required to install the dependency files and update the package lists
# close and reopen terminal
```

## Uninstall or Remove EB3
A backup of your original bashrc is located in the eb3/etc/conf/ folder. The backup file will replace the
home bashrc before the installation was done. To remove eb3:

```sh
eb3 remove
```

## Really cool stuff being added

I know I said that most of the scripts have been created by me, but now I have found one of my favorite BASH script developers. His name is Dylan and he has created
a large amount of scripts I will start adding into my EBv3 system. Check out his [GitHub page](https://github.com/dylanaraps). Another place where I will be adding many more scripts is [Awesome Shell](https://github.com/alebcay/awesome-shell).

## What can you do

**Be a tester!** EBv3 is a noninvasive system that only installs in ```${HOME}/.local/bin/eb3/``` folder, and a backup of your previous .bashrc file is saved to ```${HOME}/.local/bin/eb3/var/backup/``` folder with the date and time added to the filename. The additional packages that are installed are "bc" "jq" "git" "curl" "wget" "zip" "7zip" "unrar" "gzip" "python3" "python3-tk" "python3-dev". Removing eb3 is very simple.

**Develop!** System Administrators from various distributions use functions everyday. Build more modules, libraries, and other BASH version 4+ scripts to add. Credit will be made to any that is added.

**Give feedback!** Use the issues section to help all of us contributors to build a system that is cross platform and is useful to make our jobs easier.

> ## References
>
> - This document leveraged heavily from the [Markdown-Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet).
> - The original [Markdown Syntax Guide](https://daringfireball.net/projects/markdown/syntax) at Daring Fireball is an excellent resource for a detailed explanation of standard Markdown.
> - The detailed specification for CommonMark can be found in the [CommonMark Spec](https://spec.commonmark.org/current/)
> - The [CommonMark Dingus](https://try.commonmark.org) is a handy tool for testing CommonMark syntax.
