#!/bin/bash

states=('New York' 'Texas' 'Oregon' 'Montana' 'Alaska')

for state in ${states[@]};
do
        if [ $state = 'hawaii' ]
        then
        echo 'Hawaii is the best'
        else
        echo 'Im not fond of Hawaii'
        fi
done 

