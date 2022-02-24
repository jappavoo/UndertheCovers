#### lots of little programs that naturally feel like built-ins
- `echo $PATH`
   - `ls /bin`
      - see `ls` there?
      - notice `bash` ;-)
   - how can we figure out where `ls` is coming from
      - bash has handy built in called `type`
        - `help type`
        - `type -a ls`
   - by tradition all preinstalled programs should have a manual page
        - `man ls`
        - `man bash`
        - `man <something in /bin>`

## extendent the shell is easy
- set `PATH="$HOME/bin:$PATH`
  - putting a program or script called `foobar` in `$HOME/bin`
    - now `$ foobar` will feel like a built-in

## overide what's there
- putting `ls` in `$HOME/bin` will now overide the others
- Even override a built in
  - `function echo() { builtin echo -n "myecho: "; builtin echo $@ }`
  - will talk about this one later

## natural ways of composing and extending via programming
Two important ones:

1. shell scripts
2. command pipelines

### shell provide natural model for composition

- put shell commands in a file : eg put this in `foobar`
``` bash
#!/bin/bash
echo "My first shell script"
echo "foobar"
```
- mark as executable
- now shell will be able to run `foobar`

### pipeline: allow programs to be easily composed

- `ls -1` list files - one per line
- `wc -l` counts lines
- `ls -l | wc -l` - tells us how man files in this direcotyr
- `ls -l /bin | wc -l`
-  or to get really fancy
  - exploit more knowledge about shell expansion abilities
  - `echo $PATH`
  - `echo ${PATH//:/ }`
  - `ls -1 ${PATH//:/ } | wc -l`
     - what do you think this did?  
