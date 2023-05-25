#!/bin/bash

sas_general_info () {
    result+="{\"disk\":\"$(cat /opt/temp-smartctl-output.txt | grep 'Vendor:' | awk '{print $2}') - $(cat /opt/temp-smartctl-output.txt | grep 'Product:' | awk '{print $2}') - $(cat /opt/temp-smartctl-output.txt | grep 'Serial number:' | awk '{print $3}')\","
    
    result+="\"vendor\":"
    result+="\"$(cat /opt/temp-smartctl-output.txt | grep 'Vendor:' | awk '{print $2}')\""

    result+=",\"model\":"
    result+="\"$(cat /opt/temp-smartctl-output.txt | grep 'Product:' | awk '{print $2}')\""

    result+=",\"revision\":"
    result+="\"$(cat /opt/temp-smartctl-output.txt | grep 'Revision:' | awk '{print $2}')\""

    result+=",\"compliance\":"
    result+="\"$(cat /opt/temp-smartctl-output.txt | grep 'Compliance:' | awk '{print $2}')\""

    result+=",\"capacity_bytes\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'User Capacity:' | awk '{print $3}' | perl -pe 's/(?<=\d),(?=\d)//g')

    result+=",\"rotation_rate\":"
    result+="\"$(cat /opt/temp-smartctl-output.txt | grep 'Rotation Rate:' | awk '{$1=$2=""; print $0}' | sed 's/^ *//g')\""

    result+=",\"serial_number\":"
    result+="\"$(cat /opt/temp-smartctl-output.txt | grep 'Serial number:' | awk '{print $3}')\""

    result+=",\"transport_protocol\":"
    result+="\"$(cat /opt/temp-smartctl-output.txt | grep 'Transport protocol:' | awk '{$1=$2=""; print $0}' | sed 's/^ *//g')\""

    result+=",\"smart_health_status\":"
    result+="\"$(cat /opt/temp-smartctl-output.txt | grep 'SMART Health Status:' | awk '{$1=$2=$3=""; print $0}' | sed 's/^ *//g')\""

    result+=",\"poweron_minutes\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'power on' | head -1 | awk -F'[][]' '{print $2}' | awk '{print $1}')
    if [[ "$(cat /opt/temp-smartctl-output.txt | grep 'power on' | head -1 | awk -F'[][]' '{print $2}' | awk '{print $1}')" == "" ]]; then
        result+=null
    fi

    result+=",\"spec_cycle_cnt\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'Specified cycle count over device lifetime:' | awk '{print $7}')
    if [[ "$(cat /opt/temp-smartctl-output.txt | grep 'Specified cycle count over device lifetime:' | awk '{print $7}')" == "" ]]; then
        result+=null
    fi

    result+=",\"acc_start_stop_cycles\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'Accumulated start-stop cycles:' | awk '{print $4}')
    if [[ "$(cat /opt/temp-smartctl-output.txt | grep 'Accumulated start-stop cycles:' | awk '{print $4}')" == "" ]]; then
        result+=null
    fi

    result+=",\"spec_load_unload_cnt\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'Specified load-unload count over device lifetime:' | awk '{print $7}')
    if [[ "$(cat /opt/temp-smartctl-output.txt | grep 'Specified load-unload count over device lifetime:' | awk '{print $7}')" == "" ]]; then
        result+=null
    fi

    result+=",\"acc_load_unload_cycles\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'Accumulated load-unload cycles:' | awk '{print $4}')
    if [[ "$(cat /opt/temp-smartctl-output.txt | grep 'Accumulated load-unload cycles:' | awk '{print $4}')" == "" ]]; then
        result+=null
    fi

    result+=",\"elements_grown_defect\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'Elements in grown defect list:' | awk '{print $6}')
    if [[ "$(cat /opt/temp-smartctl-output.txt | grep 'Elements in grown defect list:' | awk '{print $6}')" == "" ]]; then
        result+=null
    fi
}

