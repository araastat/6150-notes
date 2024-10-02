import re
import os
import pyhere
from glob import glob

regex = "```\{r (.+)\}"

def name_chunks(f):
    """
    This function takes a quarto (.qmd) file, checks for rmarkdown-style
    labels, and converts to quarto-style labels. If a quarto-style label
    exists, it preserves it (it checks the first line of the chunk metadata).
    If no label exists, it creates one based on the file name, in sequential order
    in the format "<file name>-i" where the ".*" is removed from the file name

    INPUT: A file name as a string
    OUTPUT: A list of strings that can be used in writelines()
    """
    if re.search("qmd$", f) is None:
        raise NameError("Input file must be a Quarto source file")
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
            f.writelines(txt) # Over-write file

