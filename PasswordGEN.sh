echo "                                                       
 _____                             _ _____ _____ _____ 
|  _  |___ ___ ___ _ _ _ ___ ___ _| |   __|   __|   | |
|   __| .'|_ -|_ -| | | | . |  _| . |  |  |   __| | | |
|__|  |__,|___|___|_____|___|_| |___|_____|_____|_|___|
                                                       "
echo "Enter the length of the password"
read length
string="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+"
pass=""

if ! [[ $length =~ ^[0-9]+$ ]] || [[ $length -lt 8 ]]
then
    echo "Error: Enter a valid digit"
    exit 1
fi

verify()
{
    if [ ${#1} -lt 8 ]
    then
        return 0
    else
        if [[ $1 =~ [0-9] ]] && [[ $1 =~ [a-z] ]] && [[ $1 =~ [A-Z] ]] && [[ $1 =~ [\!\@\#\$\%\^\&\*\(\)\_\+] ]]
        then
            return 1
        else
            return 0
        fi
    fi
}

while [ $? -eq 0 ]
do
	pass=""
	for i in `seq 1 $length`
	do
		index=$(( RANDOM % ${#string} ))
		pass=$pass${string:$index:1}
	done
	verify $pass
done

echo "Your password is: $pass"
if [[ "$OSTYPE" == "darwin"* ]]; then
	echo $pass | pbcopy
else
	echo $pass | xclip -sel clip
fi

