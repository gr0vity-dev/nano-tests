#!/bin/sh

#Script to create and delete a virtualenv to keep dependencies separate from other projects 


action=$1

if [ "$action" = "" ]; 
then
    rm -rf venv_python3
    python3 -m venv venv_python3
    . venv_python3/bin/activate

    ./venv_python3/bin/pip3 install wheel
    ./venv_python3/bin/pip3 install -r ./requirements.txt --quiet  

    echo "update submodules"
    git submodule update --init --recursive

    echo "unzipping blocks"
    ./setup_unzip.sh

    echo "A new virstaul environment was created. "


elif [ "$action" = "delete" ];
then 
    . venv_python3/bin/activate
    deactivate    
    rm -rf venv_python3

else
     echo "run ./setup_python_venv.sh  to create a virtual python environment"
     echo "or"
     echo "run ./setup_python_venv.sh delete  to delete the virstual python environment"
fi


