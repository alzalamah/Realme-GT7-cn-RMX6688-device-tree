#!/system/bin/sh
#=============================================================================
#persist.debug.cpu.dvfs.config
#testing_phase=`getprop persist.debug.cpu.dvfs.config`
#=============================================================================

echo "Just for CPU DVFS Debug"
echo "This is ftmd code"
#ntest*delay= 1200S
ntest=4000
delay=0.3    ## 300ms

lit_cfrqs=(1)
mid_cfrqs=(1)
big_cfrqs=(1)
gold_cfrqs=(1)

CPUFREQ_INFO_PATH="/sys/devices/system/cpu/cpufreq"
CPUFREQ_LIST_PATH="scaling_available_frequencies"
CPUFREQ_CURFREQ_PATH="scaling_cur_freq"
CPUFREQ_MAX_PATH="scaling_max_freq"
CPUFREQ_MIN_PATH="scaling_min_freq"

policies_temp=(`ls $CPUFREQ_INFO_PATH`)

policies=()
for element in "${policies_temp[@]}"; do
    number=$(echo $element | grep -o '[0-9][0-9]*')
    echo number is $number
    policies+=($number)
done

if [ x"${#policies[*]}" = x"2" ]; then
    lit_cfrqs=(`cat $CPUFREQ_INFO_PATH/policy${policies[0]}/$CPUFREQ_LIST_PATH`)
    big_cfrqs=(`cat $CPUFREQ_INFO_PATH/policy${policies[1]}/$CPUFREQ_LIST_PATH`)
    echo ${lit_cfrqs[*]}
    echo ${big_cfrqs[*]}
elif [ x"${#policies[*]}" = x"3" ]; then
    lit_cfrqs=(`cat $CPUFREQ_INFO_PATH/policy${policies[0]}/$CPUFREQ_LIST_PATH`)
    big_cfrqs=(`cat $CPUFREQ_INFO_PATH/policy${policies[1]}/$CPUFREQ_LIST_PATH`)
    gold_cfrqs=(`cat $CPUFREQ_INFO_PATH/policy${policies[2]}/$CPUFREQ_LIST_PATH`)
    echo ${lit_cfrqs[*]}
    echo ${big_cfrqs[*]}
    echo ${gold_cfrqs[*]}
else
    lit_cfrqs=(`cat $CPUFREQ_INFO_PATH/policy${policies[0]}/$CPUFREQ_LIST_PATH`)
    mid_cfrqs=(`cat $CPUFREQ_INFO_PATH/policy${policies[1]}/$CPUFREQ_LIST_PATH`)
    big_cfrqs=(`cat $CPUFREQ_INFO_PATH/policy${policies[2]}/$CPUFREQ_LIST_PATH`)
    gold_cfrqs=(`cat $CPUFREQ_INFO_PATH/policy${policies[3]}/$CPUFREQ_LIST_PATH`)
    echo ${lit_cfrqs[*]}
    echo ${mid_cfrqs[*]}
    echo ${big_cfrqs[*]}
    echo ${gold_cfrqs[*]}
fi


cpu_freq_switch() {
    if [ x"${#policies[*]}" = x"2" ]; then
        echo ${lit_cfrqs[l]} > /sys/devices/system/cpu/cpufreq/policy${policies[0]}/scaling_max_freq
        echo ${lit_cfrqs[l]} > /sys/devices/system/cpu/cpufreq/policy${policies[0]}/scaling_min_freq
        echo ${big_cfrqs[b]} > /sys/devices/system/cpu/cpufreq/policy${policies[1]}/scaling_max_freq
        echo ${big_cfrqs[b]} > /sys/devices/system/cpu/cpufreq/policy${policies[1]}/scaling_min_freq
    elif [ x"${#policies[*]}" = x"3" ]; then
        echo ${lit_cfrqs[l]} > /sys/devices/system/cpu/cpufreq/policy${policies[0]}/scaling_max_freq
        echo ${lit_cfrqs[l]} > /sys/devices/system/cpu/cpufreq/policy${policies[0]}/scaling_min_freq
        echo ${big_cfrqs[b]} > /sys/devices/system/cpu/cpufreq/policy${policies[1]}/scaling_max_freq
        echo ${big_cfrqs[b]} > /sys/devices/system/cpu/cpufreq/policy${policies[1]}/scaling_min_freq
        echo ${gold_cfrqs[g]} > /sys/devices/system/cpu/cpufreq/policy${policies[2]}/scaling_max_freq
        echo ${gold_cfrqs[g]} > /sys/devices/system/cpu/cpufreq/policy${policies[2]}/scaling_min_freq
    else
        echo ${lit_cfrqs[l]} > /sys/devices/system/cpu/cpufreq/policy${policies[0]}/scaling_max_freq
        echo ${lit_cfrqs[l]} > /sys/devices/system/cpu/cpufreq/policy${policies[0]}/scaling_min_freq
        echo ${mid_cfrqs[m]} > /sys/devices/system/cpu/cpufreq/policy${policies[1]}/scaling_max_freq
        echo ${mid_cfrqs[m]} > /sys/devices/system/cpu/cpufreq/policy${policies[1]}/scaling_min_freq
        echo ${big_cfrqs[b]} > /sys/devices/system/cpu/cpufreq/policy${policies[2]}/scaling_max_freq
        echo ${big_cfrqs[b]} > /sys/devices/system/cpu/cpufreq/policy${policies[2]}/scaling_min_freq
        echo ${gold_cfrqs[g]} > /sys/devices/system/cpu/cpufreq/policy${policies[3]}/scaling_max_freq
        echo ${gold_cfrqs[g]} > /sys/devices/system/cpu/cpufreq/policy${policies[3]}/scaling_min_freq
    fi
}


