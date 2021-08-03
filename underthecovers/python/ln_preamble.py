# NOTES:  My standard preamble ipython for lecture note rise slides
#    1) Note in terminals setting TERM=linux is friendly with emacs
#    2) we customize css to improve layout of cells in the browser window
#    3) standarize how to display code blocks from a source file
# Convert this to ues %load <file.ipy>

# imports to make python code easier and constent
from IPython.core.display import display, HTML, Markdown, TextDisplayObject, Javascript
from IPython.display import IFrame, Image
import ipywidgets as widgets
from ipywidgets import interact, fixed
import os, requests
from notebook.notebookapp import list_running_servers


### BOOTSTRAPPING CODE
# get server info so that we can make api calls when runing direclty on a
# jupyter notebook server
servers=list(list_running_servers())
info=next(list_running_servers())
# localhost_url used for explicit calls to my server
localhost_url=info['url']
api_url=localhost_url + 'api/'
api_term_url=api_url + 'terminals'
api_token=info['token']
# urls used as relative to my server 
base_url=info['base_url']

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
r=requests.get(url=api_term_url, headers={'Authorization': 'token ' + api_token})
TERMINALS=r.json()

def mkTerm():
    # create a terminal for our editor
    r=requests.post(url=api_term_url, headers={'Authorization': 'token ' + api_token})
    c=r.json()
    return c['name']

# assumes that we will use the first three terminals four our use
# create standard terminals for organizing editor, build and debugger
try:
    EDITORTERM=TERMINALS[0]['name']
except IndexError:
    EDITORTERM=mkTerm()

try:
    BUILDTERM=TERMINALS[1]['name']
except IndexError:   
    BUILDTERM=mkTerm()

try:
    DEBUGGERTERM=TERMINALS[2]['name']
except IndexError:   
    DEBUGGERTERM=mkTerm()


# FYI:  Don't need this yet so I am commenting out ...
#       It does work though
# hack to get the hostname of the current page
# could not figure out another way to get the
# hostname for embedded browser windows
# to use as their url

#from IPython.display import Javascript
#js_code = """
#var ipkernel = IPython.notebook.kernel;
#var stringHostName = window.location.hostname
#var ipcommand = "NB_HOST = " + "'"+stringHostName+"'";
#ipkernel.execute(ipcommand);
#"""
#
#display(Javascript(js_code))

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

# Custom functions and classes to help with standard slide elements that I use
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

# Make a box that display the specified image files from the specified
# directory if no files a specified then all file in the directory are
# displayed.  A slider is used to select between the images
# Note if you want control the order you must specifiy the files
# explicitly
def mkImgsBox(dir,files=[]):
    if len(files)==0:
        files=os.listdir(dir);
    interact(lambda i,d=fixed(dir),
             f=fixed(files): 
             display(Image(dir + '/' + files[i])),
             i=widgets.IntSlider(min=0, max=(len(files)-1), step=1, value=0));

# show Terminal where TERMNAME is one of the terminals we created below
def showTerm(TERMNAME, name, w, h):
    if name:
        display(HTML('<b>TERMINAL Window for ' + name + '</b>'))
    return IFrame(base_url + 'terminals/' + TERMNAME, w,h)
    
def showET():
    return showTerm(EDITORTERM, "Editor", 1400,600)

def showBT():
    return showTerm(BUILDTERM, "Build Commands", 1400,200)

def showDT():
    return showTerm(DEBUGGERTERM, "Debugger", 1400,800)


#print("Preamble executed")
