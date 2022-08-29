#!/bin/bash

# set -ex

cd car-logs || exit

if [[ -d results ]]; then
  rm -R results
fi
mkdir results
valueInAll=0
valueOut=0
valueBefore=0
valueAfter=0
valueIn=0
valueOut=0
ruCars=0

for raw_date in *csv; do
    if [[ ${raw_date} != 'results' ]]; then
        for line in $(cat "${raw_date}"); do
            if [[ "$line" == *"заезд"* ]]; then
                ((valueIn=valueIn+1))
                ((valueInAll=valueInAll+1))
            else 
                ((valueOut=valueOut+1))
                ((valueOutAll=valueOutAll+1))    
            fi

            if [[ "$line" == *"UAZ"* ]] ||
                [[ "$line" == *"VAZ"* ]] ||
                [[ "$line" == *"GAZ"* ]] ||
                [[ "$line" == *"AURUS"* ]] ||
                [[ "$line" == *"KAMAZ"* ]] ||
                [[ "$line" == *"PAZ"* ]]; then
                        ((ruCars=ruCars+1))
                fi
            if [[ ((${line::2} > 12)) ]]; then
                ((valueAfter=valueAfter+1))
            else
                ((valueBefore=valueBefore+1))
            fi
        done
        echo "Заехало: ${valueIn}, Выехло: ${valueOut},Русских машин: ${ruCars}">>results/"${raw_date::-4}".log
        ((valueOut=0))
        ((valueIn=0))   
        ((ruCars=0))
    fi
done
echo "Разница между общим количеством автомобилей: $((valueInAll-valueOutAll)), Было машин до 12: ${valueBefore}, Было машин после 12: ${valueAfter}">>results/total.log