display_freq() {
    if [ x"${#policies[*]}" = x"2" ]; then
       echo "policy"${policies[0]} "cur_freq: "$(< $CPUFREQ_INFO_PATH/policy${policies[0]}/$CPUFREQ_CURFREQ_PATH)
       echo "policy"${policies[1]} "cur_freq: "$(< $CPUFREQ_INFO_PATH/policy${policies[1]}/$CPUFREQ_CURFREQ_PATH)
    elif [ x"${#policies[*]}" = x"3" ]; then
       echo "policy"${policies[0]} "cur_freq: "$(< $CPUFREQ_INFO_PATH/policy${policies[0]}/$CPUFREQ_CURFREQ_PATH)
       echo "policy"${policies[1]} "cur_freq: "$(< $CPUFREQ_INFO_PATH/policy${policies[1]}/$CPUFREQ_CURFREQ_PATH)
       echo "policy"${policies[2]} "cur_freq: "$(< $CPUFREQ_INFO_PATH/policy${policies[2]}/$CPUFREQ_CURFREQ_PATH)
    else
       echo "policy"${policies[0]} "cur_freq: "$(< $CPUFREQ_INFO_PATH/policy${policies[0]}/$CPUFREQ_CURFREQ_PATH)
       echo "policy"${policies[1]} "cur_freq: "$(< $CPUFREQ_INFO_PATH/policy${policies[1]}/$CPUFREQ_CURFREQ_PATH)
       echo "policy"${policies[2]} "cur_freq: "$(< $CPUFREQ_INFO_PATH/policy${policies[2]}/$CPUFREQ_CURFREQ_PATH)
       echo "policy"${policies[3]} "cur_freq: "$(< $CPUFREQ_INFO_PATH/policy${policies[3]}/$CPUFREQ_CURFREQ_PATH)
    fi
}

