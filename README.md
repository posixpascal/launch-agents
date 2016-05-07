# LaunchControl

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


## Contributing
Make a pull request and I'll merge it. That's it. No Guidelines yet.

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