# LaunchControl
## Get rid of nasty start up applications on MacOSX

Whenever I restart my mac every few weeks I notice a huuuuge amount of applications which start up and idle in the background. Once you struggled with editing the launch agents by yourself you've noticed how much work it is to clean your system from all the junk. 
LaunchControl tries to make enabling disabling and viewing launch agents easy. 

## About
LaunchControl is a command line application which allows you to edit various startup items on your mac without leaving the terminal.
Not only does it disable/enable startup items, it allows you to edit specific launch parameters.

It does bundle an interactive cli application as well as a handy library to parse launchagents with ease.
Build with love and ruby.

## Instructions
To get a list of all launch agents type: 
`ruby launchcontrol.rb list`

To disable/enable a launch agent type:
`ruby launchcontrol.rb enable <launch-agent-id>`
`ruby launchcontrol.rb disable <launch-agent-id>`

For other instructions refer to:
`ruby launchcontrol.rb help`

## Documentation
The yard doc is bundled within the repository. I'll add an online mirror as soon as possible.

## Demo
Watch an example asciinema cast here: https://asciinema.org/a/489o4z2zk36un3y45d1bsgpkh

## Contributing
Make a pull request and I'll merge it. That's it. No Guidelines yet.

## Roadmap
- Better Readme (written in 4minutes)
- More Launch Agent Options
- Graphical Interface
- Create custom launch agents
- Get better at roadmaps.

## License

    Licensed under WTFPL:
    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
    Version 2, December 2004 

    Copyright (C) 2004 Sam Hocevar <sam@hocevar.net> 

    Everyone is permitted to copy and distribute verbatim or modified 
    copies of this license document, and changing it is allowed as long 
    as the name is changed. 

    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 

    0. You just DO WHAT THE FUCK YOU WANT TO.
