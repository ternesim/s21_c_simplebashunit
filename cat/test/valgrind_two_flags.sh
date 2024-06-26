#!/bin/bash

SUCCESS=0
FAIL=0
COUNTER=0
RESULT=0
DIFF_RES=""
CAT_PATH=$1

declare -a tests=(
  "VAR test_case_cat.txt"
  "VAR no_file.txt"
)

declare -a extra=(
  "-s test_1_cat.txt"
  "-b -e -n -s -t -v test_1_cat.txt"
  "-t test_3_cat.txt"
  "-n test_2_cat.txt"
  "no_file.txt"
  "-n -b test_1_cat.txt"
  "-s -n -e test_4_cat.txt"
  "test_1_cat.txt -n"
  "-n test_1_cat.txt"
  "-n test_1_cat.txt test_2_cat.txt"
  "-v test_5_cat.txt"
)

testing() {
	t=$(echo $@ | sed "s/VAR/$var/")
	valgrind --leak-check=full --show-leak-kinds=all --log-file="test_s21_cat.log" $CAT_PATH/s21_cat $t 1>/dev/null 2>/dev/null
	leak=$(grep -e 'in use at exit:' test_s21_cat.log)
    (( COUNTER++ ))
    if [[ $leak == *"in use at exit: 0 bytes in 0 blocks"* ]]
    then
      (( SUCCESS++ ))
      echo " -------- $COUNTER SUCCESS  cat $t ------- "
    else
      (( FAIL++ ))
      echo " -------- $COUNTER FAIL  cat $t ------- "
    fi
    rm test_s21_cat.log
}

# специфические тесты
for i in "${extra[@]}"
do
    var="-"
    testing $i
done

# 1 параметр
for var1 in b e n s t v
do
    for i in "${tests[@]}"
    do
        var="-$var1"
        testing $i
    done
done

# 2 параметра
for var1 in b e n s t v
do
    for var2 in b e n s t v
    do
        if [ $var1 != $var2 ]
        then
            for i in "${tests[@]}"
            do
                var="-$var1 -$var2"
                testing $i
            done
        fi
    done
done


echo "FAIL: $FAIL"
echo "SUCCESS: $SUCCESS"
echo "ALL: $COUNTER"