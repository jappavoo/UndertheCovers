# imports to make python code easier and constent
from IPython.core.display import HTML, Markdown, TextDisplayObject, Javascript
from IPython.display import display, IFrame, Image
import ipywidgets as widgets
from ipywidgets import interact, fixed, Layout
import os, requests, pty, re, subprocess, struct, sys, fcntl, termios, select
from notebook.notebookapp import list_running_servers
import matplotlib
import matplotlib.pyplot as plt
from matplotlib import animation
import numpy as np
import pandas as pd
import time
import array

matplotlib.rcParams['animation.html'] = 'jshtml'

# from IPython.display import Javascript

# var ipkernel = IPython.notebook.kernel;
# var stringHostName = window.location.hostname
# var ipcommand = "NB_HOST = " + "'"+stringHostName+"'";
# ipkernel.execute(ipcommand);
# """
#
# display(Javascript(js_code))

# common functions 
# Custom functions and classes to help with standard slide elements that I use
# NOTE:  I don't know python so this probably all should be rewritten by someone
#        who knows what they are doing.  

def MDBox(contents, title="", w="100%", h="100%",
          fontsize="inherit",
          color="inherit",
          bgcolor="inherit",
          overflow="auto"):
        
    md_text = title 
    md_text += '''
<div style="width:''' + w
    md_text += '''; height:''' + h
    md_text += '''; font-size:''' + fontsize
    md_text += '''; overflow: ''' + overflow
    md_text += ''';" >

'''      
    md_text += contents
    md_text += '''

</div>
'''
    return md_text

def numberLines(data):
    lines = ''
    i=0
    for l in data.splitlines():
        lines += str(i) + ": " + l + "\n"
        i=i+1
    return lines

# This probably should be a class
def FileCodeBox(file, lang, number=False, **kwargs):
    #open text file in read mode
    text_file = open(file, "r")
    #read whole file to a string
    data = text_file.read()
    
    if number:
        data = numberLines(data)
        
    #close file
    text_file.close()
    # build contents from file and language
    md_text = '''
``` ''' + lang + '''
''' + data + '''
```
'''
    # build output widget
    return MDBox(md_text, **kwargs)

def FileMDBox(file, **kwargs):
    #open text file in read mode
    text_file = open(file, "r")
    #read whole file to a string
    data = text_file.read()
    #close file
    text_file.close()
    # build contents from file and language
    # build output widget 
    return MDBox(data, **kwargs)

# Make a box that display the specified image files from the specified
# directory if no files a specified then all file in the directory are
# displayed.  A slider is used to select between the images
# Note if you want control the order you must specifiy the files
# explicitly
#  This function requires backend kernel see 
def mkImgsBox(dir,files=[]):
    if len(files)==0:
        files=os.listdir(dir);
        
    interact(lambda i,d=fixed(dir),
             f=fixed(files): 
             display(Image(dir + '/' + files[i])),
             i=widgets.IntSlider(min=0, max=(len(files)), step=1, value=0));

def files_to_imgArray(dir, files=[]):
    if len(files)==0:
        files=os.listdir(dir);
#        print(files)
        
    imgs = [];
    for f in files:
        imgs.append(plt.imread(dir + "/" + f))
    return imgs;

def html_file(file):
    text_file = open(file, "r")
    #read whole file to a string
    data = text_file.read()
    #close file
    text_file.close()
    return HTML(data)

# this embeddes a javascript animation box with specified
# images.  Added caching to a saveto file so that we can generally skip
# regenerating animation
def mkImgsAnimateBox(dir, files=[], dpi=100.0, xpixels=0, ypixels=0, force=False, saveto="save.html"):
    if not force and os.path.exists(dir + "/" + saveto):
