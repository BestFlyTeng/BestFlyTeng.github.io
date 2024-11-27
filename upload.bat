@echo off
setlocal enabledelayedexpansion

:: 设置批次大小
set BATCH_SIZE=10

:: 设置 Git 仓库路径
set REPO_DIR=.\public

:: 设置 GitHub 远程仓库名（默认是 origin）
set REMOTE_NAME=https://github.com/BestFlyTeng/BestFlyTeng.github.io.git

:: 设置 GitHub 远程仓库分支名
set BRANCH_NAME=main

:: 切换到 Git 仓库目录
cd /d %REPO_DIR%
git init

:: 获取当前状态，获取所有修改过的文件列表
for /f "delims=" %%F in ('git status -s ^| findstr "^ M"') do (
    set /a count+=1
    set FILES=!FILES! %%F
)

:: 如果没有修改的文件，退出脚本
if %count%==0 (
    echo No files to commit.
    exit /b
)

:: 按批次上传文件
set i=0
for %%F in (%FILES%) do (
    set /a i+=1
    echo Adding file: %%F
    git add %%F

    :: 每当达到批次大小时，进行提交和推送
    if !i! geq %BATCH_SIZE% (
        echo Committing batch...
        git commit -m "Batch commit"
        echo Pushing to GitHub...
        git push %REMOTE_NAME% %BRANCH_NAME%
        set i=0
    )
)

:: 提交并推送剩余的文件（如果有的话）
if !i! geq 1 (
    echo Committing last batch...
    git commit -m "Final batch commit"
    echo Pushing to GitHub...
    git push %REMOTE_NAME% %BRANCH_NAME%
)

echo All files uploaded successfully to GitHub!
pause