@ECHO OFF
CLS
color 0a

GOTO MENU
:MENU
ECHO.
ECHO.��������ɽ�system.img���н����������� ԭ����: http://401389373.qzone.qq.com/
echo. 
echo. ��Wendal�޸�,ר��̨��ƽ��̼� http://wendal.net
echo. 
echo. ע�⣺
echo. 1�������߰��������NTFS�������������ʹ�ã�
echo. 2������ǰ���Ƚ�system.img boot.img���ڱ����߰�Ŀ¼�£�
ECHO. 3��system.img�������ļ�λ�ڹ��߰�systemĿ¼�£�
ECHO. 3��boot.img�������ļ�λ�ڹ��߰�bootĿ¼�£�
ECHO. 
ECHO. ------------�̼��޸Ĺ����б�----------------
ECHO.
ECHO. 1 system.img���(�����Ƿ��Ѿ�����)
ECHO.
ECHO. 2 system.img���������
ECHO.
ECHO. 3 boot.img���
ECHO.
ECHO. 4 boot.img���
ECHO.
ECHO. 5 system.img���
ECHO.
ECHO. 6 �̼�����Root(����rootȨ��)
ECHO.
ECHO. 7 �� ��
ECHO.
ECHO. --------------------------------------------
echo. ��ѡ������Ų��س�ȷ�ϣ�
set /p ID=
if "%id%"=="1" goto cmd1

if "%id%"=="2" goto cmd2

if "%id%"=="3" goto cmd3

if "%id%"=="4" goto cmd4

if "%id%"=="5" goto cmd5

if "%id%"=="6" goto cmd6

IF "%id%"=="7" exit
PAUSE

:cmd1
echo. --------------------------------------------
echo.
echo. system.img���˵����
echo. 1����ǰ������ͬ���ļ��������ǣ�
echo. 2����ע��鿴�����Ϣ��ȷ������Ƿ�������
echo. 3��ִ�н�������󣬻Ὣsystem.img��ѹ����
echo. �߰��ڵ�system�ļ����У������޸ġ�
echo.
echo.ȷ�Ϻú�
pause
echo. -----------------------------------------  
rkDecrypt system.img
echo -----------------------------------------  
pfn -p1 system.img
echo. -----------------------------------------
echo.
echo ���ڽ���У����Ժ�...  
rmdir /s /q system 2>nul
cramfsck_nocrc -x system system.img
echo. -----------------------------------------  
echo. ������!
pause
goto MENU

:cmd2
echo.
echo.
echo. system���˵����
echo. 1������ɹ���,���ڹ��߰�Ŀ¼������Ϊsystem_new.img�Ĺ̼���
echo. 2����ǰ������ͬ���̼��ļ��������ǣ�
echo. 3����ע��鿴�����Ϣ��ȷ������Ƿ�������
echo.
echo.ȷ�Ϻú�
pause
echo. ----------------------------------------- 
echo.���ڴ���У����Ժ�...
mkcramfs -q system system_new.img
echo.������!
echo. -----------------------------------------  
pfn -p2 system_new.img
echo.�������!
pause
GOTO MENU

:cmd3
echo. --------------------------------------------
echo.
echo. boot.img���˵����
echo. 1����ǰ������ͬ���ļ��������ǣ�
echo. 2����ע��鿴�����Ϣ��ȷ������Ƿ�������
echo. 3��ִ�н�������󣬻Ὣboot.img��ѹ����
echo. �߰��ڵ�boot�ļ����У������޸ġ�
echo.
echo.ȷ�Ϻú�
pause
echo. -----------------------------------------  
echo ���ڽ���У����Ժ�... 
rmdir /s /q boot 2>nul
cramfsck_nocrc -x boot boot.img
echo. -----------------------------------------
echo. ������!
pause
goto MENU

:cmd4
echo.
echo.
echo. boot���˵����
echo. 1������ɹ���,���ڹ��߰�Ŀ¼������Ϊboot_new.img�Ĺ̼���
echo. 2����ǰ������ͬ���̼��ļ��������ǣ�
echo. 3����ע��鿴�����Ϣ��ȷ������Ƿ�������
echo.
echo.ȷ�Ϻú�
pause
mkcramfs -q boot boot_New.tmp
echo -----------------------------------------  
rkcrc boot_New.tmp boot_New.img
del /F /Q boot_New.tmp
echo.������!
pause
GOTO MENU

:cmd5
echo.
echo.
echo. system���˵����
echo. 1������ɹ���,���ڹ��߰�Ŀ¼������Ϊsystem_new.img�Ĺ̼���
echo. 2����ǰ������ͬ���̼��ļ��������ǣ�
echo. 3����ע��鿴�����Ϣ��ȷ������Ƿ�������
echo.
echo.ȷ�Ϻú�
pause
echo. ----------------------------------------- 
echo.���ڴ���У����Ժ�...
mkcramfs -q system system_new.img
echo.������!
echo. -----------------------------------------  
pause
GOTO MENU

:cmd6
echo.
echo. --------------------------------------------
echo. �̼�Root˵����
echo. 1����������ȷ���Ѿ�ͨ������Ľ�����ܽ��̼�����ˣ�
echo.
echo.ȷ�Ϻú�
pause
echo. -----------------------------------------  
copy /B su system\bin\su >nul
copy /B Superuser.apk system\app\ >nul
chmod -R 0777 system/*
chmod 6755 system/bin/su
chmod 6755 system/app/Superuser.apk
echo. ----------------------------------------- 
echo.Root�ɹ�!
pause
GOTO MENU