#        print("from: " + saveto)
        return html_file(dir + "/" + saveto)

    if os.path.exists(dir + "/" + saveto):
        os.remove(dir + "/" + saveto);
        
    imgs=files_to_imgArray(dir, files)
    if (xpixels==0):
        xpixels = imgs[0].shape[0]
    if (ypixels==0):
        ypixels = imgs[0].shape[1]
    fig = plt.figure(figsize=(ypixels/dpi, xpixels/dpi), dpi=dpi)
    fig.patch.set_alpha(.0)
    im = plt.figimage(imgs[0])
    def animate(i):
        im.set_array(imgs[i])
        return(im,);
    ani=animation.FuncAnimation(fig, animate, frames=np.arange(0,len(imgs),1), fargs=None, interval=100, repeat=False)
    # next line is used to remove side affect of plot object
    plt.close()
    if saveto:
        with open(dir + "/" + saveto, "w") as f:
            print(ani.to_jshtml(), file=f)
    return ani

# for future reference incase we want to move to a plotly express version
# import plotly.express as px
# import matplotlib.pyplot as plt
# import numpy as np
# from skimage import io
# imgs = files_to_imgArray("../images/UnixL01_SHCHT1", [
#     '05SHLLChat.png',
#     '06SHLLChat.png',
#     '07SHLLChat.png',
#     '08SHLLChat.png',
#     '09SHLLChat.png',
#     '10SHLLChat.png',
#     '11SHLLChat.png',
#     '12SHLLChat.png',
#     '13SHLLChat.png',
#     '14SHLLChat.png',
#     '15SHLLChat.png',
#     '16SHLLChat.png',
#     '17SHLLChat.png',
#     '20SHLLChat.png']);

# plt.imshow(imgs[0])
# px.imshow(imgs[0])
# fig = px.imshow(np.array(imgs), animation_frame=0, labels=dict(), height=(), width=())
# fig.update_xaxes(showticklabels=False) \
#    .update_yaxes(showticklabels=False)

# binary and integer utilities
def bin2Hex(x, sep=' $\\rightarrow$ '):
    x = np.uint8(x)
    md_text="0b" + format(x,'08b') + sep + "0x" + format(x,'02x')
    display(Markdown(md_text))


# this displays a table of bytes as binary you can pass a label array if you want row labels
# for the values.  You can also override the column labels if you want.  Not sure if what
# I did for controlling centering is the best but it works ;-)
# probably want to make more of the styling like font size as parameters
#
# examples:
#   Simple use cases are to display a single value in various formats
#    displayBytes([0xff])
#    displayBytes([0xff],columns=[])
#    displayBytes([0xff],labels=["ALL ON"])
#    displayBytes([0xff],columns=[],labels=["ALL ON"])
#
#   Using to show a simple multi value  example:
#    u=np.uint8(0x55)
#    v=np.uint8(0xaa)
#    w=np.bitwise_and(u,v)
# Empty value is indicated via [""] note also force cell height to avoid
#    the empty row from shrinking 
#    displayBytes([[u],[v],[""]],labels=["u","v", "u & v"], td_height="85px")
#    displayBytes([[u],[v],[w]],labels=["u","v", "u & v"])
#
# Some tablen example
#    ASCII table
#    displayBytes(bytes=[[i] for i in range(128)], labels=["0x"+format(i,"02x")+ " (" + format(i,"03d") +") ASCII: " + repr(chr(i)) for i in range(128)])
#    Table of all 256 byte values
#    displayBytes(bytes=[[i] for i in range(256)], labels=["0x"+format(i,"02x")+ " (" + format(i,"03d") +")" for i in range(256)], center=True)
def toBits(v,dtype,count,numbits):
    try:
        if (count>8):
            x=np.unpackbits(np.array([v], dtype=">i"+str(np.uint8(count/8))).view(np.uint8))
        else:
            x=np.unpackbits(dtype(v),count=count)
        if (numbits<8):
            return x[numbits:]
        else:
            return x
    except:
#        print("oops v: ", v, dtype(v), len(v));
        return [" " for i in range(numbits)]

def bitLabels(n):
    labels=[None] * n
    n=n-1
    for i in range(n,-1,-1): 
        labels[n-i]="<em>b<sub>" + str(i) + "</sub></em>"
    return labels

