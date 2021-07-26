# NOTES:  My standard preamble ipython for lecture note rise slides
#    1) Note in terminals setting TERM=linux is friendly with emacs
#    2) we customize css to improve layout of cells in the browser window
#    3) standarize how to display code blocks from a source file
# Convert this to ues %load <file.ipy>

# imports to make python code easier and constent
from IPython.core.display import display, HTML, Markdown, TextDisplayObject, Javascript
from IPython.display import IFrame
import ipywidgets as widgets
import os

# hack to get the hostname of the current page
# could not figure out another way to get the
# hostname for embedded browser windows
# to use as their url
from IPython.display import Javascript
js_code = """
var ipkernel = IPython.notebook.kernel;
var stringHostName = window.location.hostname
var ipcommand = "NB_HOST = " + "'"+stringHostName+"'";
ipkernel.execute(ipcommand);
"""

display(Javascript(js_code))

# cusomization of ccs to make slides look better 
display(HTML(
    '<style>'
        '#notebook { padding-top:0px !important; } ' 
        '.container { width:100% !important; } '
        '.CodeMirror { width:100% !important;}'
        '.end_space { min-height:0px !important; } '
        '.prompt { display:none }'
        '.terminal-app #terminado-container { width:100%; }'
        'div.mywarn { background-color: #fcf2f2;border-color: #dFb5b4; border-left: 5px solid #dfb5b4; padding: 0.5em;}'
    '</style>'
))

# Custom function and classes to help with standard slide elements that I use
# NOTE:  I don't know python so this probably all should be rewritten by someone
#        who knows what they are doing.  

# This probably should be a class
def MkCodeBox(file, lang, html_title, w, h):
    #open text file in read mode
    text_file = open(file, "r")
    #read whole file to a string
    data = text_file.read()
    #close file
    text_file.close()
    # build contents from file and language
    md_text = '''
``` ''' + lang + '''
''' + data + '''
```
'''
    # build output widget 
    wout = widgets.Output(layout={'overflow': 'scroll', 'width': w, 'height': h})
    with wout:
        display(Markdown(md_text))
    display(HTML(html_title))
    return wout

# show Terminal where TERMNAME is one of the terminals we created below
def showTerm(TERMNAME, name, w, h):
    display(HTML('<b>TERMINAL Window for ' + name + '</b>'))
    return IFrame('/terminals/' + TERMNAME, w,h)
    
def showET():
    return showTerm(EDITORTERM, "Editor", 1400,600)

def showBT():
    return showTerm(BUILDTERM, "Build Commands", 1400,200)

def showDT():
    return showTerm(DEBUGGERTERM, "Debugger", 1400,800)

# create standard terminals for organizing editor, build and debugger
import requests
from notebook.notebookapp import list_running_servers
# get server info so that we can make api calls 
servers=list(list_running_servers())

info=next(list_running_servers())
base_url=info['url']
api_url=base_url + 'api/terminals'
api_token=info['token']

# on the operate-firrst jupyterhub I found that api_token is not set but
# the JPY_API_TOKEN environment variable or JUPYTERHUB_API_TOKEN
# should exist
if not api_token:
    api_token = os.environ.get('JPY_API_TOKEN')

if not api_token:
    api_token = os.environ.get('JUPYTERHUB_API_TOKEN')
    
if not api_token:
    print("ERROR: unable to deterimine API token");


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

#print("Preamble executed")
