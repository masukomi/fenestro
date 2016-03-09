#FENESTRO=fenestro
FENESTRO=../build/Release/fenestro

echo "Should display files 1.html, 2.html, 'changed name.html', 'new file.html'"

$FENESTRO -p 1.html

$FENESTRO --path=2.html

$FENESTRO -p 2.html -n "changed name.html"

cat 3.html | $FENESTRO -n "new file.html"

echo "Should now print error message and usage:"
$FENESTRO 1.html

echo "Should only print error message:"
$FENESTRO -p dgdsge.html
