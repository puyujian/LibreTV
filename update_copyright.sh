#!/bin/bash

# 定义颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # 无颜色

# 打印带颜色的消息
print_info() {
    echo -e "${GREEN}[信息]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[警告]${NC} $1"
}

print_error() {
    echo -e "${RED}[错误]${NC} $1"
}

# 显示帮助信息
show_help() {
    echo "用法: $0 [选项]"
    echo
    echo "选项:"
    echo "  -h, --help                   显示此帮助信息"
    echo "  -n, --name NAME              指定新的版权拥有者名称"
    echo "  -y, --year YEAR              指定版权年份 (默认: 当前年份)"
    echo "  -a, --author AUTHOR          指定package.json作者 (默认: 与版权名相同)"
    echo "  -p, --project PROJECT        指定新的项目名称 (替换LibreTV)"
    echo "  -b, --backup                 创建备份 (默认: 是)"
    echo "  --no-backup                  不创建备份"
    echo
    echo "示例:"
    echo "  $0 -n \"John Doe\" -y 2025 -a \"john_doe\" -p \"MyTV\""
    echo "  $0 --name \"我的公司\" --year 2025 --project \"我的视频平台\""
    echo
    echo "如果没有提供参数，脚本将以交互模式运行。"
}

# 创建备份文件夹
create_backup() {
    if [ "$backup" = true ]; then
        backup_dir="copyright_backup_$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$backup_dir"
        
        print_info "创建备份到目录: $backup_dir"
        
        # 备份主要文件
        if [ -f "LICENSE" ]; then
            cp "LICENSE" "$backup_dir/"
            print_info "已备份: LICENSE"
        fi
        
        if [ -f "package.json" ]; then
            cp "package.json" "$backup_dir/"
            print_info "已备份: package.json"
        fi
        
        if [ -f "readme.md" ]; then
            cp "readme.md" "$backup_dir/"
            print_info "已备份: readme.md"
        fi
        
        # 备份HTML文件
        find . -name "*.html" -type f -exec cp {} "$backup_dir/" \;
        print_info "已备份所有HTML文件"
    else
        print_warning "跳过备份"
    fi
}

# 初始化默认值
copyright_name=""
copyright_year=$(date +%Y)
author_name=""
project_name=""
backup=true
old_project_name="LibreTV"

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -n|--name)
            copyright_name="$2"
            shift 2
            ;;
        -y|--year)
            copyright_year="$2"
            shift 2
            ;;
        -a|--author)
            author_name="$2"
            shift 2
            ;;
        -p|--project)
            project_name="$2"
            shift 2
            ;;
        -b|--backup)
            backup=true
            shift
            ;;
        --no-backup)
            backup=false
            shift
            ;;
        *)
            print_error "未知选项: $1"
            show_help
            exit 1
            ;;
    esac
done

# 交互模式
if [ -z "$copyright_name" ] && [ -z "$project_name" ]; then
    echo "进入交互模式..."
    
    read -p "请输入新的版权拥有者名称: " copyright_name
    if [ -z "$copyright_name" ]; then
        print_error "版权拥有者名称不能为空"
        exit 1
    fi
    
    read -p "请输入版权年份 [$copyright_year]: " year_input
    if [ ! -z "$year_input" ]; then
        copyright_year=$year_input
    fi
    
    read -p "请输入package.json作者名称 [$copyright_name]: " author_input
    if [ ! -z "$author_input" ]; then
        author_name=$author_input
    fi
    
    read -p "请输入新的项目名称 [保持不变]: " project_input
    if [ ! -z "$project_input" ]; then
        project_name=$project_input
    fi
    
    read -p "是否创建备份? [Y/n]: " backup_input
    if [[ "$backup_input" =~ ^[Nn]$ ]]; then
        backup=false
    fi
fi

# 如果没有指定作者，使用版权名称作为作者
if [ -z "$author_name" ]; then
    author_name="$copyright_name"
fi

# 创建备份
create_backup

# 替换LICENSE文件中的版权信息
if [ -f "LICENSE" ] && [ ! -z "$copyright_name" ]; then
    print_info "更新LICENSE文件中的版权信息..."
    sed -i "s/Copyright [0-9]* .*$/Copyright $copyright_year $copyright_name/g" LICENSE
    
    if [ $? -eq 0 ]; then
        print_info "成功更新LICENSE文件"
    else
        print_error "更新LICENSE文件失败"
    fi
