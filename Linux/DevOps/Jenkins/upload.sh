#!/usr/bin/env bash
# 基本结构:
# 第一级: 基本参数
# 第二级: 定义的基本函数
# 第三级: 脚本逻辑

IP=$1 # 服务器IP
PORT=22 # 服务器端口
USER=root # 服务器登录用户
PASSWORD=zhouzhitong # 服务器登录密码
DIR=target # 本地文件目录
TARGET_DIR=/data/springboot-demo # 服务器目标目录
CAT_REBOOT=0 # 是否可以重启服务, 0 不重启; 否则, 表示重启服务
upload_file=('app*.jar') # 定义一个数组, 需要上传的文件
#upload_file=('bin' 'celib' 'app*.jar' 'ju/config' 'lib') # 定义一个数组, 需要上传的文件
# 遍历upload_file, 将所有元素赋值到upload_file_command字符串中, 每个元素用空格分隔开
upload_file_command=""
for file in ${upload_file[@]}; do
  upload_file_command="${upload_file_command} ${file}"
done
# 函数: 通过 scp 上传文件. 参数: 文件名或者文件目录
function scp_upload() {
  file_path=$DIR$1
  echo " 上传文件/目录: $file_path"
  # 判断是文件还是目录
  if [ -d "$file_path" ]; then
    # 是目录
    expect -c "
    set timeout 3;
    spawn scp -r -P ${PORT} ${file_path} ${USER}@${IP}:${TARGET_DIR};
    expect {
      *assword* {
        send ${PASSWORD}\r;
      }
    }
    interact
    "
  elif [ -f "$file_path" ]; then
    # 是文件
    # 上传文件
    expect -c "
        set timeout 3;
        spawn scp -P ${PORT} ${file_path} ${USER}@${IP}:${TARGET_DIR};
        expect {
          *assword* {
            send ${PASSWORD}\r;
          }
        }
        interact
        "
  else
    echo " 上传失败, 未知的文件类型: $file_path"
  fi
}

# 函数: 执行命令. 参数: 需要执行的命令
executorCommand() {
  local comm="$1"
  echo "需要执行的命令: ${comm}"
  expect -c"
    set timeout 3;
    spawn ssh -p ${PORT} ${USER}@${IP}
    expect {
      *assword* {
            send ${PASSWORD}\r;
      }
    }
    expect \"*#\"
    send \"${comm}\r\"
    send \"exit\r\"
    interact
  "
}

# 脚本业务逻辑
# 1. 判断目标文件目录是否存在
# 1.1 如果不存在, 就创建目录
# 1.2 如果存在, 删除旧文件
# 2. 开始上传文件
# 3. 重启服务

# 写命令
# 1.1 判断目标文件目录是否存在, 如果不存在, 就创建目录
check_and_create_dir_command="if [ ! -d ${TARGET_DIR} ]; then mkdir -p ${TARGET_DIR}; fi"
# 1.2 判断目标文件目录是否存在, 如果存在, 就删除旧文件(删除在upload_file集合中的文件)
delete_old_file_command="if [ -d ${TARGET_DIR} ]; then rm -rf ${upload_file_command}"
# 3. 重启服务命令
restart_command="sh ${TARGET_DIR}bin/wcs restart"
echo $restart_command
echc"开始准备对目标服务器 ${IP} 进行操作, 将本地的 ${DIR} 目录上传到 ${TARGET_DIR} 目录下"

# 写一个用scp命令上传文件和文件夹的方法:
# 参数: 文件目录或者文件名


echo "开始准备删除旧文件"
# TODO 等服务稳定应该考虑备份而不是直接删除
executorCommand "${check_and_create_dir_command}"
executorCommand "${delete_old_file_command}"

echo "开始准备上传文件 ${DIR}"
# 上传文件
# 遍历 target 目录, 将所有的文件和目录打印出来
cd "$DIR" || exit

echo "Files and directories in the target directory:"
# 2. 开始上传文件
# 打印需要上传的文件和目录
echo "需要上传的文件和目录: ${upload_file_command}"
for file in ${upload_file[@]}; do
  scp_upload $file
done

echo "上传完成!"

# 3. 重启服务
if [ $CAN_REBOOT == 1 ]; then
  echo "开始准备重启服务"
  executorCommand "${restart_command}"
  echo "重启完成"
else
  echo "没有开启重启服务"
fi

