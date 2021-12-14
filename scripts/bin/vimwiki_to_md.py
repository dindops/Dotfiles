#!/usr/bin/python3
'''
Script takes a path to directory with your .wiki files (mediawiki format) as an
argument, converts contents of each file to Markdown format, and saves it as
.md file without deleting the orignal .wiki file.
'''

import re
import sys
import glob

def substitute_bold(string):
    ''' *vimwiki* bold to **markdown** bold, straight outta stackoverflow '''
    pattern = r'^[^\S\n]*\* |\*([^*\r\n]*)\*'
    # match = re.search(r'^[^\S\n]*\* |\*([^*\r\n]*)\*', string)
    match = re.search( pattern, string)
    if match is not None:
        bold_line = re.sub(
            pattern,
            lambda x: f'**{x.group(1)}**' if x.group(1) else x.group(), 
            string,
            flags=re.M)
        return bold_line
    else: return False

def substitute_italics(string):
    ''' _vimwiki_ bold to *markdown* bold '''
    pattern = r'_([^_\r\n]*)\_'
    match = re.search( pattern, string)
    if match is not None:
        italicized_line = re.sub(
            pattern,
            lambda x: f'*{x.group(1)}*', 
            string)
        return italicized_line
    else: return False

def convert_file(list_of_lines):
    md_list = []
    for line in wiki_file_contents:
        # vimwiki headers to markdown headers
        match = re.search(r'^\s*=+', line)
        if match is not None:
            for i in range(1,6):
                match = re.search(r'^={'+str(i)+"}\s", line)
                if match is not None:
                    header = re.sub(
                        r"^={" + str(i) + r"}\s",
                        r"#"*i+" ",
                        line)
                    md_header = re.sub(
                        r"={" + str(i) + r"}",  # Hope you don't put ==> in your titles!
                        r"",
                        header)
                    md_list.append(md_header)
                else: continue
        else:
            # If not header, then anything else is allowed
            bold_line = substitute_bold(line)
            italicized_line = substitute_italics(line)
            code_block = re.search(r'{{{|}}}', line)
            if bold_line is not False:
                italicized_bold = substitute_italics(bold_line)
                if italicized_bold is not False:
                    md_list.append(italicized_bold)
                else:
                    md_list.append(bold_line)
                    continue
            elif italicized_line is not False:
                md_list.append(italicized_line)
            elif code_block is not None:
                code_line = re.sub(r'{{{|}}}', r'```', line)
                md_list.append(code_line)
            else: md_list.append(line)
    return md_list

# Main
if len(sys.argv) != 2:
    raise ValueError("Please provide path to the directory with your .wiki files.")

path = sys.argv[1]
wiki_file_list = glob.glob(r"{}*.wiki".format(path))

for file in wiki_file_list:
    core_filename = file.split(".")[0]
    path_to_md_file= core_filename + ".md"
    with open(file) as wiki_file:
        wiki_file_contents = wiki_file.readlines()
    md_file_contents = convert_file(wiki_file_contents)
    with open(path_to_md_file, "w") as md_file:
        md_file.writelines(md_file_contents)
