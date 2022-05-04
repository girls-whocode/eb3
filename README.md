# Modular and Library enforced BASH Environment

The entire documentation can be found in the [Wiki](Home)

## What is this?

**eb3** (Enhanced BASH v3), started in theory and became several mini scripts cluttered throughout my directory structure for easy quick commands to run routine tasks as a system administrator; whereas now **eb3** has evolved over a long period of time for ease of use, manulipation, and portability. Although this particular version is still fairly new, over the past decade I have been collecting, building, customizing and designing scripts to make the terminal experience easier to use by reducing mundane commands with long arguments as well as make it universal between different distributions of Linux as possible.

Previous versions started with scripting on [Oracle Linux](https://www.oracle.com/linux/) (RHEL distro), which later switched to [RedHat](https://www.redhat.com/) 6. At home my primary distro to use was [Debian](https://www.debian.org/) Linux, and finally experimented with [Gentoo](https://www.gentoo.org/) and [Slackware](http://www.slackware.com/). I also installed [ZSH](http://zsh.sourceforge.net/) on my home lab, which I abandoned rather quickly for continued scripting on other environments.

Because the majority of the development of this script has been from home (since it seems out of 1200 people at work there is always a fire to put out), much of my testing has been done on a [custom made](http://www.linuxfromscratch.org/) Debian distro. I have researched other systems by using [Googled](https://www.google.com/), and [Stack Overflow](http://www.stackoverflow.com/), as well as talked with other admins about compatibility, including fetching a new version on my work PC once a week.

Something very important to say here, although I have came up with the concept of this modular approach, I have not 100% created each of these scripts, although I have created most of them. As I continue to build this system, I will be going through and giving credit to each of those people for their scripts. This was once in mind just a way to keep some of the scripts I found throughout the internet and use them for my personal use. I believe this concept is too good of an idea to let it not be shared. If you are someone who has created one of the scripts in this, please let me know if you approve of me using and so I can give you credit where it is due.

## The Concept

I have been borrowing other peoples scripts, building my own script, using different environments for root, development and it seems like my Linux commands would change and then I would forget, and then I feel like a noob scouring the net to find the right argument for this particular distro and version. I wanted to have the ability to have a configuration file that can be easily modified when I change locations or servers I do not have to modify the code in a million different places to match my location. I work in one city and live in another, one of my modules is a nice little weather and calendar function. By changing the city in the config file updates all of my other geo-location information.

## Installation

[Installation documentation](wiki/Installation)

```sh
git clone https://github.com/girls-whocode/eb3.git
cd eb3
./install.sh # sudo will be required to install the dependancy files and update the package list
# close and reopen terminal
```

> ## References
>
> - This document leveraged heavily from the [Markdown-Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet).
> - The original [Markdown Syntax Guide](https://daringfireball.net/projects/markdown/syntax) at Daring Fireball is an excellent resource for a detailed explanation of standard Markdown.
> - The detailed specification for CommonMark can be found in the [CommonMark Spec](https://spec.commonmark.org/current/)
> - The [CommonMark Dingus](http://try.commonmark.org) is a handy tool for testing CommonMark syntax.
>
