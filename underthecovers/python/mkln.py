#!/opt/conda/bin/python3.10
import sys
import os.path
import nbformat as nbf
nb = nbf.v4.new_notebook()

nb.metadata.rise =  {
            "autolaunch": False,
            "enable_chalkboard": True,
            "footer": "UCSLS-Footer",
            "header": "Header",
            "height": "100%",
            "scroll": True,
            "start_slideshow_at": "selected",
            "transition": "none",
            "width": "100%"
        }
layouts = {
    "imageonly" : { "prefix" :  '''<img src="''',
                    "suffix" : '''" width="100%">''' }
    }

layout_default='imageonly'

if (len(sys.argv) < 2):
    print("USAGE: name [files]", file=sys.stderr)
    sys.exit(-1)
    
nbfile = sys.argv[1]
nbfile = nbfile + ".ipynb"

print("creating: " + nbfile, file=sys.stderr);

i=0

for png in sys.argv[2:]:
    print(i, ": creating cell for: " + png, file=sys.stderr);
    layout=layout_default
    if os.path.exists(png + ".layout"):
        with open(png + ".layout") as f:
            flayout = f.readline().rstrip()
            if flayout == "custom":
                layout_prefix = f.readline().rstrip()
                layout_suffix = f.readline().rstrip()
            elif layouts.has_key(flayoutL):
                layout=flayout
    layout_prefix = layouts[layout]['prefix']
    layout_suffix = layouts[layout]['suffix']

    # seperator
    nb['cells'].append(nbf.v4.new_markdown_cell(
        '''<hr>''',
        metadata={
            "slideshow": {
                "slide_type": "skip"
            },
            "tags": []
        }))
    # body
    nb['cells'].append(nbf.v4.new_markdown_cell(
        '''% BODY
''' + 
        layout_prefix +
        png +
        layout_suffix,
        metadata={
            "slideshow": {
                "slide_type": "slide"
            },
            "tags": []
        }))
    # body
    nb['cells'].append(nbf.v4.new_markdown_cell(
        '% NOTES',
        metadata={
            "slideshow": {
                "slide_type": "notes"
            },
            "tags": []
        }))
    i=i+1
    

nbf.write(nb, nbfile)

