#!/bin/bash
echo -e '\033]0;Monitor Sistema\a'
printf '\033[8;9;60t' 

temp1=0
temp2=0
temp3=0
temp4=0
temp5=0
cont=0
target=0
bold=$(tput bold) 
underlinedStart=$(tput smul)
underlinedStop=$(tput rmul)
normal=$(tput sgr0)
moveCursor='\033[7A'
red=`tput setaf 1`

aux=$(nvidia-settings -a GPUFanControlState=1) 
while [ true ]
do
    temp1=$(nvidia-settings -q GPUCoreTemp | grep GPUCoreTemp -m 1 | cut -c 55-56)
    temp2=$(sensors | grep 'Package id 0:' | cut -c 17-18)
    temp3=$(sensors | grep temp1: | cut -c 16-17)
    temp4=$(sensors | grep temp2: | cut -c 16-17)
    temp5=$(sensors | grep temp3: | cut -c 16-17)


    if (( $temp1 <= 39 && $target != 38 )); then
           aux=$(nvidia-settings -a GPUTargetFanSpeed=38)  
           cont=$(($cont+1)) 
           target=38 

    elif (( $temp1 >= 40 && $temp1 <= 43 && $target != 70 )); then
           aux=$(nvidia-settings -a GPUTargetFanSpeed=70)
           cont=$(($cont+1))
           target=70

    elif (( $temp1 >= 44 && $temp1 <= 47 && $target != 80 )); then
           aux=$(nvidia-settings -a GPUTargetFanSpeed=80)
           cont=$(($cont+1))
           target=80
    
    elif (( $temp1  >= 48 && $temp1 <= 51 && $target != 90 )); then
           aux=$(nvidia-settings -a GPUTargetFanSpeed=90)
           cont=$(($cont+1))
           target=90
    
    elif (( $temp1 >= 52 && $target != 100 )); then
           aux=$(nvidia-settings -a GPUTargetFanSpeed=100)
           cont=$(($cont+1))
           target=100
    fi



    vel=$(nvidia-settings -q GPUCurrentFanSpeed)
    vel=$(echo $vel | grep "Attribute 'GPUCurrentFanSpeed'")
    vel=$(echo $vel | cut -c 65-68)
    

        echo $normal'   ____________________________'
        echo '   ____GPU____   ||  ___CPU____'
        if (( $temp1 >= 55 || $temp2 >= 55 )); then
            echo $bold$red'   GTEMP:  '$temp1'°   || '' CTEMP: '$temp2'°'  ' DANGER !!      ' $normal
        else
            echo '   GTEMP:  '$bold$red$temp1$normal'°   || '' CTEMP: '$bold$red$temp2'°'   $normal' NORMAL TEMPS' $normal
        fi
       
        if [ $vel == "100." ]; then 
            vel=$(echo $vel | cut -c 1-3) 
            echo '   Speed: '$vel'%  ||  ''MB2:   '$temp5'°'$red
        else       
            vel=$(echo $vel | cut -c 1-2)
            echo '   Speed:  '$vel'%   ||  ''MB2:   '$temp5'°'
        fi     
      
        if (( target == 100 ));then
            echo '  Target:  '$target'%  ||  ''MB1:   '$temp4'°' 
        else 
            echo '  Target:  '$target'%   ||  ''MB1:   '$temp4'°'
        fi 
        echo  '                 ||  ''MB3:   '$temp3'°' $red


        echo -en $moveCursor
        sleep 2s

   


done






