#FENESTRO=fenestro
FENESTRO=../build/Release/fenestro

echo "Should display 1.htm, 2.html, 3.html"
echo "<html><body>1</body></html>" | $FENESTRO -n 1.htm
echo "<html><body>2</body></html>" | $FENESTRO --name 2.html
echo "<html><body>3</body></html>" | $FENESTRO --name 3.html

sleep 1

echo "In new window, should display 4.txt, 5.html, 6.html"
echo "<html><body>4</body></html>" | $FENESTRO --name 4.txt
echo "<html><body>5</body></html>" | $FENESTRO --name 5.html
echo "<html><body>6</body></html>" | $FENESTRO --name 6.html