# could not get latex math in column titles working consistently both in notebook and jupyterbook
# so use html to format "math"
def displayBytes(bytes=[[0x00]],
                 labels=[],
                 labelstitle="",
                 prefixvalues=[],
                 prefixcolumns=[],
                 numbits=8,
                 dtype=np.uint8,
                 columns=["[<em>b<sub>7</sub></em>",
                      "<em>b<sub>6</sub></em>", 
                      "<em>b<sub>5</sub></em>", 
                      "<em>b<sub>4</sub></em>", 
                      "<em>b<sub>3</sub></em>", 
                      "<em>b<sub>2</sub></em>", 
                      "<em>b<sub>1</sub></em>",
                      "<em>b<sub>0</sub></em>]"], 
                 center=True,
                 th_font_size="1.5vw",
                 th_border_color="#cccccc",
                 th_hover_border_color="red",
                 td_font_size="3vw",
                 td_height="",
                 border_color="#cccccc",
                 tr_hover_bgcolor="#11cccccc",
                 tr_hover_border_color="red",
                 td_hover_bgcolor="white",
                 td_hover_color="black",
                 disp=True,
				 prehtml='<div style="overflow:scroll; display: table; margin:auto auto;">',
				 posthtml='</div>'
                 ):

    # if no labels specified then send in blanks to supress
    # there is probably a better way to do this
    #if not labels:
    #    labels = ["" for i in range(len(bytes))]
    
#    print(bytes, bytes[0], np.dtype(bytes[0], dtype(bytes[0]).nbytes))
    sizeinbits = dtype(0).nbytes
    sizeinbits = sizeinbits * 8
    
    # have attempted to support specifiy the number of bits
    # but not sure it really works will need to be tested
    if numbits<sizeinbits:
        count=sizeinbits;
    else:
        count=numbits
  
    # convert each byte value into an array of bits        
    try:    
        x = np.unpackbits(np.array(bytes,dtype=dtype),count,axis=1)
        if (numbits<sizeinbits):
            x = [ i[numbits:] for i in x ]
    except:
        x = np.array([ toBits(i,dtype=dtype,count=count,numbits=numbits) for i in bytes ])

    # Add any prefix data columns to the bits 
    if prefixvalues:
        x = np.concatenate((prefixvalues,x),axis=1)
            
    if not columns:
        if not labels:
            df=pd.DataFrame(x)
        else:
            df=pd.DataFrame(x,index=labels)
    else:
        # if extra prefix column labels specified then add them
        # to the front of the other column labels
        if prefixcolumns:
            columns=np.concatenate((prefixcolumns,columns))
        if not labels:
            df=pd.DataFrame(x,columns=columns)
        else:
            df=pd.DataFrame(x,index=labels,columns=columns)
            
    # style the table
    if labelstitle:
        df = df.rename_axis(labelstitle, axis="columns")
        
    th_props = [
        ('font-size', th_font_size),
        ('text-align', 'center'),
        ('font-weight', 'bold'),
        # in this version of jupyter and pandas this seems
        # to be required but I think it is bug that is
        # address in a later version
        ('border','solid ' + th_border_color),
        ('color', 'black'),
        ('background-color', 'white')
    ]
    td_props = [
            ('border','4px solid ' + border_color),
            ('font-size', td_font_size),
#            ('color', 'white'),
            ('text-align', 'center'),
#            ('background-color', 'black'),
            ('overflow-x', 'hidden')
    ]
    if td_height:
        # print("adding td_height: ", td_height)
        td_props.append(('height', td_height))
        
    td_hover_props = [
        ('background-color', td_hover_bgcolor),
        ('color', td_hover_color)
    ]
    tr_hover_props = [
        ('background-color', tr_hover_bgcolor),
        ('border', '4px solid ' + tr_hover_border_color)
    ]
    
    th_hover_props = [
        ('border', 'solid ' + th_hover_border_color)
    ]
    
    body=df.style.set_table_styles([
            {'selector' : 'td', 'props' : td_props },
            {'selector' : 'th', 'props': th_props },
            {'selector' : 'td:hover', 'props': td_hover_props },
            {'selector' : 'tr:hover', 'props': tr_hover_props },
            {'selector' : 'th:hover', 'props': th_hover_props }
        ])
    # JA hide_index and hide_columns is deprecated
    # hack until we fix the code
    import warnings
    warnings.filterwarnings('ignore')
    # if no row labels hide them
    if (len(labels)==0):
        body.hide_index()
    # if no column labels hide them 
    if (len(columns)==0):
        body.hide_columns()
    del warnings
    # make body sticky header if present stay in place    
    body.set_sticky(axis=1)

    # center in frame
    if center:
        margins=[
            ('margin-left', 'auto'),
            ('margin-right', 'auto')
            ]
        body.set_table_styles([{'selector': '', 'props' : margins }], overwrite=False);
    body= body.to_html()
    body = prehtml + body + posthtml
    if disp:
        display(HTML(body))
    else:    
        return body   

