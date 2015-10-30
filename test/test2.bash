FENESTRO=../build/Release/fenestro

$FENESTRO -p 1.html

# does not rename file
$FENESTRO -p 2.html -n "big test 2"

cat 3.html | $FENESTRO -n "big test 3"

# should print error message and usage, instead of asking for input 
$FENESTRO 1.html

$FENESTRO --path=3.html
