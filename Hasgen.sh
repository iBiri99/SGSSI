#!/bin/bash
m1="0000000000000000000000000000000000000000000000000000000000000000"
command="md5sum"
groupID="G08102022"
md1=$($command $1)
tmp="$1.tmp"
maxtmp="$1.max.tmp"
echo $md1
START_TIME=$SECONDS #Inicio del tiempo.
ELAPSED_TIME=0
cp $1 $tmp
echo "" >> $tmp
max=1
while [ 60 -gt $ELAPSED_TIME ]; do
  cp $tmp $1
  rand=$(openssl rand -hex 4)
  echo -n "$rand" >>$1
  echo -n "$groupID" >>$1

  md2=$($command $1)

  prefix=$({
    echo "$m1"
    echo "$md2"
  } | sed -e 'N;s/^\(.*\).*\n\1.*$/\1\n\1/;D')
  len=$(echo "$prefix" | wc -c)
  if (($len > $max)); then
    max=$len
    cp $1 $maxtmp
    echo "Nuevo maximo: $prefix $md2 $rand"
  fi
  ELAPSED_TIME=$(($SECONDS - $START_TIME)) #Actualizar cuanto tiempo ha pasado
done

cp $maxtmp $1
rm $maxtmp
rm $tmp
echo "new ${command::-3}:"
echo $($command $1)
exit 0
