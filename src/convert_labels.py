import re
import os
import pyhere
from glob import glob

regex = "```\{r (.+)\}"

def name_chunks(f):
    with open(f, 'r') as file:
        txt = file.readlines()
    chunk_prefix = os.path.basename(f).replace('.qmd','')
    indx = 0
    for i, l in enumerate(txt):
        if re.search('```\{r', l) is not None: # Start of a chunk
            if re.search(regex, l) is not None: # rmd label
                lbl = re.search(regex, l).group(1)
            else: # no rmd label
                indx +=1
                lbl = chunk_prefix + '-' + str(indx)
            if re.search('label', txt[i+1]) is None: # Check that label doesn't exist
                txt[i] = "```{r}\n#| label: "+ lbl + "\n"
            else:
                txt[i] = "```{r}\n"
    return txt 

if __name__ =="__main__":
    qfiles = glob(str(pyhere.here('chapters/*.qmd')))
    for q in qfiles:
        txt = name_chunks(q)
        with open(q, 'w') as f:
            f.writelines(txt)