sata_general_info () {
    result+="{\"disk\":\"$(cat /opt/temp-smartctl-output.txt | grep 'Device Model' | awk '{ print substr($0, index($0,$3)) }') - $(cat /opt/temp-smartctl-output.txt | grep 'Serial Number:' | awk '{print $3}')\","
    
    result+="\"vendor\":"
    result+="\"$(cat /opt/temp-smartctl-output.txt | grep 'Device Model' | awk '{print $3}')\""

    result+=",\"model\":"
    result+="\"$(cat /opt/temp-smartctl-output.txt | grep 'Device Model' | awk '{ print substr($0, index($0,$4)) }')\""

    result+=",\"firmware_version\":"
    result+="\"$(cat /opt/temp-smartctl-output.txt | grep 'Firmware Version' | awk '{print $3}')\""

    result+=",\"capacity_bytes\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'User Capacity:' | awk '{print $3}' | perl -pe 's/(?<=\d),(?=\d)//g')

    result+=",\"rotation_rate\":"
    result+="\"$(cat /opt/temp-smartctl-output.txt | grep 'Rotation Rate' | awk '{ print substr($0, index($0,$3)) }')\""

    result+=",\"serial_number\":"
    result+="\"$(cat /opt/temp-smartctl-output.txt | grep 'Serial Number:' | awk '{print $3}')\""

    result+=",\"ata_version\":"
    result+="\"$(cat /opt/temp-smartctl-output.txt | grep '^ATA Version is:' | awk '{ print substr($0, index($0,$4)) }')\""

    result+=",\"sata_version\":"
    result+="\"$(cat /opt/temp-smartctl-output.txt | grep 'SATA Version is:' | awk '{$1=$2=$3=""; print $0}' | sed 's/^ *//g')\""

    result+=",\"smart_health_status\":"
    result+="\"$(cat /opt/temp-smartctl-output.txt | grep 'SMART overall-health self-assessment test' | awk '{print $6}')\""

    result+=",\"poweron_hours\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'Power_On_Hours' | awk '{print $8}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"reallocated_sector_cnt\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'Reallocated_Sector_Ct' | awk '{print $8}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"power_cycle_cnt\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'Power_Cycle_Count' | awk '{print $8}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"temperature\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'Airflow_Temperature_Cel' | awk '{print $8}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"wear_leveling_cnt\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'Wear_Leveling_Count' | awk '{print $8}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"used_reserved_block_cnt\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'Used_Rsvd_Blk_Cnt_Tot' | awk '{print $8}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"runtime_bad_block\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'Runtime_Bad_Block' | awk '{print $8}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"uncorrectable_error_cnt\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'Uncorrectable_Error_Cnt' | awk '{print $8}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"ecc_error_rate\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'ECC_Error_Rate' | awk '{print $8}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"crc_error_cnt\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'CRC_Error_Count' | awk '{print $8}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"por_recovery_cnt\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'POR_Recovery_Count' | awk '{print $8}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"total_lbas_written\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'Total_LBAs_Written' | awk '{print $8}' | awk -v def=null '{print} END { if(NR==0) {print def} }')
}

last_log_not_new () {
    result+=",\"read-corr-by-ecc-fast\": null"
    result+=",\"read-corr-by-ecc-delayed\": null"
    result+=",\"read-corr-by-retry\": null"
    result+=",\"read-total-err-corrected\": null"
    result+=",\"read-corr-algorithm-invocations\": null"
    result+=",\"read-gb-processed\": null"
    result+=",\"read-total-unc-errors\": null"
    result+=",\"write-corr-by-ecc-fast\": null"
    result+=",\"write-corr-by-ecc-delayed\": null"
    result+=",\"write-corr-by-retry\": null"
    result+=",\"write-total-err-corrected\": null"
    result+=",\"write-corr-algorithm-invocations\": null"
    result+=",\"write-gb-processed\": null"
    result+=",\"write-total-unc-errors\": null"
    result+=",\"verify-corr-by-ecc-fast\": null"
    result+=",\"verify-corr-by-ecc-delayed\": null"
    result+=",\"verify-corr-by-retry\": null"
    result+=",\"verify-total-err-corrected\": null"
    result+=",\"verify-corr-algorithm-invocations\": null"
    result+=",\"verify-gb-processed\": null"
    result+=",\"verify-total-unc-errors\": null"
    result+=",\"non-medium-errors\": null"
    result+=",\"temperature\": null"
}

last_log_new () {
    result+=",\"read-corr-by-ecc-fast\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'read-corr-by-ecc-fast;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"read-corr-by-ecc-delayed\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'read-corr-by-ecc-delayed;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"read-corr-by-retry\":"    
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'read-corr-by-retry;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"read-total-err-corrected\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'read-total-err-corrected;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"read-corr-algorithm-invocations\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'read-corr-algorithm-invocations;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"read-gb-processed\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'read-gb-processed;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"read-total-unc-errors\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'read-total-unc-errors;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"write-corr-by-ecc-fast\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'write-corr-by-ecc-fast;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"write-corr-by-ecc-delayed\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'write-corr-by-ecc-delayed;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"write-corr-by-retry\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'write-corr-by-retry;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"write-total-err-corrected\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'write-total-err-corrected;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"write-corr-algorithm-invocations\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'write-corr-algorithm-invocations;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"write-gb-processed\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'write-gb-processed;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"write-total-unc-errors\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'write-total-unc-errors;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"verify-corr-by-ecc-fast\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'verify-corr-by-ecc-fast;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"verify-corr-by-ecc-delayed\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'verify-corr-by-ecc-delayed;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"verify-corr-by-retry\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'verify-corr-by-retry;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"verify-total-err-corrected\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'verify-total-err-corrected;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"verify-corr-algorithm-invocations\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'verify-corr-algorithm-invocations;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"verify-gb-processed\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'verify-gb-processed;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"verify-total-unc-errors\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'verify-total-unc-errors;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"non-medium-errors\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'non-medium-errors;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')

    result+=",\"temperature\":"
    result+=$(cat /opt/temp-smart-log-output.txt | grep -o -P 'temperature;([+-]?(?=\.\d|\d)(?:\d+)?(?:\.?\d*))(?:[eE]([+-]?\d+))?;' | awk 'NR==1{split($1, arr, "[;]"); print arr[2]}' | awk -v def=null '{print} END { if(NR==0) {print def} }')
}

