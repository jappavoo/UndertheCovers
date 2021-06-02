#!/usr/bin/env python
# coding: utf-8

# In[6]:


get_ipython().run_cell_magic('html', '', '<script>\n    // AUTORUN ALL CELLS ON NOTEBOOK-LOAD!\n    console.log("hello")\n    require(\n        [\'base/js/namespace\', \'jquery\'], \n        function(jupyter, $) {\n            $(jupyter.events).on("kernel_ready.Kernel", function () {\n                console.log("Auto-running all cells-below...");\n                jupyter.actions.call(\'jupyter-notebook:run-all-cells-below\');\n            });\n        }\n    );\n</script>\nHello')


# In[11]:


import requests
from notebook.notebookapp import list_running_servers
# get server info so that we can make api calls 
servers=list(list_running_servers())
print(servers)
import os
 
# printing environment variables
print(os.getenv('JUPYTERHUB_SERVICE_PREFIX'))
print('http://www.google.com')


# # Lets write some assembly code
# 
# In this chapter we will get going and write some simple assembly code,  "build" it and run it within a "debugger" so that we can get a sense of how everything fits together.
# 
# To do this we will use three terminal sessions one terminal to run an ascii editor, one to run the shell on its own so that we can compile our source code, and one to run our debugger.  We use three different terminals so that we can stay organized and avoid having to constantly stop and start the different programs.   In some sense we are using multiple terminals to form our own Integrated Development Environmnt (IDE) where we are using each terminal as if it were a subwindow of our IDE.  In actuality the editor that we will be using (emacs) has support for integrating all three tasks within itself but for the moment we will keep things seperate to make sure we know what is going on and not tie ourselves to this particular editor (there are many others including the popular VIM).

# In[7]:


import requests
from notebook.notebookapp import list_running_servers
# get server info so that we can make api calls 
servers=list(list_running_servers())
#print(servers)
# This is probably not the right approach to testing if we are on juypterlab vs notebook ... but 
# works on my current setup ... will likely need to test and fix 
if not servers:
    # assume if we can't find servers we are running on JuypterLab -- terminal rest interface has changed 
    from IPython.core.display import display, HTML
    display(HTML('<p>This button will open a seperate tab with the terminal that we will use to run our editor' +
             '<form action="/terminals/EditorTerm" target="EditorFrame">' + 
             '<input type="submit" value="Open EDITOR Terminal" /> </form>' +
             '<p>This link will open a seperate tab with the terminal that we will use to run our ' +
             'commands to "build" our program' + 
             '<form action="/terminals/BuildTerm" target="BuildFrame">' + 
             '<input type="submit" value="Open BUILD Terminal" /> </form>' +
             '<p>This link will open a seperate tab with the terminal that we will use to run the debugger' +
             '<form action="/terminals/DebuggerTerm" target="DebuggerFrame">' + 
             '<input type="submit" value="Open DEBUGGER Terminal" /> </form>'
            ))
else:
    info=next(list_running_servers())
    base_url=info['url']
    api_url=base_url + 'api/terminals'
    api_token=info['token']

    # get list of current terminals so that we can reuse this if enough exist 
    # otherwise we will create new ones as needed
    r=requests.get(url=api_url, headers={'Authorization': 'token ' + api_token})
    TERMINALS=r.json()

    try:
        EDITORTERM=TERMINALS[0]['name']
    except IndexError:
        # create a terminal for our editor
        r=requests.post(url=api_url, headers={'Authorization': 'token ' + api_token})
        c=r.json()
        EDITORTERM=c['name']

    try:
        BUILDTERM=TERMINALS[1]['name']
    except IndexError:   
        # create a terminal for running out builds
        r=requests.post(url=api_url, headers={'Authorization': 'token ' + api_token})
        c=r.json()
        BUILDTERM=c['name']

    try:
        DEBUGGERTERM=TERMINALS[2]['name']
    except IndexError:   
        # create a terminal for running gdb
        r=requests.post(url=api_url, headers={'Authorization': 'token ' + api_token})
        c=r.json()
        DEBUGGERTERM=c['name']
    

    from IPython.core.display import display, HTML
    display(HTML('<p>This button will open a seperate tab with the terminal that we will use to run our editor' +
             '<form action="' + base_url + 'terminals/' + EDITORTERM + '" target="EditorFrame">' + 
             '<input type="submit" value="Open EDITOR Terminal" /> </form>' +
             '<p>This link will open a seperate tab with the terminal that we will use to run our ' +
             'commands to "build" our program' + 
             '<form action="' + base_url + 'terminals/' + BUILDTERM + '" target="BuildFrame">' + 
             '<input type="submit" value="Open BUILD Terminal" /> </form>' +
             '<p>This link will open a seperate tab with the terminal that we will use to run the debugger' +
             '<form action="' + base_url + 'terminals/' + DEBUGGERTERM + '" target="DebuggerFrame">' + 
             '<input type="submit" value="Open DEBUGGER Terminal" /> </form>'
            ))
            


