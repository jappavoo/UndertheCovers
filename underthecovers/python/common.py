# imports to make python code easier and constent
from IPython.core.display import display, HTML, Markdown, TextDisplayObject, Javascript
from IPython.display import IFrame, Image
import ipywidgets as widgets
from ipywidgets import interact, fixed, Layout
import os, requests, pty, re
from notebook.notebookapp import list_running_servers
import matplotlib
import matplotlib.pyplot as plt
from matplotlib import animation
import numpy as np
import pandas as pd

matplotlib.rcParams['animation.html'] = 'jshtml'

#from IPython.display import Javascript

#var ipkernel = IPython.notebook.kernel;
#var stringHostName = window.location.hostname
#var ipcommand = "NB_HOST = " + "'"+stringHostName+"'";
#ipkernel.execute(ipcommand);
#"""
#
#display(Javascript(js_code))

# common functions 
# Custom functions and classes to help with standard slide elements that I use
# NOTE:  I don't know python so this probably all should be rewritten by someone
#        who knows what they are doing.  

# generic display markdown contents in a box
def MkMarkDownBox(contents, title, w, h):
#    wout = widgets.Output(layout=Layout(overflow='scroll',
#                                        width=w,
#                                        min_width=w,
#                                        max_width=w,
#                                        min_height=h,
#                                        height=h,
#                                        max_height=h))
#    with wout:
#        display(Markdown(contents))
    display(Markdown(title))
    return Markdown(contents)

# This probably should be a class
def FileCodeBox(file, lang, title, w, h):
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
    return MkMarkDownBox(md_text, title, w, h)
    
def FileMarkDownBox(file, title, w, h):
    #open text file in read mode
    text_file = open(file, "r")
    #read whole file to a string
    data = text_file.read()
    #close file
    text_file.close()
    # build contents from file and language
    # build output widget 
    return MkMarkDownBox(data, title, w, h)

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

def files_to_imgArray(dir, files):
    n=len(files);
    imgs = [];
    for f in files:
        imgs.append(plt.imread(dir + "/" + f))
    return imgs;

# this embeddes a javascript animation box with specified
# images
def mkImgsAnimateBox(dir, files ,dpi=100.0,xpixels=0,ypixels=0):
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

#plt.imshow(imgs[0])
#px.imshow(imgs[0])
#fig = px.imshow(np.array(imgs), animation_frame=0, labels=dict(), height=(), width=())
#fig.update_xaxes(showticklabels=False) \
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
        x=np.unpackbits(dtype(v),count=count)
        if (numbits<8):
            return x[numbits:]
        else:
            return x
    except:
#        print("oops v: ", v, type(v), len(v));
        return [" " for i in range(numbits)]
        
def displayBytes(bytes=[[0x00]],
                 labels=[],
                 labelstitle="",
                 prefixvalues=[],
                 prefixcolumns=[],
                 numbits=8,
                 dtype=np.uint8,
                 columns=["[$b_7$","$b_6$", "$b_5$", "$b_4$", "$b_3$", "$b_2$", "$b_1$","$b_0$]"],
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
                 td_hover_color="black"
                 ):

    # if no labels specified then send in blanks to supress
    # there is probably a better way to do this
    #if not labels:
    #    labels = ["" for i in range(len(bytes))]

    sizeinbits = (dtype(0).nbytes)*8

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
    
    # if no row labels hide them
    if (len(labels)==0):
        body.hide_index()
    # if no column labels hide them 
    if (len(columns)==0):
        body.hide_columns()
        
    # make body sticky header if present stay in place    
    body.set_sticky(axis=1)

    # center in frame
    if center:
        margins=[
            ('margin-left', 'auto'),
            ('margin-right', 'auto')
            ]
        body.set_table_styles([{'selector': '', 'props' : margins }], overwrite=False);
    body=body.to_html()
    display(HTML(body))   

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

def cleanTermBytes(bytes):    
    return  ansi_escape_8bit.sub(b'', bytes)

def runTermCmd(cmd, bufsize=4096, wait=True):
    master, slave = pty.openpty()
    import subprocess
    p=subprocess.Popen(['bash', '-l', '-i', '-c', cmd], stdin=slave, stdout=slave, stderr=slave, start_new_session=True)

    if wait:
        p.wait()
        
    output = os.read(master, bufsize)
    
    subprocess.Popen.kill(p)
    os.close(master)
    return output

def TermShellCmd(cmd, prompt='$ ', markdown=True, bufsize=4096, wait=True):
    output = runTermCmd(cmd, bufsize, wait)
    
    if markdown:
        display(Markdown(htmlTerm('''
''' + prompt + cmd + '''
''' + cleanTermBytes(output).decode('utf-8') + prompt )))
    else:
        print(prompt + cmd + '''
''' + output.decode('utf-8') + prompt ) 
        

