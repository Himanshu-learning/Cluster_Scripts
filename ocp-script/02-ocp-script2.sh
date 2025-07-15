#!/bin/bash
crc start --log-level debug > crc.log  2>&1
user=$(grep -i "username" crc.log)
pass=$(grep -i "password" crc.log)
user_array=()
pass_array=()

# NOTE: After converting to array data is not easily visible
# IFS=Internal Field Seperator
# xargs is used to remove all white spaces

while IFS= read -r line; do
   user_array+=("$(echo "$line"|awk -F: '{ print $2 }'|xargs)")
done <<< "$user"

while IFS= read -r line; do
   pass_array+=("$(echo "$line"|awk -F: '{ print $2 }'|xargs)")
done <<< "$pass"

#while IFS= read -r line; do
echo "Identified users count: ${#user_array[@]}"
echo -e "Select user number to login in cluster\n1. ${user_array[0]}\n2. ${user_array[1]}"


login1=$(tail -2 crc.log|head -1|awk '{ print $2,$3,$4 }')
login2=$(tail -1 crc.log|awk '{ print $2,$3,$4 }')
login4=$(tail -1 crc.log|awk '{ print $6 }') 
login3="-p"
first_login=$login1
if [ $? -ne 0 ]; then
   echo "login unsuccessful!"
   exit 1
fi
d_login="$login2 ${user_array[1]} $login3 ${pass_array[1]} $login4"
k_login="$login2 ${user_array[0]} $login3 ${pass_array[1]} $login4"
n=1
rm -rf crc.log
while [ "$n" -ne 0 ]; do
read -p "Enter your choice: " choice 2>&1
   if [[ "$choice" =~ ^[0-9]+$ ]]; then
      if [ $choice -eq 1 ]; then
	 n=0
         k_login="$login2 ${user_array[0]} $login3 ${pass_array[0]} $login4"
	 $k_login
      elif [ $choice -eq 2 ]; then
	 n=0
         d_login="$login2 ${user_array[1]} $login3 ${pass_array[1]} $login4"
	 $d_login
      else
         echo "wrong input..... Either choose number 1 or number 2!"
      fi 
   else
      echo "Invalid Input"
   fi
done