#cpu dvfs random
do_cpudvfs_random(){
    for i in $(seq 1 ${ntest})
    do
        l=$(($RANDOM%${#lit_cfrqs[@]}))
        m=$(($RANDOM%${#mid_cfrqs[@]}))
        b=$(($RANDOM%${#big_cfrqs[@]}))
        g=$(($RANDOM%${#gold_cfrqs[@]}))

        cpu_freq_switch
        display_freq
        sleep ${delay}
    done
}

#cpu dvfs fix min
do_cpudvfs_fixOPPmin(){
    echo "cpu dvfs fixOPPmin"
    for i in $(seq 1 ${ntest})
    do
        l=0
        m=0
        b=0
        g=0

        cpu_freq_switch
        display_freq
        sleep ${delay}
    done
}


#cpu dvfs fix max
do_cpudvfs_fixOPPmax(){
    echo "cpu dvfs fixOPPmax"
    for i in $(seq 1 ${ntest})
    do
        l=${#lit_cfrqs[@]}-1
        m=${#mid_cfrqs[@]}-1
        b=${#big_cfrqs[@]}-1
        g=${#gold_cfrqs[@]}-1

        cpu_freq_switch
        display_freq
        sleep ${delay}
    done
}


#cpu dvfs max_min
do_cpudvfs_OPPmax_OPPmin(){
    echo "cpu dvfs fixOPP0"
    for i in $(seq 1 ${ntest})
    do
        check=$(($RANDOM%2))
        if [ $check -eq 0 ]; then
            l=0
            m=0
            b=0
            g=0
        else
            l=${#lit_cfrqs[@]}-1
            m=${#mid_cfrqs[@]}-1
            b=${#big_cfrqs[@]}-1
            g=${#gold_cfrqs[@]}-1
        fi

        cpu_freq_switch
        display_freq
        sleep ${delay}
    done
}

do_cpudvfs_longstep_random(){
    echo "cpu dvfs long step random"
    llen=$((${#lit_cfrqs[@]}-1))
    mlen=$((${#mid_cfrqs[@]}-1))
    blen=$((${#big_cfrqs[@]}-1))
    glen=$((${#gold_cfrqs[@]}-1))

    lmid=$(($llen/2))
    mmid=$(($mlen/2))
    bmid=$(($blen/2))
    gmid=$(($glen/2))

    l=0
    m=0
    b=0
    g=0

    for i in $(seq 1 ${ntest})
    do
        lstep=$(($(($RANDOM%$(($llen-5))))+5))
        mstep=$(($(($RANDOM%$(($mlen-5))))+5))
        bstep=$(($(($RANDOM%$(($blen-5))))+5))
        gstep=$(($(($RANDOM%$(($glen-5))))+5))


        if [ $l -lt $lstep ]; then
            l=$(($l+$lstep))
        else
            l=$(($l-$lstep))
        fi

        if [ $m -lt $mstep ]; then
            m=$(($m+$mstep))
        else
            m=$(($m-$mstep))
        fi

        if [ $b -lt $bstep ]; then
            b=$(($b+$bstep))
        else
            b=$(($b-$bstep))
        fi

        if [ $g -lt $gstep ]; then
            g=$(($g+$gstep))
        else
            g=$(($g-$gstep))
        fi

        if [ $l -lt 0 ]; then
            l=0
        fi

        if [ $m -lt 0 ]; then
            m=0
        fi

        if [ $b -lt 0 ]; then
            b=0
        fi

        if [ $g -lt 0 ]; then
            g=0
        fi

        if [ $l -eq $llen ]; then
            l=$llen
        fi

        if [ $m -eq $mlen ]; then
            m=$mlen
        fi

        if [ $b -eq $blen ]; then
            b=$blen
        fi

        if [ $g -eq $glen ]; then
            gt=$glen
        fi

        if [ $l -gt $llen ]; then
            l=$llen
        fi

        if [ $m -gt $mlen ]; then
            m=$mlen
        fi

        if [ $b -gt $blen ]; then
            b=$blen
        fi

        if [ $g -gt $glen ]; then
            g=$glen
        fi

        echo cpudvfs longstep_random litc is $l
        echo cpudvfs longstep_random midc is $m
        echo cpudvfs longstep_random bigc is $b
        echo cpudvfs longstep_random goldc is $g

        cpu_freq_switch
        display_freq
        sleep ${delay}
    done
}

do_cpudvfs_shortstep_random(){
    echo "cpu dvfs short step random"
    l=$(($RANDOM%${#lit_cfrqs[@]}))
    m=$(($RANDOM%${#mid_cfrqs[@]}))
    b=$(($RANDOM%${#big_cfrqs[@]}))
    g=$(($RANDOM%${#gold_cfrqs[@]}))

    for i in $(seq 1 ${ntest})
    do
        L_step=$(($RANDOM%3))
        M_step=$(($RANDOM%3))
        B_step=$(($RANDOM%3))
        G_step=$(($RANDOM%3))

        l=$(($l+1+$L_step))
        m=$(($m+1+$M_step))
        b=$(($b+1+$B_step))
        g=$(($g+1+$G_step))

        l=$(($l%${#lit_cfrqs[@]}))
        b=$(($b%${#big_cfrqs[@]}))
        m=$(($m%${#mid_cfrqs[@]}))
        g=$(($g%${#gold_cfrqs[@]}))

        echo cpudvfs shortstep_random litc is $l
        echo cpudvfs shortstep_random midc is $m
        echo cpudvfs shortstep_random bigc is $b
        echo cpudvfs shortstep_random goldc is $g

        cpu_freq_switch
        display_freq
        sleep ${delay}
    done
}

enable_cpu_hotplug_dvfs_test(){
    while [ 1 ]
    do
        cpu_debugconfig=`getprop persist.debug.cpu.dvfs.config`
        if [ "$cpu_debugconfig" = "done" ]; then
            break
        fi
        setprop persist.debug.cpu.dvfs.config max
        cpu_debugconfig=`getprop persist.debug.cpu.dvfs.config`
        echo "cpu_debugconfig:$cpu_debugconfig."
        if [ "$cpu_debugconfig" = "max" ]; then
            do_cpudvfs_fixOPPmax
        fi

        cpu_debugconfig=`getprop persist.debug.cpu.dvfs.config`
        if [ "$cpu_debugconfig" = "done" ]; then
            break
        fi
        setprop persist.debug.cpu.dvfs.config min
        cpu_debugconfig=`getprop persist.debug.cpu.dvfs.config`
        echo "cpu_debugconfig:$cpu_debugconfig."
        if [ "$cpu_debugconfig" = "min" ]; then
            do_cpudvfs_fixOPPmin
        fi

        cpu_debugconfig=`getprop persist.debug.cpu.dvfs.config`
        if [ "$cpu_debugconfig" = "done" ]; then
            break
        fi
        setprop persist.debug.cpu.dvfs.config max_min
        cpu_debugconfig=`getprop persist.debug.cpu.dvfs.config`
        echo "cpu_debugconfig:$cpu_debugconfig."
        if [ "$cpu_debugconfig" = "max_min" ]; then
            do_cpudvfs_OPPmax_OPPmin
        fi

        cpu_debugconfig=`getprop persist.debug.cpu.dvfs.config`
        if [ "$cpu_debugconfig" = "done" ]; then
            break
        fi
        setprop persist.debug.cpu.dvfs.config longstep_random
        cpu_debugconfig=`getprop persist.debug.cpu.dvfs.config`
        echo "cpu_debugconfig:$cpu_debugconfig."
        if [ "$cpu_debugconfig" = "longstep_random" ]; then
            do_cpudvfs_longstep_random
        fi

        cpu_debugconfig=`getprop persist.debug.cpu.dvfs.config`
        if [ "$cpu_debugconfig" = "done" ]; then
            break
        fi
        setprop persist.debug.cpu.dvfs.config shortstep_random
        cpu_debugconfig=`getprop persist.debug.cpu.dvfs.config`
        echo "cpu_debugconfig:$cpu_debugconfig."
        if [ "$cpu_debugconfig" = "shortstep_random" ]; then
            do_cpudvfs_shortstep_random
        fi

        cpu_debugconfig=`getprop persist.debug.cpu.dvfs.config`
        if [ "$cpu_debugconfig" = "done" ]; then
            break
        fi
        setprop persist.debug.cpu.dvfs.config random
        cpu_debugconfig=`getprop persist.debug.cpu.dvfs.config`
        echo "cpu_debugconfig:$cpu_debugconfig."
        if [ "$cpu_debugconfig" = "random" ]; then
            do_cpudvfs_random
        fi
    done
    echo "The test is done and PASS if no exception occurred."
}

enable_cpu_hotplug_dvfs_test_manual(){
    cpu_debugconfig=`getprop persist.debug.cpu.dvfs.config`
    while [ 1 ]
    do
        if [ "$cpu_debugconfig" != "done" ]; then
            break
        fi
        cpu_manualconfig=`getprop persist.debug.cpu.dvfs.manual`
        echo "cpu_manualconfig:$cpu_manualconfig."
        if [ "$cpu_manualconfig" = "random" ]; then
            do_cpudvfs_ramdom
        elif [ "$cpu_manualconfig" = "max" ]; then
            do_cpudvfs_fixOPPmax
        elif [ "$cpu_manualconfig" = "min" ]; then
            do_cpudvfs_fixOPPmin
        elif [ "$cpu_manualconfig" = "max_min" ]; then
            do_cpudvfs_OPPmax_OPPmin
        elif [ "$cpu_manualconfig" = "longstep_random" ]; then
            do_cpudvfs_longstep_random
        elif [ "$cpu_manualconfig" = "shortstep_random" ]; then
            do_cpudvfs_shortstep_random
        elif [ "$cpu_manualconfig" = "done" ]; then
            break
        else
            sleep 10
        fi
    done
    echo "The cpu_manualconfig is done and PASS if no exception occurred."
}

enable_cpu_hotplug_dvfs_test
#enable_cpu_hotplug_dvfs_test_manual