def mkHexTbl():
    displayBytes(bytes=[i for i in range(16)], numbits=4, 
                 prefixvalues=[[format(i,"0d"),format(i,"1x")] for i in range(16)],
                 prefixcolumns=["Dec", "Hex"],
             columns=["[$b_3$", "$b_2$", "$b_1$", "$b_0$]"])

def displayStr(str, size="", align=""):
    md='<div'
    if size:
        md = md + ' style="font-size: ' + size + ';"'
    if align:
        md = md + ' align="' + align + '"'
    md = md + ">\n"
    md = md + str
    md = md + "\n</div>"
#    print(md)
    return display(Markdown(md))


def htmlFigTD(img):
    src=img.get('src');
    caption=img.get('caption')
    extratxt=img.get('extratxt')
    border=img.get('border')

    figwidth=img.get('figwidth')
    if not figwidth: figwidth='100%'
    cellwidth=img.get('cellwidth')
    if not cellwidth: cellwidth='100%'
    colspan=img.get('colspan')
    if not colspan: colspan='1'
    bgcolor=img.get('bgcolor')
    if not bgcolor: bgcolor='inherit'
    capcolor=img.get('capcolor')
    if not capcolor: capcolor='inherit'
    capbgcolor=img.get('capbgcolor')
    if not capbgcolor: capbgcolor="inherit"
    extrafont=img.get('extrafont')
    if not extrafont: extrafont="2vmin"
    extracolor=img.get('extracolor')
    if not extracolor: extracolor="#978282"
    padding=img.get('padding')
    if not padding: padding='0'
    divmargin=img.get('divmargin')
    if not divmargin: divmargin='0 0 0 0'
    figmargin=img.get('figmargin')
    if not figmargin: figmargin='0 0 0 0'
    cellmargin=img.get('cellmargin')
    if not cellmargin: cellmargin='0 0 0 0'
    
    html_text = '''        <td colspan="''' + colspan + '''" width="''' + cellwidth + '''" style="padding: 0; margin: ''' + cellmargin + '''; background-color:''' + bgcolor + ''';">
            <div style="padding: '''+ padding + '''; margin: ''' + divmargin + ''';">
              <figure style="padding: 0; margin: ''' + figmargin + '''; width:''' + figwidth + ''';'''

    if border:
        html_text += '''border: ''' + border + ''';'''
        
    html_text += '''">
                   <img src="''' + src + '''" width="100%" style="padding: 0; margin: 0;">
'''
    if  extratxt:
       html_text +=  '''                   <div align="right" style="color:''' + extracolor + '''; line-height: 0; font-size: ''' + extrafont + '''">
                    <em>
''' + extratxt + '''                    
                    </em>
                  </div> 
'''
    if caption:
        html_text += '''                  <figcaption>
                    <div style="background-color: ''' + capbgcolor + '''; margin-right:auto; margin-left:auto; text-align: center;">
                       <i style="color:''' + capcolor  + '''"> ''' + caption + '''</i>
                    </div>
                  </figcaption>
'''
    html_text +=  '''                </figure>
            </div>
        </td>
'''

    return html_text

def toImg(i):
    # if a string the convert to img
    if (type(i) == type("")):
        i={"src":i}

    if ((not type(i) == type({})) or (not 'src' in i)):
        raise ValueError('img must at have a src specified')
        
    return i

# a list of imgs
def toImgs(i):
    # already a list so don't do anyting
    if type(i) == type([]):
        return i
    
    i=[toImg(i)]
    
    return i

def htmlFigTableStart(id, align, width, margin):
    html_text = '''<table '''
    if id:
        html_text +='''id="''' + id + '''" '''

    html_text +='''align="''' + align + '''" width="''' + width + '''" cellpadding="0" cellspacing="0" border="0" style="border-collapse: collapse; margin: ''' + margin + '''">
'''
    return html_text