# ## EDITOR : Terminal to run our editor 
# 
# An editor allows us to create and udpate plain text ascii files. An editor is the core tool of a programmer!  Programming is all about writing software in the form of ascii files that encode what we want the computer to do in some language or another (in our case assembly and C). So far you my have been taught to use various Integrated Development Environments (IDEs) that include an editor, build system and debugger within them.  In this class we will strip things down to there traditional bare essentials so you can get an idea of how things are really working and how IDE's are themselves constructed.  

# In[8]:


if 'base_url' in globals():
    from IPython.display import IFrame
    display(IFrame(base_url + 'terminals/' + EDITORTERM, 1000,600))
else:
    print("no")
    from IPython.display import IFrame
    display(IFrame(os.getenv('JUPYTERHUB_SERVICE_PREFIX') + 'terminals/EditorTerm', 1000, 600))


# - `emacs popcnt.S`
# 
# In the above terminal we will run the `emacs` editor to create and write our first assembly program. 
# To do this issue the above command.  Emacs is like many of our tools cryptic but very powerful.  In reality emacs itself contains a programming language (called elisp) that is used to write very powerful extension packages for it.  That being said we are going to stick to the basics.
# 
# At the top you will see a menu bar, in the middle you will see blank area where we will type in our file contents, and at the bottom is a status line and an area for entering emacs commands in by hand (such as convert all occurrances of X to Y).  In time you can learn about the commands and how to issue them for the moment you can use the menubar for most of the things you need to do.
# 
# To access the menu bar functions press F10.  By default emacs does not automatically save your file when you make changes.  However it does show you in the status bar if you have changes that have not been saved.  If this is the case you will see `:**` towards the left of the status bary.   You must explicity save changes by hand.  To do this you can use the menubar File-Save or you can press `control-x` followed by `control-s`  (note you can just keep the control key pressed then press x, release x, press s, release s).  Doing so will have the ASCII contents of the emacs to a file called `popcnt.S`
# 
# Remember you are running emacs in the terminal so you cannot move the cursor with your mouse you will need to navigate using the arrow keys along with page-up and down to navigate your document.  There are many hot-key sequences that you can use in time to acclerate you work.  But they too numerous to get into now but there are many tutorials and cheetsheets online to help you get going.
# 
# Now enter the following code and save it.
# 
# ```assembly_x86
#         .intel_syntax noprefix   // set assembly language format to intel
#         .text                    // linker section <directive>
#         
#         .global _start           // linker symbol type <directive>
#  _start:                         // introduce a symbolic (human readable) label for "this" address
#         popcnt rax, rbx          // ok the single intel opcode (instruction) that makes up our program
# ```
# 
# The following is a version of this code that is verbosely documented: [popcnt.S](src/popcnt.S)

# ## Building: Terminal to run our build commands

# In[12]:


if 'base_url' in globals():
    from IPython.display import IFrame
    display(IFrame(base_url + 'terminals/' + BUILDTERM, 1000,600))
else:
    print("no")
    from IPython.display import IFrame
    display(IFrame(os.getenv('JUPYTERHUB_SERVICE_PREFIX') + 'terminals/BuildTerm', 1000, 600))


