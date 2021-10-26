# Assumes common.py
# NOTES:  My standard preamble ipython for lecture note rise slides
#    1) Note in terminals setting TERM=linux is friendly with emacs
#    2) we customize css to improve layout of cells in the browser window
#    3) standarize how to display code blocks from a source file
#
servers=list(list_running_servers())
if os.environ.get('JUPYTER_ENABLE_LAB') == 'yes' or len(servers) == 0 or 'UC_SKIPTERMS' in globals():
    # skip using embedded terminals in jupyterlab
    def mkTerm():
        pass
    def showTerm(TERMNAME, title, w, h):
        return Markdown("<b>Use Terminal</b>")
    def showET(title="TERMINAL Window for Editor"):
        return Markdown("<b>Edit</b>")
    def showBT(title="TERMINAL Window for Build Commands"):
        return Markdown("<b>Build</b>")
    def showDT(title="TERMINAL Window for Debugger"):
            return Markdown("<b>Debug</b>")
else:
    ### BOOTSTRAPPING CODE
    # get server info so that we can make api calls when runing direclty on a
    # jupyter notebook server

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

    # from IPython.display import Javascript

    # var ipkernel = IPython.notebook.kernel;
    # var stringHostName = window.location.hostname
    # var ipcommand = "NB_HOST = " + "'"+stringHostName+"'";
    # ipkernel.execute(ipcommand);
    # """
    #
    # display(Javascript(js_code))

    # CSS customization for RISE has been moved
    # to <notebook_name>.css which RISE attempts to load
    # see rise examples in the rise repo
    # cusomization of ccs to make slides look better 
    # display(HTML(
    #     '<style>'
    #         '#notebook { padding-top:0px !important; } ' 
    #         '.container { width:100% !important; } '
    #         '.CodeMirror { width:100% !important;}'
    #         '.end_space { min-height:0px !important; } '
    #         '.prompt { display:none }'
    #         '.terminal-app #terminado-container { width:100%; }'
    #         'div.mywarn { background-color: #fcf2f2;border-color: #dFb5b4; border-left: 5px solid #dfb5b4; padding: 0.5em;}'
    #         'button { background-color: #cccccc00; }'
    #     '</style>'
    # ))

    # show Terminal where TERMNAME is one of the terminals we created below
    def showTerm(TERMNAME, title, w, h):
        if title:
            display(HTML('<b>' + title + '</b>'))
        return IFrame(base_url + 'terminals/' + TERMNAME, w,h)

    def showET(title="TERMINAL Window for Editor"):
        return showTerm(EDITORTERM, title, "100%", 600)

    def showBT(title="TERMINAL Window for Build Commands"):
        return showTerm(BUILDTERM, title, "100%", 200)

    def showDT(title="TERMINAL Window for Debugger"):
        return showTerm(DEBUGGERTERM, title, "100%", 700)

    print("Preamble executed")

# Added this back in ... jupyter lab classic notebook does note seem to pick up RISE css
# removed again now that I know we can start in classic but still access lab

# display(HTML(
#     '''
# <style>
# body.rise-enabled div.inner_cell>div.text_cell_rende
# r.rendered_html {
#     font-size: 50%;
# }


# body.rise-enabled div.inner_cell>div.input_area {
#     font-size: inherit;
# }

# /* output cells that generate markddown... not sure 
# why but 80% seems to match 
#   the rest of the areas but it seems to work */
# body.rise-enabled div.output_subarea.output_markdown
# .rendered_html {
#     font-size: 80%;
# }


# /* Ingnoring these 
# body.rise-enabled div.output_subarea.output_text.out
# put_result {
#     font-size: 10%;
# }
# body.rise-enabled div.output_subarea.output_text.out
# put_stream.output_stdout {
#     font-size: 10%;
# }

# body.rise-enabled div.output_subarea.output_html.ren
# dered_html.output_result {
#     font-size: 10%;
# }

# body.rise-enabled td {
#     font-size: 10%;
# }

# body.rise-enabled th {
#     font-size: 10%;
# }
# */

# /* ---------- code blocks inside markdown
#    i.e. within ``` lines, or 4-space indented
#  */
# div.inner_cell>div.text_cell_render.rendered_html>pr
# e {
#     margin: 0px;
# }

# div.inner_cell>div.text_cell_render.rendered_html>pr
# e>code {
#     font-size: 100%;
# }

# #notebook { padding-top:0px !important; }  

# .container { width:100% !important; } 

# .CodeMirror { width:100% !important;}

# .end_space { min-height:0px !important; } 

# .prompt { display:none }

# .terminal-app #terminado-container { width:100%; }

# div.mywarn { background-color: #fcf2f2;border-color:
#  #dFb5b4; border-left: 5px solid #dfb5b4; padding: 0
# .5em;}

# /* JA Hacks to get annimation buttons looking better
#  with RISE.  
#    This is very crude and overkill */
# /* button { background-color: #cccccc00; font-size: 
# 30% } */
# /* .animation { background-color: white } */
# .anim-controls { color: blue; background-color: whit
# e; font-size: 40% } 

# /* not very useful, but an OBVIOUS setting that you 
# cannot miss */
# div.cell.code_cell.rendered {
#     border-radius: 0px 0px 0px 0px;
# }

# div.input_area {
#     border-radius: 0px 0px 0px 0px;
# }
# </style>
# '''
#     ))