def htmlFigTRStart():
    html_text = '''    <tr style="padding: 0; margin: 0;"> 
'''
    return html_text

def htmlFigTREnd():
    html_text = '''    </tr>
'''
    return html_text

def htmlFigTableEnd():
    html_text = '''</table>
'''
    return html_text

def htmlFigCaption(caption, align):
    html_text = '''    <caption align="bottom" style="text-align: ''' + align + '''; padding: 0; margin: 0;" >
          <i>''' + caption + '''</i> 
    </caption>
'''
    return html_text

def htmlFig(imgs, id="", align="center", width="100%",
            margin="auto auto auto auto",
            caption="", captionalign="left"):
    imgs=toImgs(imgs)
    rows = len(imgs)
    maxcols = 1

    html_text ='''<!-- produced by: 
htmlFig("'''+ str(imgs) + '''", 
        id="'''+ id + '''", 
        align="''' + align + '''", 
        width="''' + width + '''",
        margin="'''+ margin + '''",
        caption="'''+ caption + '''", 
        captionalign="''' + captionalign + '''")
-->
'''
    html_text += htmlFigTableStart(id, align, width, margin)

#    print(html_text)

    # calculate the maximum number of columns
    # and build new list
    rows = []
    for r in imgs:
        r = toImgs(r)
        rows.append(r)
        if (len(r)>maxcols):
            maxcols = len(r);
    
    for r in rows:
        cols=len(r)
        html_text += htmlFigTRStart()
        
        for i in r:
            img=toImg(i)
            html_text += htmlFigTD(img)

        html_text += htmlFigTREnd()
        
    if caption:
        html_text += htmlFigCaption(caption, captionalign)
        
    html_text += htmlFigTableEnd()
    return html_text

# print("Common executed")

# htmlTerm : format text to look like terminal input/output
def htmlTerm(text,
             border='solid #cccccc 2px',
             bgcolor="black",
             color="white",
             fontfamily="monospace, monospace",
             fontsize="inherit"
             ):
    html_text =  '''<pre style="border: ''' + border
    html_text += '''; background-color: ''' + bgcolor
    html_text += '''; font-family: ''' + fontfamily
    html_text += '''; font-size: ''' + fontsize
    html_text += '''; color: ''' + color
    html_text += '''">'''
    
    html_text += text
    
    html_text +='''</pre>'''

    return html_text

# from: https://stackoverflow.com/questions/14693701/how-can-i-remove-the-ansi-escape-sequences-from-a-string-in-python
# 7-bit and 8-bit C1 ANSI sequences
ansi_escape_8bit = re.compile(br'''
    (?: # either 7-bit C1, two bytes, ESC Fe (omitting CSI)
        \x1B
        [@-Z\\-_]
    |   # or a single 8-bit byte Fe (omitting CSI)
        [\x80-\x9A\x9C-\x9F]
    |   # or CSI + control codes
        (?: # 7-bit CSI, ESC [ 
            \x1B\[
        |   # 8-bit CSI, 9B
            \x9B
        )
        [0-?]*  # Parameter bytes
        [ -/]*  # Intermediate bytes
        [@-~]   # Final byte
    )
''', re.VERBOSE)

TtyOpenSessions = []

def closeTtySession(session):
    global TtyOpenSessions
    subprocess.Popen.kill(session['process'])
    os.close(session['master'])
    session['open'] = False;
    TtyOpenSessions.remove(session)

def closeAllOpenTtySessions():
    for s in TtyOpenSessions:
        closeTtySession(s)
        
def openTtySession(cmd, cwd, rows, cols):
    global TtySessions
    session = dict()
    master, slave = pty.openpty()
    session['master']=master
    session['slave']=slave
    
    # not sure this is really necessary ... I am guessing that Popen takes care of this
    # ioctl(slave, I_PUSH, "ptem")
    # ioctl(slave, I_PUSH, "ldterm")
    # terminal size stuff from 
    # https://github.com/terminal-labs/cli-passthrough/blob/master/cli_passthrough/_passthrough.py  
    size = struct.pack("HHHH", rows, cols, 0, 0)
    fcntl.ioctl(master, termios.TIOCSWINSZ, size)
    
    #   nttysettings = termios.tcgetattr(master)
    #   nttysettings[3] &= ~termios.ECHO
    #   termios.tcsetattr(master, termios.TCSANOW, nttysettings)    
    p=subprocess.Popen(cmd, cwd=cwd, stdin=slave, stdout=slave, stderr=slave, start_new_session=True)
    session['process']=p
    session['output']=b''
    session['open']=True
    TtyOpenSessions.append(session)
    return session

