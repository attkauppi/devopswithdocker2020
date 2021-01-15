#!/bin/bash

echo "Which github repo would you like to clone: "

read repo

# repo I used for testing: git@github.com:attkauppi/devops_ruby_example.git
git clone $repo


# Read docker login details and desired project name 
# from login_secrets.txt placed inside this folder
# format for entering login details and project name:
# user: username
# password: password
# project: devopsrubyexample
while read -r line; do 
    c+=($line)
done < <(awk '$1 ~ /user:|password:|project:/ { print $2 }' login_secrets.txt)
# ${c[0]} = username
# ${c[1]} = password
# ${c[2]} = docker projectname

# cd into github project
cd $( echo ${repo%.*} | sed 's|.*/||' )

# Docker won't accept the password unless you give it to
# it as stdin, which is too proactive for us, so we're
# getting around it by echoing the password
echo ${c[1]} | docker login -u ${c[0]} --password-stdin

# dockerhub project path will be username/projectname, which
# is equivalent to: ${c[0]}/${c[2]}
docker build -t ${c[0]}/${c[2]}:latest .
docker push ${c[0]}/${c[2]}

