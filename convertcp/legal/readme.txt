~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1) The files included in this software package are published under MIT license:

Copyright (c) 2016-2022 Steffen Illhardt

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
2) Usage of the convertcp.exe command line utility:

CONVERTCP v.8.4. Converts a stream of characters to another code page.

Usage:
CONVERTCP CP_In CP_Out [/i "infile.txt"] [/o "outfile.txt"] [/v] [/f] [/b|/a]
CONVERTCP /?|/l

CP_In     Code Page Identifier of the input stream
          A solitary question mark passed as CP_In causes CONVERTCP
           to try guessing the encoding.
           A preceding question mark to the identifier makes CP_In
           a preferred Code Page. If reasonable, CONVERTCP will use
           this preference rather than the guessed encoding.
           NOTE Guessing is error-prone. Don't rely on CONVERTCP
           being able to determine the correct encoding.
CP_Out    Code Page Identifier of the output stream
 To get a list of supported Code Page Identifiers use option /l
 Alternatively you can use 0 for the ANSI Code Page
  and 1 for the OEM Code Page of your system default settings.
 Instead of the Code Page Identifier you may pass the related
  MIME type, or the name of a custom *.sbcs file.
 CP_Out isn't used if the text is printed to a console or terminal
  window. It defaults to UTF-16 to get advanced character support.

/i        Introduces the source file
/o        Introduces the destination file
           (the content of an existing file will be truncated
           unless option /a was passed)
           Pass a solitary "-" (without option /a) to overwrite the
           original file specified along option /i.
 Redirections to or from CONVERTCP can be used instead of /i and /o

/v        Verify that all characters have been converted without
           using the replacement character or approximated ASCII
           characters
           Only in this case CONVERTCP returns a zero value
           NOTE Option /v is supported on Windows Vista and later
/f        Flush the stream buffer before CONVERTCP terminates
           in case the new file shall be accessed immediately
/b        Add the Byte Order Mark to the output stream
           (will be ignored if CP_Out was not one of
           65001, 1200, 1201, 12000, 12001, or 54936)
/a        Append the output stream to the destination file
           (always use the same CP_Out)
 Do not combine options /b and /a

/?        Display this help message
/l        Display a list of supported Code Page Identifiers
           installed on this computer

infile    Path of a text file whose content shall be converted
outfile   Path of a text file where the converted stream
           shall be written
 Input file and output file must not be the same, unless a minus
  sign is specified along with option /o.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
3) Additional information:

To get a list of Code Page Identifiers along with a short description either use option /l or see
https://msdn.microsoft.com/en-us/library/dd317756.aspx
You can also pass MIME types rather than Code Page Identifiers (e.g. UTF-8 instead of 65001).
Custom single-byte charsets are supported, too. For more information see
https://sourceforge.net/projects/convertcp/files/custom%20charsets/


This command line utility is a codepage converter. It fully supports charsets such as single-byte code pages, UTF-8, UTF-16 LE/BE, UTF-32 LE/BE, and EBCDIC. It's designed to process big files also. It shall work on Windows XP onwards (tested on XP, Windows 7, Windows 8.1, Windows 10, and Windows 11). It's a free and open source tool.
The support is restricted
a) by the shared characters of both used code pages. If a read character has no equivalent the implementations of the used API functions decide if they
- either convert to the approximated ASCII character (e.g. Š to S)
- or replace it with a default character (usually a question mark)
b) by the maximum number of bytes used to represent a character. The table outputted using option /l indicates in the second column whether or not a code page can be used by CONVERTCP for input streams greater than 511MB (while all listed code pages can be used for output streams independent of their size).

The utility was written in C/WinAPI. Besides of the exe files (which are 32 bit and 64 bit MinGW/GCC release builds) the source code is included in this package. The program flow chart is for those who try to understand how the program works (even though it's simplified and incomplete).

CONVERTCP doesn't need any installation but if you frequently use it for your daily work you may copy it to the Windows command utilities:
  On 32 bit Windows
    - Copy the 32 bit convertcp.exe out of the x86 subfolder to the System32 directory (usually C:\Windows\System32).
  On 64 bit Windows
    - Copy the 64 bit convertcp.exe out of the x64 subfolder to the System32 directory (usually C:\Windows\System32).
    - Copy the 32 bit convertcp.exe out of the x86 subfolder to the SysWOW64 directory (usually C:\Windows\SysWOW64).
This way you can use CONVERTCP without having the executable in the same folder along with your script.

About Byte Order Marks (BOMs):
CONVERTCP provides the opportunity to add a BOM to UTF-8, UTF-16 and UTF-32 encoded output streams. A BOM has to be always the first byte sequence in a file. The reading program may use it to recognize unicode encoded file contents. See https://en.wikipedia.org/wiki/Byte_order_mark. Some rules of thumb when to add or omit BOMs:
  - Add the BOM to text files that are intended to be read in text editors on Windows.
  - Omit the BOM in markup text (such as HTML or XML) where the encoding is specified in the markup or where it defaults to be recognized as UTF-8.
  - Omit the BOM for files that are intended to be shared with other operating systems like Unix or Linux.
  - Never use a BOM for text that you append to an existing file.

Feedback is always welcome. (http://www.dostips.com/forum/viewtopic.php?f=3&t=7570)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
4) Examples:

* Convert the output of a command and save it in a text file.
(The output of FINDSTR /? will be converted from the default OEM code page to UTF-16 LE with BOM prepended. The converted stream will be saved in "commands.txt".)
Command line:
findstr /? | convertcp 1 1200 /b /o "commands.txt"

* Convert the content of a text file and save it to another text file.
(The content of "commands.txt" will be converted from UTF-16 LE to the default ANSI code page and saved in "commands2.txt")
Command line:
convertcp 1200 0 /i "commands.txt" /o "commands2.txt"

* Convert the content of a text file from guessed encoding and save it to another text file.
(The encoding of "commands.txt" is guessed, its content converted to UTF-8 and saved in "commands3.txt")  
Command line:
convertcp ? 65001 /i "commands.txt" /o "commands3.txt"

* Convert the content of a text file and output it to the console window.
(The content of "commands2.txt" will be converted from the default ANSI code page to the default OEM code page and displayed.)
Command line:
convertcp 0 1 /i "commands2.txt"

* Append to an existing file.
(The output of FIND /? will be converted from the default OEM code page to UTF-16 LE. The converted stream will be appended to "commands.txt".)
Command line:
find /? | convertcp 1 1200 /a /o "commands.txt"

* Create a file with a Byte Order Mark only.
(NUL is redirected to CONVERTCP. Thus, the input stream is empty. The input code page ID is meaningless. Because the output code page ID is for UTF-8 and option /b was passed only the UTF-8 BOM will be written to the file. This might be useful if you want to append text to the file in multiple steps afterwards.)
Command line:
<nul convertcp 0 65001 /b /o "bom.txt"

* List the installed code pages.
(Process the outputted list of CONVERTCP /L in a FOR /F loop in order to write the values comma-separated)
Command line:
for /f "skip=3 tokens=1,3,4*" %%i in ('convertcp /l') do echo "%%i","%%j","%%l"

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
5) Release notes:

