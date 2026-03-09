#!/usr/libexec/platform-python
# usage - 'python clean-anchor-ids.py'


__author__ = 'Andrew Dahms'

import os
import re
import shutil
import sys
import time


def print_header():
    print('==================================================')
    print('REST API Anchor ID Cleaner                        ')
    print('==================================================')
    print('')


def replace_anchors(match):

    return '[id="' + match.group(1).replace('/','-') + '"]'


def replace_xrefs(match):

    return '<<' + match.group(1).replace('/','-') + '>>'


def replace_xrefs_break(match):

    return '<<' + match.group(1).replace('/','-') + ','


def clean_anchors(end_data):

    clean_data = ''

    regex_anchor = '\[id="(.*?)"\]'
    regex_xrefs =  '<<(.*?)>>'
    regex_xrefs_break = '<<(.*?),'

    for line in end_data:

        if line.__contains__('[id="'):

            clean_data += re.sub(regex_anchor, replace_anchors, line)

        elif line.__contains__('<<') and line.__contains__('>>'):

            clean_data += re.sub(regex_xrefs, replace_xrefs, line)

        elif line.__contains__('<<'):

            clean_data += re.sub(regex_xrefs_break, replace_xrefs_break, line)

        else:

            clean_data += line


    return clean_data


if __name__ == '__main__':


    try:

        start_time = time.time()

        print_header()

        print('Starting directory walk in %s.\n' % os.getcwd())

        processed_count = 0

        for dir_name, sub_dir_list, file_list in os.walk('.'):

            # Skip private directories
            if dir_name.startswith('./.'):
                continue
            if dir_name.startswith('./tmp'):
                continue
            if dir_name.startswith('./build'):
                continue
            if dir_name.startswith('./.git'):
                continue

            # Print processing message
            print('Processing %s...' % dir_name[2:])

            processed_count += 1

            # Process all AsciiDoc files
            for file_name in file_list:

                if file_name == 'master.adoc':
                    continue
                if file_name == 'index.adoc':
                    continue

                if file_name.endswith('adoc'):

                    raw_data = open(os.path.abspath(dir_name) + "/" + file_name, 'r').readlines()

                    with open(os.path.abspath(dir_name) + "/" + file_name,"w") as output_file:

                        output_file.write(clean_anchors(raw_data))

        print('\nProcessed %s directories in %.2f seconds.\n' % (processed_count, time.time() - start_time))

        print('Output saved in \'converted\'.\n')

    except KeyboardInterrupt:

        sys.stderr.write('\n\nOperation cancelled by user.\n\n')
        sys.exit(1)
