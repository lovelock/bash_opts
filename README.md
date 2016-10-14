## 用Bash编写漂亮的命令行程序

我学着写这篇是因为前面写了一个[使用VBoxManage创建虚拟机]()，后来我发现这个过程太繁琐，就写了一个脚本，但脚本里面写死太多东西就没有了灵活性，所以就需要支持各种选项和参数。而因为这些命令都是很直观的命令，用Shell脚本就已经很完美的实现了这些功能。

> 本文基于[StackOverFlow](http://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash)上的这篇答案。


首先要知道几个内建变量

内建变量 | 意义
---|---
`$0` | 执行的脚本文件名
`$1/$2` | 这些带数字（>0）的表示执行脚本后面对应的第N个参数
`$#` | 脚本执行时的参数个数
`$@` | 所有参数作为一个类似数组的结构
`$*` | 和`$@`对比，前面的是一个数组结构，这个是用空格分开的多个变量
`$-` | 当前脚本执行时的附加参数，比如`-x`
`$_` | 最近的参数（或者当前脚本执行时所在的目录）
`$IFS` | 输入字段分隔符，一般是空格
`$!` | 最近的后台执行的命令，这个很常用，在vim中按Ctrl-z会把vim放在后台，在同样的终端中按`%!`就会把他切回到前台
`$$` | 当前脚本的pid（进程号）
`$?` | 脚本执行后的返回值，一般0代表成功，这个0就是我们用C写程序时`main`方法中最后的`return 0`


### 使用空格分隔选项和相应的参数

用法: `bash script.sh -e .php --path .`

```bash
#!/usr/bin/env bash

while [[ $# -gt 1 ]]
do
    KEY=$1

    case $KEY in
        -e|--extension)
            EXTENSION=$2
            shift
            ;;
        -s|--search-path)
            SEARCHPATH=$2
            shift
            ;;
        *)
            ;;
    esac
    shift


done

echo FILE_EXTENSION=${EXTENSION}
echo SEARCH_PATH=${SEARCHPATH}
echo "Number files in ${SEARCH_PATH} with ${EXTENSION}:" $(ls -1 "${SEARCHPATH}"/*."${EXTENSION}" | wc -l)

if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 $1
fi
```

该脚本接收两个参数，可以用**长参数(--extension)**也可以用**短参数(-e)**。

示例： `$ bash space.sh -e py --search-path .`

### 使用等号分隔选项和参数

```bash
#!/usr/bin/env bash

for i in $@
do
    case $i in
        -e=*|--extension=*)
            EXTENSION="${i#*=}"
            shift # past argument=value
            ;;
        -s=*|--searchpath=*)
            SEARCHPATH="${i#*=}"
            shift # past argument=value
            ;;
        *)
            # unknown option
            ;;
    esac
done

echo "FILE EXTENSION  = ${EXTENSION}"
echo "SEARCH PATH     = ${SEARCHPATH}"
echo "Number files in SEARCH PATH with EXTENSION:" $(ls -1 "${SEARCHPATH}"/*."${EXTENSION}" | wc -l)

if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 $1
fi
```

该脚本接收两个参数，可以用**长参数(--extension)**也可以用**短参数(-e)**。

示例： `$ bash space.sh -e=php --search-path=.`

### 使用`getops`

```bash
#!/usr/bin/env bash

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
EXTENSION=""
VERBOSE="-1"

while getopts "h?ve:" opt; do
    case "${opt}" in
        h|\?)
            show_help
            exit 0
            ;;
        v)  VERBOSE="-l"
            ;;
        e)  EXTENSION=$OPTARG
            ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

ls ${VERBOSE} *.${EXTENSION}
```

这种方式只能使用短参数不支持长参数，其中`${OPTARG}`表示对应的这条选项的值。

示例： `bash getopts.sh -v -e php`。

关于getopts的更多内容可以使用`help getopts`查看。