def renderTtySessionOutput(output, height='100%', width='', outputlayout={'border': '1px solid black'}, encoding=sys.getdefaultencoding(), decodeerrors='replace', **kwargs):
    if isinstance(output, dict):
        text=output['output']
    else:
        text=output
    if height:
        outputlayout['height']=height
        outputlayout['overflow_y']='scroll'

    if width:
        outputlayout['width']=width
        outputlayout['overflow_x']='auto'
    
    text=text.decode(encoding,decodeerrors) 
    out=widgets.Output(layout=outputlayout)
    with out:
        print(text,end='')
    return out

def bashSessionSendEOF(session):
    master = session['master']
    os.write(master, b'\x04')
    
def bashSessionRawWrite(data, session,  
                        batchsize=1, 
                        interbatchdelayms=140, 
                        sendEOF=True, 
                        stoponprompt=True, 
                        ignoreoutput=False, 
                        tmout=0.5):
    # for ioctl call
    buf_ = array.array('i', [0]) 
    master = session['master']
    slave = session['slave']
    p = session['process']
   
    delaysec = interbatchdelayms / 1000
    
    if isinstance(data, str):
        data = data.encode('utf-8')
    n = len(data)  

    if batchsize <1:
        batchsize = n
        
    # print("n:", n, "batchsize: ", batchsize)
    s = 0
    e = 0
    output = b''
    
    writeset = [master]
    
    while True:
        #print("n: ", n, " s: ", s, " e: ", e)
        read_fds,write_fds,error_fds = select.select([master],writeset,[master],tmout)  
        # process errors
        if len(error_fds):
            # print("errors found")
            break;
            
        # write data aslong as there is data to write   
        if e<=n and len(write_fds): 
            s = e
            e = s + batchsize
            if (e>n):
                e = n
            # print("write: start: ", s, " end: ", e, " data: ", data[s:e])
            os.write(master,  data[s:e])
            if (e<n):
                # pause before next batch
                time.sleep(delaysec)
            else:
                # all done writing stop looking for write availability
                writeset=[]
                if sendEOF:
                    time.sleep(delaysec)
                    # print("EOF: zero lenght write")
                    #os.write(master, b'')
                    bashSessionSendEOF(session)
                e = n + 1   
                    
        # read data if there is any to read, if we find a prompt assume we are done
        if len(read_fds):
            if fcntl.ioctl(master, termios.FIONREAD, buf_, 1) == -1:
                break
            # print("num bytes available for read:", buf_[0])
            rdata = os.read(master, buf_[0])
            
            # print("read:", rdata)
            if len(rdata)>0:
                output += rdata
                rn = len(output)
                if stoponprompt and rn>=2 and output[rn-2] == 36 and output[rn-1] == 32:
                    # print("prompt received")
                    break
                    
        if len(error_fds) == 0 and len(write_fds) == 0 and len(read_fds) == 0:
            # print("time out")
            break
            
        if not p.returncode == None:
            break            
      
    if not ignoreoutput:
        #print(output)
        session['output'] = session['output'] + output
        
    # output = b'$ ' + output
    return output,session
    
