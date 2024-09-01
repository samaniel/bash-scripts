#! /bin/bash

#@author ColonDev
#Please note:
#Under some distros shutdown and reboot are reserved for root

function calculoHoras {
    let horas=$respuesta/60    
    return $horas
}
function calculoMinutos {
    let minutos=$respuesta%60    
    return $minutos
}

until [ $fin = true ]; do

    respuesta=$(zenity --entry --title="Enter option" --text="Cancel shutdown(0), reboot(1) or poweroff(2-999)" );

    if [[ $respuesta =~ ^$ ]]; then 
            fin=true
    elif [[ $respuesta =~ ^0$ ]]; then         
            shutdown -c
            zenity --info --text="Shutdown canceled" --width=150
            fin=true
    elif [[ $respuesta -eq 1 ]]; then 
            reboot
    else
            if [[ $respuesta =~ ^[0-9]+$ ]]; then 
              
                if [[ $respuesta -lt 999 ]] && [[ $respuesta -gt 0 ]]; then 
                    calculoHoras $respuesta   
                    calculoMinutos $respuesta
                    shutdown $respuesta         
                    zenity --info --text="PowerOff in $horas hours and $minutos minutes"  --width=200 --timeout 3                    
                    fin=true 

                else
                    zenity --error --text="Value out of range" --width=150
                    fin=false
              
                fi


            elif [[ $respuesta =~ ^-[0-9]+$ ]]; then 
                zenity --error --text="Enter a positive number" --width=200
                fin=false

            else 
                zenity --error --text="Only numeric values are accepted" --width=150
                fin=false              

            fi
    fi
done
