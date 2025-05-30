@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
echo 启动动漫角色猜谜游戏公网穿透服务...

REM 设置颜色
color 0E

echo 正在检查并关闭已占用的端口...
REM 关闭占用3000端口的进程（游戏服务器）
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3000 ^| findstr LISTENING') do (
    echo 关闭占用3000端口的进程: %%a
    taskkill /f /pid %%a >nul 2>&1
)

REM 关闭占用3001端口的进程（数据服务器）
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3001 ^| findstr LISTENING') do (
    echo 关闭占用3001端口的进程: %%a
    taskkill /f /pid %%a >nul 2>&1
)

REM 关闭占用5173端口的进程（客户端开发服务）
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5173 ^| findstr LISTENING') do (
    echo 关闭占用5173端口的进程: %%a
    taskkill /f /pid %%a >nul 2>&1
)

echo 端口清理完成!

REM 此处不需要获取本机IP，因公网穿透地址固定为frp-man.com

REM 在客户端环境变量中设置服务器地址为公网映射地址
echo 正在更新客户端环境变量...
(
    echo # 数据服务器URL
    echo VITE_DB_SERVER_URL=http://192.168.229.1:3001
    echo.
    echo # 游戏服务器URL
    echo VITE_SERVER_URL=https://frp-man.com:13682
    echo.
    echo # AES加密密钥
    echo VITE_AES_SECRET=my-secret-key
) > client_v3\.env

REM 启动各服务（请确保各服务目录正确，并且npm run dev配置正常）

echo 正在启动游戏服务器...
start "游戏服务器 - 端口3000" cmd /c "cd /d %~dp0server_v3 && npm run dev"

echo 正在启动数据服务器...
start "数据服务器 - 端口3001" cmd /c "cd /d %~dp0data_server && npm run dev"

echo 正在启动客户端...
start "客户端 - 端口5173" cmd /c "cd /d %~dp0client_v3 && npm run dev"

echo 所有服务已启动!
echo 公网穿透客户端地址: https://frp-man.com:23418
echo 公网穿透数据服务器地址: https://frp-man.com:13682
echo 请确保防火墙和相关端口映射已正确配置！
pause
