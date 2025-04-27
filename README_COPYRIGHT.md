# LibreTV 版权信息和项目名称更新工具

这个工具可以帮助您快速替换 LibreTV 项目中的版权信息、项目名称、投诉邮箱，以及移除GitHub仓库相关信息，包括 LICENSE 文件、package.json、readme.md 以及 HTML 文件中的相关内容。

## 功能特点

- 一键替换所有版权信息和项目名称
- 更新投诉邮箱地址
- 移除GitHub仓库相关信息
- 支持命令行参数和交互式操作
- 自动创建备份，避免意外损失
- 详细的执行日志，清晰了解修改内容
- 可以根据需要灵活选择要更新的内容

## 使用方法

### 方法一：命令行参数

```bash
./update_copyright.sh -n "您的名字" -y 2025 -a "您的作者名" -p "您的项目名称" -e "您的邮箱" -r
```

参数说明：
- `-n, --name`: 指定新的版权拥有者名称
- `-y, --year`: 指定版权年份 (可选，默认为当前年份)
- `-a, --author`: 指定 package.json 作者 (可选，默认与版权名相同)
- `-p, --project`: 指定新的项目名称 (可选，替换"LibreTV")
- `-e, --email`: 指定新的投诉邮箱 (可选，默认为"admin@pei.ee")
- `-r, --remove-github`: 移除GitHub仓库相关信息 (可选)
- `-b, --backup`: 创建备份 (可选，默认为是)
- `--no-backup`: 不创建备份 (可选)
- `-h, --help`: 显示帮助信息

示例：
```bash
# 仅替换版权信息
./update_copyright.sh -n "张三" -y 2025 -a "zhangsan"

# 仅替换项目名称
./update_copyright.sh -p "我的视频站"

# 仅更新投诉邮箱
./update_copyright.sh -e "contact@example.com"

# 仅移除GitHub仓库信息
./update_copyright.sh -r

# 同时替换所有信息
./update_copyright.sh -n "张三" -y 2025 -p "我的视频站" -e "contact@example.com" -r --no-backup
```

### 方法二：交互式操作

直接运行脚本，按照提示输入信息：

```bash
./update_copyright.sh
```

脚本将引导您输入：
1. 新的版权拥有者名称（可选）
2. 版权年份（可选）
3. package.json 作者名称（可选）
4. 新的项目名称（可选）
5. 新的投诉邮箱（可选）
6. 是否移除GitHub仓库信息（可选）
7. 是否创建备份（可选）

## 替换内容范围

### 版权信息替换
- LICENSE 文件中的版权声明
- package.json 中的作者信息
- HTML 文件中的 `<meta name="author">` 标签

### 项目名称替换
- package.json 中的 "name" 字段（会自动转为小写并用连字符替换空格）
- HTML 文件中的所有"LibreTV"出现的地方（标题、描述等）
- readme.md 文件中的项目名称

### 投诉邮箱替换
- about.html 文件中的投诉邮箱地址（默认将"troll@pissmail.com"替换为"admin@pei.ee"）

### GitHub仓库信息移除
- about.html 文件中的GitHub仓库链接段落
- readme.md 文件中的GitHub仓库URL

## 注意事项

1. 脚本执行前会自动创建备份，除非您明确指定不需要备份
2. 备份文件保存在当前目录下的 `copyright_backup_时间戳` 文件夹中
3. 首次使用前请确保脚本有执行权限：`chmod +x update_copyright.sh`
4. 项目名称替换会影响多个文件，请在替换后检查是否符合预期
5. 移除GitHub仓库信息后，部署按钮可能需要手动调整为指向您自己的仓库

## 恢复备份

如果需要恢复备份，可以从备份目录中复制文件到原位置：

```bash
# 将备份的文件复制回原位置
cp copyright_backup_20250101_120000/LICENSE ./
cp copyright_backup_20250101_120000/package.json ./
cp copyright_backup_20250101_120000/readme.md ./
# 恢复HTML文件
cp copyright_backup_20250101_120000/*.html ./
```

## 技术说明

脚本使用 Bash Shell 编写，主要使用了以下命令：
- `sed` 用于文本替换
- `grep` 用于文本搜索
- `find` 用于查找文件
- `awk` 用于处理文本段落
- 备份功能使用 `cp` 命令

## 常见问题

**Q: 为什么我的更改没有生效？**  
A: 请检查是否有足够的文件权限。在某些系统上，您可能需要使用 `sudo` 运行脚本。

**Q: 如何撤销所有更改？**  
A: 使用备份目录中的文件恢复原始状态。只需将备份目录中的文件复制回原位置即可。

**Q: 项目名称替换会影响哪些内容？**  
A: 脚本会替换HTML文件中的标题、说明等含有"LibreTV"的文本，以及package.json中的name字段和readme.md中的项目名称。

**Q: 项目名称包含空格会有问题吗？**  
A: 对于HTML和readme.md中的显示名称没有问题，但在package.json中的name字段会自动将空格转换为连字符并转为小写，符合npm包命名规范。

**Q: 移除GitHub信息后，一键部署按钮还能正常工作吗？**  
A: 默认情况下，脚本会将部署按钮中的GitHub URL替换为example.com，这会导致部署功能不可用。如果需要保持部署功能，您需要手动编辑readme.md文件，将URL更改为您自己的仓库地址。

**Q: 脚本支持哪些操作系统？**  
A: 脚本应该可以在大多数类 Unix 系统（包括 Linux、macOS 和带有 Git Bash 的 Windows）上运行。 