no_log () {
    if [[ $(cat /opt/temp-smartctl-output.txt | grep 'read:' | wc -l) -eq 1 ]]; then
        result+=",\"read-corr-by-ecc-fast\": $(cat /opt/temp-smartctl-output.txt | grep 'read:' | awk '{print $2}')"
        result+=",\"read-corr-by-ecc-delayed\": $(cat /opt/temp-smartctl-output.txt | grep 'read:' | awk '{print $3}')"
        result+=",\"read-corr-by-retry\": $(cat /opt/temp-smartctl-output.txt | grep 'read:' | awk '{print $4}')"
        result+=",\"read-total-err-corrected\": $(cat /opt/temp-smartctl-output.txt | grep 'read:' | awk '{print $5}')"
        result+=",\"read-corr-algorithm-invocations\": $(cat /opt/temp-smartctl-output.txt | grep 'read:' | awk '{print $6}')"
        result+=",\"read-gb-processed\": $(cat /opt/temp-smartctl-output.txt | grep 'read:' | awk '{print $7}')"
        result+=",\"read-total-unc-errors\": $(cat /opt/temp-smartctl-output.txt | grep 'read:' | awk '{print $8}')"
    else
        result+=",\"read-corr-by-ecc-fast\": null"
        result+=",\"read-corr-by-ecc-delayed\": null"
        result+=",\"read-corr-by-retry\": null"
        result+=",\"read-total-err-corrected\": null"
        result+=",\"read-corr-algorithm-invocations\": null"
        result+=",\"read-gb-processed\": null"
        result+=",\"read-total-unc-errors\": null"
    fi

    if [[ $(cat /opt/temp-smartctl-output.txt | grep 'write:' | wc -l) -eq 1 ]]; then
        result+=",\"write-corr-by-ecc-fast\": $(cat /opt/temp-smartctl-output.txt | grep 'write:' | awk '{print $2}')"
        result+=",\"write-corr-by-ecc-delayed\": $(cat /opt/temp-smartctl-output.txt | grep 'write:' | awk '{print $3}')"
        result+=",\"write-corr-by-retry\": $(cat /opt/temp-smartctl-output.txt | grep 'write:' | awk '{print $4}')"
        result+=",\"write-total-err-corrected\": $(cat /opt/temp-smartctl-output.txt | grep 'write:' | awk '{print $5}')"
        result+=",\"write-corr-algorithm-invocations\": $(cat /opt/temp-smartctl-output.txt | grep 'write:' | awk '{print $6}')"
        result+=",\"write-gb-processed\": $(cat /opt/temp-smartctl-output.txt | grep 'write:' | awk '{print $7}')"
        result+=",\"write-total-unc-errors\": $(cat /opt/temp-smartctl-output.txt | grep 'write:' | awk '{print $8}')"
    else
        result+=",\"write-corr-by-ecc-fast\": null"
        result+=",\"write-corr-by-ecc-delayed\": null"
        result+=",\"write-corr-by-retry\": null"
        result+=",\"write-total-err-corrected\": null"
        result+=",\"write-corr-algorithm-invocations\": null"
        result+=",\"write-gb-processed\": null"
        result+=",\"write-total-unc-errors\": null"
    fi

    if [[ $(cat /opt/temp-smartctl-output.txt | grep 'verify:' | wc -l) -eq 1 ]]; then
        result+=",\"verify-corr-by-ecc-fast\": $(cat /opt/temp-smartctl-output.txt | grep 'verify:' | awk '{print $2}')"
        result+=",\"verify-corr-by-ecc-delayed\": $(cat /opt/temp-smartctl-output.txt | grep 'verify:' | awk '{print $3}')"
        result+=",\"verify-corr-by-retry\": $(cat /opt/temp-smartctl-output.txt | grep 'verify:' | awk '{print $4}')"
        result+=",\"verify-total-err-corrected\": $(cat /opt/temp-smartctl-output.txt | grep 'verify:' | awk '{print $5}')"
        result+=",\"verify-corr-algorithm-invocations\": $(cat /opt/temp-smartctl-output.txt | grep 'verify:' | awk '{print $6}')"
        result+=",\"verify-gb-processed\": $(cat /opt/temp-smartctl-output.txt | grep 'verify:' | awk '{print $7}')"
        result+=",\"verify-total-unc-errors\": $(cat /opt/temp-smartctl-output.txt | grep 'verify:' | awk '{print $8}')"
    else
        result+=",\"verify-corr-by-ecc-fast\": null"
        result+=",\"verify-corr-by-ecc-delayed\": null"
        result+=",\"verify-corr-by-retry\": null"
        result+=",\"verify-total-err-corrected\": null"
        result+=",\"verify-corr-algorithm-invocations\": null"
        result+=",\"verify-gb-processed\": null"
        result+=",\"verify-total-unc-errors\": null"
    fi

    result+=",\"non-medium-errors\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'Non-medium error count:' | awk '{print $4}' | awk -v def=null '{print} END { if(NR==0) {print def} }')
    
    result+=",\"temperature\":"
    result+=$(cat /opt/temp-smartctl-output.txt | grep 'Current Drive Temperature:' | awk '{print $4}' | awk -v def=null '{print} END { if(NR==0) {print def} }')
}

