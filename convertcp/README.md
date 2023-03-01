# <img src="https://raw.githubusercontent.com/metaworx/au-packages/master/convertcp/convertcp.png" width="48" height="48"/> [CONVERTCP](https://chocolatey.org/packages/convertcp)

CONVERTCP is a command line codepage converter.

## Features

- Converts stream or file character encodings.
- Fully supports charsets such as single-byte code pages, UTF-8, UTF-16 LE/BE, UTF-32 LE/BE, and EBCDIC.
- Is designed to process big files also.

## Notes

- It shall work on Windows XP onwards (tested on XP, Windows 7, Windows 8.1, Windows 10, and Windows 11).
- The support is restricted by
  1. the shared characters of both used code pages. If a read character has no equivalent the implementations of the used API functions decide if they
     * either convert to the approximated ASCII character (e.g. Š to S), or
     * replace it with a default character (question mark or Unicode Replacement Character)
  2. the maximum number of bytes used to represent a character. The table outputted using option /l indicates in the second column whether or not a code page can be used by CONVERTCP for input streams greater than 511MB (while all listed code pages can be used for output streams independent of their size).
- It's a free and open source tool.
