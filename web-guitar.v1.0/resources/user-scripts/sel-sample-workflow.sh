#!/bin/bash

# change these following configuration to your test system

#
# web site under test 
#
MEDIAWIKI_PATH=/var/www/mediawiki
php $MEDIAWIKI_PATH/maintenance/edit.php -s "Quick edit" -m Main_Page < $MEDIAWIKI_PATH/maintenance/faultpages/fault0

website="http://localhost/tudu/"
#website="http://localhost/mediawiki/index.php/Main_Page"

#
# test case directory 
#
testcases_dir=TC
statefile_dir=STA
rm -rf $testcases_dir
mkdir $testcases_dir
rm -rf GUITAR-Default.EFG GUITAR-Default.STA GUITAR-Default.GUI
rm -rf $statefile_dir
#
# number of test cases to run
#
testcase_num=15

# Use clean log
export GUITAR_OPTS="-Dlog4j.configuration=log/guitar-clean.glc"
SCRIPT_DIR=`dirname $0`
pushd $SCRIPT_DIR

# rip
echo "About to rip" 
read -p "Press ENTER to continue..."
./sel-ripper.sh --website-url $website -w 1 -d 1

# convert GUI to EFG
echo "About to convert GUI to EFG " 
read -p "Press ENTER to continue..."
./gui2efg.sh -g GUITAR-Default.GUI -e GUITAR-Default.EFG

# generate test case 
echo "About to generate test cases" 
read -p "Press ENTER to continue..."
 ./tc-gen-sq.sh -e GUITAR-Default.EFG

# replay
echo "About to replay" 
read -p "Press ENTER to continue..."

SAMPLE_TEST=`find TC -name "*.tst" | tail -n1`

i=1
mkdir $statefile_dir
for testcase in `find $testcases_dir -name "*.tst"| head -n$testcase_num`  
do
	# getting test name 
	test_name=`basename $testcase`
	test_name=${test_name%.*}
	
	./sel-replayer.sh --website-url $website -g GUITAR-Default.GUI -e GUITAR-Default.EFG -t $testcase -g $test_name.orc -d 1000 
	mv GUITAR-Default.STA $statefile_dir/GUITAR-Default.STA$i
	let i+=1
done

popd # quit to the current directory