csvfile="
$(ls /var/lib/smartmontools/ | grep '.csv')
"

pathNum=$(sudo smartctl --scan | wc -l)

flag=0

flog=0

index=1

result="{\"key\":["

while [ $index -le $pathNum ]
do
    tmpPath="$(sudo smartctl --scan | sed -n ${index}p | awk '{print $1,$2,$3}')"
    
    if [[ $(echo ${tmpPath} | grep "scsi" | wc -l) -eq 1 ]]; then
        path="$(sudo smartctl --scan | head -1 | awk '{print $1}')"
        tmpPath="$(echo "${path} -d cciss,$(($index-1))")"
    fi

    ## Temporarily save disk SMART data to a text file for later use
    sudo smartctl --xall ${tmpPath} > /opt/temp-smartctl-output.txt

    if [[ $(head -20 /opt/temp-smartctl-output.txt | grep "SAS" | wc -l) -ge 1 ]]; then
        flag=0

        sas_general_info

        # Check For Log
        for tmp in ${csvfile} ; do
            if [[ "$(cat /opt/temp-smartctl-output.txt | grep 'Serial number:' | awk '{print $3}')" == "$(echo $tmp | awk 'NR==1{t=split($1, arr, "[-.]"); print arr[t-2]}')" ]]; then
                flag=1
                ## Temporarily save disk SMART log data to a text file for later use
                tail -1 /var/lib/smartmontools/${tmp} > /opt/temp-smart-log-output.txt

                if [[ "$(cat /opt/temp-smart-log-output.txt | awk '{print $3}')" == "" ]]; then
                    # Log file is empty
                    # Check for smart data outside of this loop
                    flog=1
                    break            
                else
                    # Log file is not empty
                    if [[ "$(cat /opt/temp-smart-log-output.txt | awk '{print $1" "$2}')" == "$(cat /opt/smart-log-time/${tmp}.txt)" ]]; then
                        # Last log is not new
                        # Send No Data or Invalid Data
                        last_log_not_new

                        break
                    else
                        # Last log is new
                        $(cat /opt/temp-smart-log-output.txt | awk '{print $1" "$2}' | sudo tee /opt/smart-log-time/${tmp}.txt)
                        # Send new data
                        last_log_new

                        break
                    fi
                fi
            fi
        done

        if [[ $flag -eq 0 ]]; then
            # No Log Files Found, Get Data From smartctl
            no_log
        fi

        if [[ $flog -eq 1 ]]; then
            # Log file was empty
            no_log
        fi
    fi

    if [[ $(head -20 /opt/temp-smartctl-output.txt | grep "SATA" | wc -l) -ge 1 ]]; then
        sata_general_info
    fi

    if [[ $(head -20 /opt/temp-smartctl-output.txt | grep "SAS" | wc -l) -eq 0 ]] && [[ $(head -20 /opt/temp-smartctl-output.txt | grep "SATA" | wc -l) -eq 0 ]]; then
        index=$(($index+1))
        continue
    fi

    result+="},"

    index=$(($index+1))

done

rm -f /opt/temp-smartctl-output.txt
rm -f /opt/temp-smart-log-output.txt

echo ${result::-1}"]}" > /opt/result.txt