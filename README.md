# xlate_md_to_rst.bash

## Description
This script performas a partial conversion of a Markdown file to ReStructured Text file. It is not capable of performing a full conversion and some manual editing of the resulting .rst file is still necessary; howver, it does capture the majority of comment syntaxial elements (see list below). The intent is to reduce the amount of time spent performing the conversion. Depending on the complexity of the page and the number of captured elements, it can easily reduce the time spent on the conversion from 50-75%. 

*IMPORTANT*: This script was written for compatibility with the MacOS version of sed. The version of sed on Linux systems may throw an error. If this occurs please submit an issue in Github.

### Supported Syntax Elements
*   Convert tabs to spaces (2)
*   Convert .md extenstion to .html
*   Single-line HTML comments
*   Links embedded images
*   Hyperlink format
*   Page reference links
*   less-than and greater-than symbols
*   Line breaks (\<br\>, \<br /\>)
*   Bold text formatting (\*\*\* -> \*\*)
*   bash and json code-block designation
*   code-block termination (```)
*   Numeric bullet lists
*   In-line code-blocks (``` -> ``)
*   Templatized JSON examples (adds proper double-quoting)
*   Removed whitespace indentation on otherwise blank lines
*   Converts Section Header formats
*   For 3rd-level and lower sections, adds link reference for in-page section links


### References
* [Markdown](https://www.markdownguide.org/)
* [Markdown Extended Syntax](https://www.markdownguide.org/extended-syntax/)
* [reStructuredText](https://peps.python.org/pep-0287/)
* [reStructuredText Markup](https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html)