2022/05/29 - v8.4.0/1.0 fix broken identification of names
2021/10/18 - v8.3.0/1.0 improve performance of UTF-8 identification, shrink the binary size
2021/07/25 - v8.2.0/1.0 add support for overwriting of the original file
2021/07/02 - v8.1.0/1.0 bugfix for UTF-7 detection, print meaningful error messages, minor optimizations
2021/06/23 - v8.0.0/1.0 support guessing the charset of the incoming stream
2020/08/18 - v7.5.0/1.0 make the output default to UTF-16 if printed to a text device (console or terminal) to get advanced character support
2020/01/18 - v7.4.0/1.0 improve speed for UTF-8 <--> UTF-16 conversion of ASCII characters
2019/12/28 - v7.3.0/1.0 revision of UTF-8 validation
2019/12/26 - v7.2.0/1.0 override incorrect conversion from and to UTF-8 on XP, bugfix for broken ID 0 for the default ANSI code page
2019/12/24 - v7.1.0/1.0 supposed fix for broken option /l on XP
2019/12/23 - v7.0.0/1.0 add support for custom single-byte charsets
2019/08/18 - v6.4.0/1.0 improvement for memory management, BOM processing for GB-18030 enabled
2019/06/10 - v6.3.0/1.0 Virtual Terminal processing for Windows 10 enabled
2019/04/23 - v6.2.0/1.0 bugfix for faulty parsing of partially quoted paths
2019/03/19 - v6.1.0/1.0 bugfix for BOM processing
2019/03/17 - v6.0.0/1.0 added option /v to verify the conversion
2019/03/04 - v5.2.0/1.0 bugfix for redirected UTF-8 streams
2018/06/14 - v5.1.0/1.0 file size optimization
2018/05/12 - v5.0.0/1.0 added support for MIME names
2018/04/29 - v4.3.0/1.0 bugfix for memory leak of conversion to UTF-32 without threading
2018/04/27 - v4.2.0/1.0 removed option /n, code pages are assessed for an automatic decision if threading will be applied
2018/04/26 - v4.1.0/1.0 bugfix for wrong maximum of options
2018/04/26 - v4.0.0/1.0 added option /n for "no threading" to overcome the 1 MB limit of certain code pages
2018/04/20 - v3.1.0/1.0 thread-waiting moved
2018/04/20 - v3.0.0/1.0 added option /f to force the flushing of the file buffer before CONVERTCP terminates
2018/04/18 - v2.2.0/1.0 bugfix for unexpected output
2018/04/11 - v2.1.0/1.0 bugfix for unexpected output caused by still buffered stream content (finally fixed in v2.2)
2018/02/01 - v2.0.0/1.0 UTF-32 LE/BE support added, bugfix for reading UTF-16 BE
2017/12/30 - v1.5.0/1.0 bugfix for file names with leading dash
2017/05/27 - v1.4.4.0/1 added option /l to print a list of installed code pages
2017/02/02 - v1.4.3.0/1 added option /a for appending to an existing file
2017/01/29 - v1.4.2.0/1 reduced the size of the binary files by half (kudos to carlos)
2017/01/23 - v1.4.1.0/1 minor performance improvement
2016/12/28 - v1.4.0.0/1 UTF-16 BE support added, options /i and /o added
2016/12/09 - v1.3.2.0/1 fixed bug in conversion from UTF-8
2016/12/08 - v1.3.1.0/1 ambiguous code fixed, minor optimizations, source code tidied
2016/12/05 - v1.3.0.0/1 UTF-16 LE support added
2016/12/03 - v1.2.0.0/1 UTF-8 support added, fixed misleading error message if the input stream has a size of exact multiples of 4 MB
2016/11/28 - v1.1.4.0/1 minor optimizations, source code tidied, 64bit utility added
2016/11/25 - v1.1.3.0 fixed possible deadlock caused by unsignaled threads
2016/11/24 - v1.1.2.0 fixed possible memory leak if reallocations fail
2016/11/24 - v1.1.1.0 moved to C, multithreaded conversion added
unpublished - first versions using C++ vector containers, without multithreading
