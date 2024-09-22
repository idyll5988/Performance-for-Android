#!/system/bin/sh
date="$( date "+%y年%m月%d日%H时%M分%S秒")"
#自动获得最大FPS和流畅性能
#最大性能
#提升Gpu和Cpu性能
#修复FPS下降
#修复延迟100%
#高触摸速度
fps="$(dumpsys display | grep -o -E 'fps=[0-9]+(\.[0-9]+)?' | cut -d'=' -f2 | sort -nr | head -n1 | awk '{printf("%d\n", ($1+0.5)/1)}')"
systems=(
"debug.javafx.animation.framerate $fps"
"debug.sf-max-base-layer-fps $fps"
"debug.surface-fps-scope $fps"
"debug.redroid.fps $fps"
"debug.fps.capsmin $fps"
"debug.hwui.profile.maxframes $fps"
)
success_count=0
failure_count=0
for command in "${systems[@]}"; do
    if su -c settings put --user current system $command >/dev/null 2>&1; then
        success_count=$((success_count + 1))
    else
        failure_count=$((failure_count + 1))
        failed_commands+=("$command")
    fi
done
echo "$date *system系统设置*" 
sleep 1
echo "$date *成功应用的命令总数: $success_count*" 
echo "$date *未应用的命令总数: $failure_count*" 
if [ ${#failed_commands[@]} -gt 0 ]; then
    echo "$date *以下命令未能成功应用*"
    for failed_command in "${failed_commands[@]}"; do
        echo "$date $failed_command"
    done
fi
