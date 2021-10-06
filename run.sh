cd test/

for i in $(ls *.spl); do
    ../bin/splc $i
done

echo "-------------------------------------------------------"

for i in $(ls *.out); do
    echo $i
    diff $i ./ans/$i
    echo "---"
done