cd target
cd src
rm -r lib
mkdir lib
cd ..
cd ..
perl main.pl $1
mv output.c target/src
mv *.c target/src/lib
mv *.h target/src/lib
gcc target/src/output.c target/src/lib/*.c target/src/lib/*.h -o target/bin/release.exe
echo 
echo "Running your code:";
echo 
echo 

./target/bin/release.exe

echo 
echo "--------------------------------------"
echo "Press enter to kill your process"
read