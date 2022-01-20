# DelphiRegExTests
Regex Testing in Delphi

  Simple test program to test finding the word "bad" in a regex string.

  Comparing multiple regex engines speeds.

  This is not A great test but it gives you an idea.
  Chaning up conditions would most likely skew results more towards one library than another.

  Reason for this was A project I had using Delphi TRegEx took 1.5 hours to run 338 million reg ex calls.
  While others took 15 minutes or less once I moved away from it.

  You will need to change up the code to fit your needs depending on what your regex string is and
  what you are trying to accomplish.

  Libraries used

  RegExBuddy  | https://www.regexbuddy.com/delphi.html  | https://www.regular-expressions.info/download/TPerlRegEx.zip
  ^-- I had to rename/edit unit name files to PCRE.pas to regexbuddypcre.pas because conflicted with another PCRE.pas

  TRegExpr  | https://github.com/andgineer/TRegExpr

  TJclRegEx  | https://github.com/project-jedi/jcl

  .NET TRegEx | http://bilsen.com/regularexpressions/index.shtml?fbclid=IwAR3BtNohPoUrRh-RXPn7WWaU2znED-gSWCQU_ezQjuAXRcZWyuIdz_IF1_c
  | http://bilsen.com/regularexpressions/RegularExpressions1.1.zip
  ^----- I had to rename/edit unit name files for PCRE.pas to dontnetPCRE.pas and RegularExpressions.pas to dontnetRegularExpressions.pas
  As these file names conflicted with others.

  TRegEx | Built into Delphi
