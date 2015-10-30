FENESTRO=../build/Release/fenestro

echo "<html><body>1</body></html>" | $FENESTRO -name 1.htm
echo "<html><body>1</body></html>" | $FENESTRO -name 2.html

echo "<html><body>1</body></html>" | $FENESTRO

echo "<html><body>1</body></html>" | $FENESTRO -name 4.html
echo "<html><body>2</body></html>" | $FENESTRO -name 5.html

sleep 1

echo "<html><body>1</body></html>" | $FENESTRO -name 1.txt
echo "<html><body>1</body></html>" | $FENESTRO -name 2.html
echo "<html><body>2</body></html>" | $FENESTRO -name 3.html

