#!/bin/bash
qian=0
hou=1
echo -n $qian,
echo -n $hou
for ((i=1;i<=23;i++)) 
{
temp=$((qian+hou));
echo -n ,$temp;
qian=$hou;
hou=$temp;
}
echo ""
