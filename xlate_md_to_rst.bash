#! /usr/local/bin/bash

# Description
# This script is intended to (partially) convert Markdown pages to Restructured Text pages.
# It is unable to perform a full conversion, but does capture most of the commonly used syntaxial 
# structures, which can significantly reduce the amount of time spent making manual changes.

# Supported syntax conversions
#   Convert tabs to spaces (2)
#   Convert .md extenstion to .html
#   Single-line HTML comments
#   Links embedded images
#   Hyperlink format
#   Page reference links
#   less-than and greater-than symbols
#   Line breaks (<br>, <br />)
#   Bold text formatting (*** -> **)
#   bash and json code-block designation
#   code-block termination (```)
#   Numeric bullet lists
#   In-line code-blocks (``` -> ``)
#   Templatized JSON examples (adds proper double-quoting)
#   Removed whitespace indentation on otherwise blank lines
#   Converts Section Header formats
#   For 3rd-level and lower sections, adds link reference for in-page section links

# Unsupported
#   This script does not verify or adjust indentation levels, which are quite important to RST

# TODO:
#   Add support for multi-line comments 


### Start code

# Do not automatically overwrite destination file (if present)
# Override with the -o option
overwrite=0

# Print usage and exit with the given exit status
usage() {
  echo "USAGE: $0 <markdown_file>"
  exit $1
}

# read cli parameters
while getopts "f:oh" opt; do
  case "${opt}" in
    f)
        inputfile=${OPTARG}
        ;;
    o)
        overwrite=1
        ;;
    h)
        usage 0
        ;;
    *)
        usage 0
        ;;
  esac
done
shift $((OPTIND-1))

# exit if an input file wasn't provided
if [[ -z $inputfile ]]; then
  echo "ERROR: no input file provided."
  usage 1 
fi

outputfile=$(echo $inputfile | sed 's/\.md$/.rst/')
echo "inputfile: $inputfile"
echo "outputfile: $outputfile"

# If the output file already exists, make sure it's okay to overwrite it
if [[ -e $outputfile && $overwrite == 0 ]]; then
  echo "$outputfile already exists and will be overwritten. Are you sure? (y/n)"
  read answer
  affirmative="[Yy]"
  if [[ ! $answer =~ $affirmative ]]; then
    echo "Conversion cancelled"
  else
    echo "(Use the -o argument to avoid this check in the future)"
  fi
fi


# Perform the translation
# NOTE: Several of the statements below are location-dependent. I do not recommend 
#       changing the order unless you know exactly what you are doing.
sed -E '
# convert tabs to spaces (2)
s/\t/  /g;

# convert hyperlinks from *.md to *.html
s/\.md/.html/g;

# Update single-line HTML comments
s/<!--[[:space:]]?(.+)[[:space:]]?-->/.. \1\n/;

# Update embadded image links
s/^.*!\((.+)\).*/.. image:: \1/;

# Update hyperlinks from MD format "[...](...)" to RST format "`... <...>`_"
s/\[(.+)\]\((.+)\)/`\1 <\2>`_/;

# MD uses <#link> for page references; convert them to RST references
s/ <#.*>`_/`/;

# Convert less-than and greater-than syntax to the actual charaters
s/&lt;/</g;
s/&gt;/>/g;
s/<br([[:space:]]?\/)?>//g;

# convert Markdown bold (***) to RST bold (**)
s/\*\*\*/**/g;

# convert bash and json code-blocks to RST code-blocks
s/```bash/.. code-block:: bash\n/;
s/```json/.. code-block:: json\n/;

# The end of code-blocks in RST is just a blank line with no indentation
s/^ *```$//;

# Convert numerical bullet items
s/^([[:space:]]*)[[:digit:]]+\.[[:space:]]+/\1#. /;

# Convert in-line code-blocks to RST format
s/```/``/g

# updates templatized json examples to have proper json formatting
s/: \{\{(.+)\}\}/: "{{\1}}"/;

# Get rid whitespace indentation on otherwise blank lines
s/^ +$//;

# The next several statements convert section headers
# There is no way to easily count the number of characters in the header to make the 
# header-level line match the legnth, so these have to be updated manually after
# script execution.
# For 3rd-level and below, the sections are accompanied by page references
# allowing for reference links to those sections.
s/^# (.+)/=================================\n\1\n=================================/;
s/^## (.+)/\1\n=================================/;
s/^### (.+)/\n.. _\1:\n\n-------------------------------------\n\1\n-------------------------------------/;
s/^#### (.+)/\n.. _\1:\n\n**\1\**\n-------------------------------------/;
s/^##### (.+)/\n.. _\1:\n\n^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n**\1**\n^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^/;
' $inputfile > $outputfile


