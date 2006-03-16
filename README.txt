DCI version 1.1a1

   AN RPN SCIENTIFIC CALCULATOR FOR CONSOLE USERS;

   An Improved /usr/bin/dc for Engineers;

   six hundred one.

copyright 2006  pete gamache  gamache at gmail dot com


LICENSE

DCI is offered under the Perl Artistic License, which is available at
http://www.perl.com/pub/a/language/misc/Artistic.html and at the end of 
the DCI perl source code.

DCI is offered free of charge at http://dci.sf.net and http://ftso.net/dci/.


REQUIREMENTS

A working Perl installation.


INSTALLING DCI

Installing DCI is as easy as copying the 'dci' file somewhere useful, 
depending on your system.  In Macintosh, Unix, and Windows+Cygwin 
environments, the directory "/usr/bin" will work, though you may prefer 
"/usr/local/bin" or another to suit your (or your sysadmin's) preferences.

You *do not* need to install DCI to launch and use it.  See below.


STARTING DCI

If you've installed DCI as described above, you need only type "dci" 
at a shell prompt.

If you have not installed dci system-wide, type:

   cd dci-1.1a1
   perl dci
   
at a shell (Macintosh/Unix/Cygwin) or command (Windows) prompt.


USING DCI

DCI is modeled after the function and feel of two calculators: /usr/bin/dc, 
and the HP 32S-II handheld.  As such, it operates as a stack-based RPN 
calculator.  DCI extends the familiar dc interface by adding common 
scientific commands supporting logarithms, exponentials, trigonometry and
complex values.

Syntax:

In a nutshell, an RPN (Reverse Polish Notation) calculator keeps an ordered 
list of numbers called a "stack", and operates by taking numbers from and
adding numbers to the top of the stack (the first number in the list).  For 
instance, a multiplication would take ("pop") two values from the top of the 
stack, multiply them, and leave ("push") the result on the top of the stack.
RPN eliminates the need for parentheses in calculator operation.

DCI commands can be separated by space, or interpreted one-after-another
without whitespace, so long as ambiguous commands are not created.  A number
counts as a command which pushes the given value onto the stack.  Strings 
work the same way, and must be quoted at both ends with a single- or double-
quote (' or ").

For example, to divide 22 by 7 and then print the result, type:

  22 7 / p                   # (or "22 7/p")

You will see:

  3.14286

To calculate the square root of (25 + 81) without printing the result, you 
could type:

  25 81 + v                  # v is radical

or

  5 d * 9 d * + v            # d "duplicates" the top value on the stack

or

  5 sq 9 sq + v              # equivalent to above

To see the inverse tangent of eleven-ninths, type:

  11 9 / atan p

  
and so on.


COMMANDS

The convention V1, V2 etc. will be used to denote the first, second etc.
values popped from the stack; V1 always means the value at top of the stack
at the time a command is executes.

Number format

  A number can have a preceding minus character ('-') indicating a negative
  value.  Values can also use "eXXX" notation to indicate a decimal exponent.
  
  Examples of valid numbers:
  
  1         .34       7e+8      -2        pi         # pi and e are
  2.        5.6       9e-10     -0.2E1    e          # provided by DCI
  
Operational commands

  q      Quits DCI.
  _      No operation.  Note that it is an underscore, not a minus sign.
  ?      Prints a "? " and accepts input from the user.  Input value is 
         pushed onto the stack.
  run    Pops a string value from the stack, and executes the file with
         the given name.
   
Displaying the stack

  p      Prints the top value on the stack, with newline.  Does not alter 
         the stack.
  n      Pops the first value off the stack, and prints it without a trailing
         newline.
  f      Prints the entire contents of the stack, with newlines.  Does not
         alter the stack.

Changing the stack

  c      Clears the stack.
  d      Duplicates the top value on the stack.
  r      Reverses the order of the top two values on the stack.

Changing display and operation modes

  mode   Prints status of display mode.
  auto   Sets 'auto' output mode.  Decimal-precision is ignored.
  fix    Sets fixed-point output mode.
  sci    Sets scientific-notation output mode.
  eng    Sets engineering-notation output mode.
  k      Pops V1, and sets the decimal-point precision for number display.
  K      Pushes the current decimal-point precision onto the stack.
  deg    Sets 'degrees' mode for display and computation.
  rad    Sets 'radians' mode for display and computation.
  
Storing and recalling values
 
  sX     Store.  'X' can be any character.  Pops V1 and stores it as X.
  lX     Recall.  Retrieves the value under 'X' and pushes it on the stack.
  
Arithmetic

  +      Add.  Pops V1 and V2, then pushes (V2+V1).
  -      Subtract.  Pops V1 and V2, then pushes (V2-V1).
  *      Multiply.  Pops V1 and V2, then pushes (V2*V1).
  /      Divide.  Pops V1 and V2, then pushes (V2/V1).
  
  sq     Square.  Pops V1, and pushes (V1*V1).
  ^      Exponent.  Pops V1 and V2, then pushes (V2^V1).
  v      Square root.  Pops V1, then pushes sqrt(V1).
  sqrt   (Same as v)
  V      Root.  Pops V1 and V2, then pushes the V1th root of V2.
  
  %      Modulo.  Pops V1 and V2, then pushes the remainder of (V2/V1).
  mod    (Same as %)
  !      Factorial.  Pops V1 and converts it to a positive integer.
         Computes V1*(V1-1)*(V1-2)*...*1 and pushes the result.
         Note that 0! equals 1 by mathematical convention.
  fact   (Same as !)
  
  rec    Reciprocal.  Pops V1, and pushes 1/V1.
  recip  (Same as rec)
  neg    Negate.  Pops V1, and pushes -V1.
  abs    Absolute value.  Pops V1, and pushes |V1|.
  int    Integer.  Pops V1, and pushes int(V1).
         
Exponentials and Logarithms

  ln     Natural (base e) logarithm.  Pops V1, and pushes ln(V1).
  log    Base 10 logarithm.  Pops V1, and pushes log10(V1).
  exp    Exponential.  Pops V1, and pushes e to the power of V1.
  
Trigonometry

  See 'deg' and 'rad' above about degrees/radians mode.
  
  sin    Sine.  Pops V1, and pushes the sine of V1.
  asin   Arcsine.  Pops V1, and pushes the inverse sine of V1.
  cos    Cosine.  Pops V1, and pushes the cosine of V1.
  acos   Arccosine.  Pops V1, and pushes the inverse cosine of V1.
  tan    Tangent.  Pops V1, and pushes the tangent of V1.
  atan   Arctangent.  Pops V1, and pushes the inverse tangent of V1.
  
Complex Values

  Complex (imaginary) values are represented by a pair of values on the 
  stack.  In rectangular form, (X + iY) is represented by Y in V2, X in V1.
  In polar form, R*exp(iTHETA) is represented by THETA in V2, R in V1. 
  
  pol    Convert rectangular form to polar form.  Pops X then Y, 
         pushes THETA then R.
  polar  (Same as pol)
  rect   Convert polar form to rectangular form.  Pops R then THETA,
         pushes Y then X.