#def cleanTermBytes(bytes):    
#    return  ansi_escape_8bit.sub(b'', bytes)
def bashSessionCmds(cmds, cwd=os.getcwd(), bufsize=4096, wait=True, rows=20, cols=80, session=None, close=True, ignoreoutput=False,  **kwargs):
    if not session:
        session = openTtySession(['bash', '-l', '-i'], cwd, rows, cols) 
        new_session = True
        initdone = 0
    else:
        # print("old session")
        if not session['open']:
            print("ERROR: session not open")
            return None, None
        new_session=False
        initdone = 2
        
    master = session['master']
    slave = session['slave']
    p = session['process']
    
    if not isinstance(cmds,list):
        if isinstance(cmds, str):
            cmds = cmds.encode('utf-8')
        cmds = cmds.split(b'\n')
        
    output = b''
    numcmds = len(cmds)
    # print("numcmds:", numcmds)
    i = 0
    
    if not new_session:
        #print(cmds[i] + b'\n')
        os.write(master, cmds[i] + b'\n')
        i=i+1 
        
    while True:
        read_fds,_,error_fds = select.select([master],[],[master])  
        if len(error_fds):
            kill = True;
            break;
        if len(read_fds):
            data = os.read(master, bufsize)
            # print("data: ", data)
            if len(data)>0:
                output += data
                n = len(output)
                # print("output:", output, "n:", n, "output[n-2]:", output[n-2]," output[n-1]:", output[n-1])
                if n>=2 and output[n-2] == 36 and output[n-1] == 32:
                    # print("prompt received")
                    if i == numcmds and initdone == 2:
                        break
                    else:
                        if new_session:
                            if initdone == 0:
                                #print("Initializing Session")
                                os.write(master,b' bind "set enable-bracketed-paste off"\n')
                                initdone=1
                            else:
                                #print("Session Initialized")
                                session['init'] = output
                                session['output'] = b'$ '
                                output = b''
                                initdone = 2
                                new_session = False
                                if numcmds > 0:
                                    #print(cmds[i] + b'\n')
                                    os.write(master, cmds[i] + b'\n')
                                    i=i+1
                                else:
                                    break
                        else:
                            #print(cmds[i] + b'\n')
                            os.write(master, cmds[i] + b'\n')
                            i=i+1
        if not p.returncode == None:
            kill = True
            break
        
    if close:
        closeTtySession(session)
    
    if not ignoreoutput:
        #print(output)
        session['output'] = session['output'] + output
    output = b'$ ' + output
    return output,session


def bashSessionClose(session):
    closeTtySession(session)

def bashSessionOpen(cwd=os.getenv('HOME'), **kwargs):
    _, session = bashSessionCmds(cmds=[], close=False, cwd=cwd, **kwargs)
    return session
    
def bashCmds(cmds, cwd=os.getenv('HOME'), **kwargs):
    output, session = bashSessionCmds(cmds=cmds, cwd=cwd, **kwargs)
    return renderTtySessionOutput(output, **kwargs)

class BashSession:
    # create session  
    def __init__(self, **kwargs):
        self.session = bashSessionOpen(**kwargs)
        # turn off tab completion
        self.runNoOutput("bind 'set disable-completion on'", ignoreoutput=True)
        # clear all bash history so that our history examples are clean
        self.runNoOutput(" history -c\n history -w", ignoreoutput=True)
        
    # Deleting (Calling destructor)
    def __del__(self):
        bashSessionClose(self.session)
        
    def run(self, cmds, **kwargs):
        text, self.session = bashSessionCmds(cmds, session=self.session, close=False, **kwargs)
        return renderTtySessionOutput(text, **kwargs)

    def runNoOutput(self, cmds, **kwargs):
        _, self.session = bashSessionCmds(cmds, session=self.session, close=False, **kwargs)
    
    def runAllOutput(self, cmds, **kwargs):
        self.runNoOutput(cmds, **kwargs)
        return self.output(**kwargs)
    
    def rawWrite(self, data, **kwargs):
        text, self.session = bashSessionRawWrite(data, session=self.session, **kwargs)
        return renderTtySessionOutput(text, **kwargs)
    
    def rawWriteNoOutput(self, data, **kwargs):
        _, self.session = bashSessionRawWrite(data, session=self.session, **kwargs)
    
    def rawWriteAllOutput(self, data, **kwargs):
        self.rawWriteNoOutput(data, **kwargs)
        return self.output(**kwargs)
    
    def sendEOF(self):
        bashSessionSendEOF(self.session)
            
    def output(self, **kwargs):
        return renderTtySessionOutput(self.session, **kwargs)

  
        
    def getPid(self):
        return self.session['process'].pid
    
    