else
    if [ -z "$copyright_name" ]; then
        print_info "跳过版权信息更新 (未提供版权拥有者名称)"
    else
        print_warning "未找到LICENSE文件"
    fi
fi

# 替换package.json中的作者信息和项目名称
if [ -f "package.json" ]; then
    if [ ! -z "$copyright_name" ]; then
        print_info "更新package.json文件中的作者信息..."
        
        # 使用临时文件避免sed在某些系统上的不一致行为
        sed "s/\"author\": \".*\"/\"author\": \"$author_name\"/g" package.json > package.json.tmp
        mv package.json.tmp package.json
        
        if [ $? -eq 0 ]; then
            print_info "成功更新package.json文件中的作者信息"
        else
            print_error "更新package.json文件中的作者信息失败"
        fi
    fi
    
    if [ ! -z "$project_name" ]; then
        print_info "更新package.json文件中的项目名称..."
        
        # 使用临时文件避免sed在某些系统上的不一致行为
        sed "s/\"name\": \"libretv\"/\"name\": \"$(echo "$project_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')\"/g" package.json > package.json.tmp
        mv package.json.tmp package.json
        
        if [ $? -eq 0 ]; then
            print_info "成功更新package.json文件中的项目名称"
        else
            print_error "更新package.json文件中的项目名称失败"
        fi
    fi
else
    print_warning "未找到package.json文件"
fi

# 替换HTML文件中的元数据作者信息和项目名称
html_count=0
html_project_count=0

if [ ! -z "$copyright_name" ] || [ ! -z "$project_name" ]; then
    print_info "更新HTML文件..."
    html_files=$(find . -name "*.html" -type f)
    
    for file in $html_files; do
        updated=false
        
        # 检查并更新作者元标记
        if [ ! -z "$copyright_name" ] && grep -q '<meta name="author"' "$file"; then
            sed -i "s/<meta name=\"author\" content=\".*\">/<meta name=\"author\" content=\"$copyright_name\">/g" "$file"
            
            if [ $? -eq 0 ]; then
                html_count=$((html_count + 1))
                updated=true
            else
                print_error "更新文件作者信息失败: $file"
            fi
        fi
        
        # 检查并更新项目名称
        if [ ! -z "$project_name" ]; then
            # 替换标题中的项目名称
            if grep -q "$old_project_name" "$file"; then
                sed -i "s/$old_project_name/$project_name/g" "$file"
                
                if [ $? -eq 0 ]; then
                    html_project_count=$((html_project_count + 1))
                    updated=true
                else
                    print_error "更新文件项目名称失败: $file"
                fi
            fi
        fi
        
        if [ "$updated" = true ]; then
            print_info "已更新文件: $file"
        fi
    done
    
    if [ ! -z "$copyright_name" ]; then
        print_info "共更新了 $html_count 个HTML文件的作者信息"
    fi
    
    if [ ! -z "$project_name" ]; then
        print_info "共更新了 $html_project_count 个HTML文件的项目名称"
    fi
fi

# 更新README.md文件中的项目名称
if [ -f "readme.md" ] && [ ! -z "$project_name" ]; then
    print_info "更新readme.md文件中的项目名称..."
    
    # 替换标题和内容中的项目名称
    sed -i "s/$old_project_name/$project_name/g" readme.md
    
    if [ $? -eq 0 ]; then
        print_info "成功更新readme.md文件"
    else
        print_error "更新readme.md文件失败"
    fi
fi

# 显示总结
echo
print_info "信息更新完成!"

if [ ! -z "$copyright_name" ]; then
    echo "版权拥有者: $copyright_name"
    echo "版权年份: $copyright_year"
    echo "作者名称: $author_name"
fi

if [ ! -z "$project_name" ]; then
    echo "项目名称: 从 \"$old_project_name\" 更改为 \"$project_name\""
fi
echo

echo "使用说明:"
echo "1. 请检查更新的文件是否符合预期"
echo "2. 如果需要恢复备份，可以从 $backup_dir 目录复制文件"
echo "3. 如果您需要将此脚本变为可执行文件，请运行: chmod +x update_copyright.sh" 