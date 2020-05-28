#!/bin/sh

instructions=/opt/mstr/tmp.log

while read p; do
    `$p`
done < $instructions