# FIXME: JA Given the new Session code above this needs to be re thought out and cleaned up or removed
def runTermCmd(cmd, cwd=os.getcwd(), bufsize=4096, wait=True, tmout=1.0, rows=20, cols=80):
    master, slave = pty.openpty()

    # not sure this is really necessary ... I am guessing that Popen takes care of this
    # ioctl(slave, I_PUSH, "ptem")
    # ioctl(slave, I_PUSH, "ldterm")
    
    # terminal size stuff from 
    # https://github.com/terminal-labs/cli-passthrough/blob/master/cli_passthrough/_passthrough.py  
    size = struct.pack("HHHH", rows, cols, 0, 0)
    fcntl.ioctl(master, termios.TIOCSWINSZ, size)
    
    p=subprocess.Popen(['bash', '-l', '-i', '-c', cmd], cwd=cwd, stdin=slave, stdout=slave, stderr=slave, start_new_session=True)

    if wait:
        p.wait()
        if select.select([master,],[],[],0.0)[0]:
            output = os.read(master, bufsize)
        else:
            output = b''       
    else:
        output = b''
        while True:
            read_fds,_,error_fds = select.select([master],[],[master],tmout)  
            if len(error_fds):
                break;
            if len(read_fds):
                data = os.read(master, bufsize)
                if len(data)>0:
                    output += data
                else:
                    break
            else: 
                break;
            if not p.returncode == None:
                break
            
    subprocess.Popen.kill(p)
    os.close(master)
    return output

# 'latin-1' 
def TermShellCmd(cmd, prompt='$ ', markdown=False, pretext='', posttext='', prenl=True, stripnl=False, height='100%', width='', outputlayout={'border': '1px solid black'}, noposttext=False, raw=False, encoding=sys.getdefaultencoding(), decodeerrors='replace', **kwargs):
    output = runTermCmd(cmd, **kwargs)
    output=output.decode('utf-8',decodeerrors)
    if stripnl:
        output.strip()
        
    if prenl:
        prenl='''
'''
    else:
        prenl=''
        
    if height:
        outputlayout['height']=height
        outputlayout['overflow_y']='scroll'

    if width:
        outputlayout['width']=width
        outputlayout['overflow_x']='auto'
        
    if prompt:
        pretext += prompt + cmd #+ "\n"
        if not noposttext:
            posttext += prompt
        
    if markdown:
        md = Markdown(htmlTerm('''
''' + pretext + output + posttext ))
        if raw:
            return md
        else:
            out=widgets.Output(layout=outputlayout)
            with out:
                display(md)
            return out
    else:
        text = pretext + prenl + output + posttext
#       text = pretext + '''
#''' + output.decode('utf-8') + posttext
        if raw:
            return text
        else:
            out=widgets.Output(layout=outputlayout)
            with out:
                print(text,end='')
            return out

def gdbCmds(gdbcmds, pretext='$ gdb', quit=True, prompt='', wait=False, noposttext=True, **kwargs):
    gdbcmds = gdbcmds + '''kill
quit'''
    #print(gdbcmds)
    return TermShellCmd("echo '" + gdbcmds + "' | gdb -ex 'set trace-commands on' | sed 's/^(gdb) +/(gdb) /'", pretext=pretext, prompt=prompt, wait=wait, noposttext=noposttext, **kwargs)

def gdbFile(file, pretext='$ gdb', quit=True, prompt='', wait=False, noposttext=True, **kwargs):
    return TermShellCmd("cat " + file + " | gdb -ex 'set trace-commands on' | sed 's/^(gdb) +/(gdb) /'", pretext=pretext, prompt=prompt, wait=wait, noposttext=noposttext, **kwargs)

# Standard way to present answer for question and answer
#  put question in a cell as normal markdown
#  use the Answer function in the next cell as code, passing in markdown answer text
#  added remove-input and hide-output tags to the cell
def Answer(md):
    display(Markdown(md))

def setupExamples(name,files,basedir=os.getenv('HOME')):
    global exdir
    exdir=basedir + "/" + name
    output=runTermCmd("[[ -d " + exdir + " ]] &&  rm -rf "+ exdir + 
                 ";mkdir " + exdir + 
                 ";cp " + files + " " + exdir)