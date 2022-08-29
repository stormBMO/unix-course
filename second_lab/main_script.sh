#!/bin/bash

set -e

# Check deps here
for dep in texlive-lang-cyrillic texlive-latex-recommended bash tar dpkg grep
do
   check=$(dpkg -l | grep $dep)
   if [[ -z $check ]]
   then
      echo 'Run sudo_script.sh first'
      exit 3 
   fi
done

# Check args
if [[ (($# != 2 )) ]]
then
      echo 'Two arguments only'
      exit 3 
fi

archive="$1"
extract_folder="$2" 

# Check if archive exist
if [[ ! -f $archive ]]
then
   echo "No such archive"
   exit 3
fi   

# Check if we can untar archive
if [[ "$archive" != *.tar ]] && 
   [[ "$archive" != *.tgz ]] &&
   [[ "$archive" != *.tar.gz ]] &&
   [[ "$archive" != *.tar.xz ]] && 
   [[ "$archive" != *.tar.bz2 ]] && 
   [[ "$archive" != *.tar.tb2 ]];
then
   echo "We cannot exctact this archive"
   exit 3
fi

# Check folder existence. If its not - create
if [[ ! -d "$extract_folder" ]] 
then
   mkdir "$extract_folder"
fi  

# Check folder empty or not
if [[ "$(ls -A "$extract_folder")"  ]]
then
   echo 'Target folder is not empty'
   exit 3
fi

tar -C "$extract_folder" -xvf "$archive" > /dev/null

cd "$extract_folder"

if [[ ! -f article.tex ]]
then
   # We can do it, because due to task there is only one folder
   cd "$(ls)"
fi 

# 
if [[ ! -f article.tex ]]
then
   echo "article.tex not found"
   exit 3
fi

if pdflatex article.tex | grep -q 'Error'
then
   echo "Some error in .tex"
   exit 3
else
   echo "Done"
fi