# - gcc --static -g -nostartfiles -nolibc popcnt.S -o popcnt
# 
# To execute our code we must convert the "source" into a binary executable that can be loaded into memory and contains all the data and instructions (at the right locations).  To do this we must use programs that converts our assembly code into the "correct" raw binary values and assigns the those values to address.   The OS will load these values to the specified locations when we ask it to run our program.  
# 
# This process of converting human readable source code into a binary executable format is often referred to as "building".  The tools we will use are an assembler and a linker.  
# 
# The assembler's has been written to convert the human names ("memonics") of the instructions in our source files into the binary code that our CPU understands.  There is no magic!   The manufacuter of the CPU publishes a manual that defines what instructions the CPU supports.  Each instruction has a human "memonic" (eg.  `mov rax, <value>`) and the binary code that the CPU understands (eg. `mov rax, 0xdeadbeef` is `0x48,0xb8,0xef,0xbe,0xad,0xde,0x00,0x00,0x00,0x00`).  Given the manual a programmer writes the assemble to go over our source files and translates what we write into the cpu binary code.  The programmer extends the memonics with what are called "directives" such as `.intel_syntax, .text, .global, .quad, etc` that we can use to control and direct the assemble.   To fully understand all the syntax and what we can do one must look at both the manual for the CPU and for the assembler.  If all goes well and our program does not have any syntax errors then the assembler will generate a file with its output. This file is called an object file.  
# 
# We use a tool called a linker to process the object files that makes up our program to create a binary executable specific to our operating system and cpu.  It is this file that is "really" our program.  The linkers job is to prodess all our object files to create the binary with knowledge of where our OS wants things to be placed in memory (in our simple examples there is only one, later on we will have other object files from libraries of functions that we will want to use as well).  Specifically the developers of the OS provide information to the linker that tells it the rules of where instructions and data can go.  It is the linkers job to figure out what addresses each of the values that makes up our program should be given.  As such it also needs to fix up our code so that the final addresses are reflect for each of the places in our code where we reference particular symbolic names.  We will talk more about this later.  Assuming all goes well and the linker does not flag any errors then it will produce a binary executable that the OS can load and run.  One special task of the linker is to mark in the binary the address of the first instruction so that the OS can be sure to initialize the CPU correctly to start executing instructions from the right starting location -- this location is called the "entry point".   Our linker by default assumes that our code contains a symbol named `_start`.  If so the address it assigns to `_start` is what it will write into the executable as the entry point so that the OS can load and start our program correct.  If we fail to define the `_start` label the linker will produce an warning and man an assumption.  It is a bad idea to ignore warnings when programming at this level ... after all we know what assuming makes of you and me.
# 
# So in the shell above we will run a command (`gcc --static -g -nostartfiles -nolibc popcnt.S -o popcnt`) that runs both the assembler and linker for us.  We will have to pay close attention to see if there are any errors.  If so we need to go up to the editor make changes and save those changes.  Then try building again.  We repeat this untill there are no build time errors.  Remember the executable is different from the source any change we make to the program source code requires that we rerun the build process to update the binary.   Remember just because there are no build time errors does not mean that our code is "right" or free of bugs.  
# 
# Later on we will see how to use another tool called make to further simplify and automate the building process.

# ## Debugger: Terminal to run our debugger -- actually it is much more than just a debugger

# In[9]:


if 'base_url' in globals():
    from IPython.display import IFrame
    display(IFrame(base_url + 'terminals/' + DEBUGGERTERM, 1000,600))
else:
    from IPython.display import IFrame
    display(IFrame(os.getenv('JUPYTERHUB_SERVICE_PREFIX') + '/terminals/DebuggerTerm', 1000, 600))


# - `gdb -tui popcnt`
# 
# The following are gdb commands and should be entered at the gdb prompt (aka they are not shell commands)
# - `set disassembly-flavor intel`
# - `tui new-layout 210 src 2 regs 5 status 1 cmd 1`
# - `layout 210`
# -  `break _start`
# -  `run` 
# -  `print /x &_start`
# -  `x /16xb _start`
# -  `x /4i _start`
# -  `p $pc`
# -  `p {$pc, $rax, $rbx}`
# -  `p \t {$pc, $rax, $rbx}`
# -  `step` 
# 
# Continue stepping until you get to the end
# 
# `gdb` (or `gdb -tui`) which starts in a slightly more friendly mode) is a very powerful tool in the hands of a power user (that's you or soon to be).  `gdb` is complicated and cryptic but allows you to not just trace your programs execution but it allows you to explore all aspects of the hardware that your program has access too.  You can peek into the CPU and examine arbitrary memory locations.  And perhaps even more cool you can change the CPU registers and any memory location on the fly while your program is running!  It is going to take us a while to full explore all the power of gdb.   But lets get started.
# 
# If you type help you will get a list of the major commands that gdb support for the moment we are going to focus on the basics of following tasks:
# - inspecting memory : examining memory, disassembling memory
# - inspecting registers 
# - setting breakpoints
# - starting execution
# - stepping instructions
# - quiting
# 

# Ok lets write a new program that does something else
