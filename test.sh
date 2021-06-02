#!/bin/sh
echo "" > log.csv
echo "" > test-report.csv
API_KEY=$(cat api.key)
URL="api.openweathermap.org/data/2.5/weather?"
time_test=$(date)
run(){
        parameters=$1
        while IFS=';' read test_case_number test_case_description parameter_by_test expected_response
        do
        URL_TEST="$URL$parameter_by_test&appid=$API_KEY"
        test_api URL_TEST
        done < $parameters
}
test_api() {
response=$(curl -s -I "$URL_TEST"| egrep "HTTP" | awk {'print $2'} )
if [ $? == 0 ];then
    echo  "$response"
     if [[ $response == $expected_response ]] ;then
         echo "$time_test;$test_case_number;$test_case_description;$parameter_by_test;TRUE" >> test-report.csv;
       elif [[ $response != $expected_response ]] ;then
        echo "$time_test;$test_case_number;$test_case_description;$parameter_by_test;FALSE"  >> test-report.csv;
  else echo  "$time_test;$test_case_number;$test_case_description;$parameter_by_test;ERROR.Пришел не status-код  или нет связи с реусурсом.;$response" >> log.csv;
            return 1
  fi
fi
}
run $1
