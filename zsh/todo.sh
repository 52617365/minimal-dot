#!/bin/bash
tmp_file_name=/Users/rase/TODO_TEMP_$$

echo "----------------------" >> $tmp_file_name
date >> $tmp_file_name
echo "- " >> $tmp_file_name
echo "----------------------" >> $tmp_file_name
cat /Users/rase/TODO >> $tmp_file_name
mv $tmp_file_name /Users/rase/TODO
nvim "+call cursor(3,3)" /Users/rase/TODO
