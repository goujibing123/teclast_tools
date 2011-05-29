print('RK29xx�̼����/�������')
print('Wendal��Ʒ http://wendal.net')
print('��Ŀ��ַ: https://github.com/wendal/teclast_tools')
print('�������: pad@wendal.net')


function readHex(f)
    D1 = string.byte(f:read(1))
    D2 = string.byte(f:read(1))
    D3 = string.byte(f:read(1))
    D4 = string.byte(f:read(1))
    --D = D1 + D2 *256 8 + D3 * 256 * 256 + D4 *256*256*256
    return D1 + D2 *256 + D3 * 256 * 256 + D4 *256*256*256
end

BUFF=8192

function readDate(f,pos,len,dest)
    print(string.format('ƫ����(0x%X) ����(0x%X)',pos,len))
    rom_file:seek('set',pos)
    destF = io.open(dest, 'wb+')
    while len > 0 do
        data = nil
        if len > BUFF then
            data = f:read(BUFF)
            len = len - BUFF
        else
            data = f:read(len)
            len = 0
        end
        if data then
            destF:write(data)
        end
        --print('len=',len, data)
    end
    destF:flush()
    destF:close()
end

--��ѹ
function unpack()
    rom_file=io.open('wendal.img','rb')

    print("��ȡ�ļ�ͷ")
    print("�ļ�ͷ"..rom_file:read(5))

    rom_file:seek('set',25)
    print("��ȡloader��ƫ����")
    L_P = readHex(rom_file)
    print("��ȡloader�ĳ���")
    L_L = readHex(rom_file)
    
    print("��ȡupdate.img��ƫ����")
    U_P = readHex(rom_file)
    print("��ȡupdate.img�ĳ���")
    U_L = readHex(rom_file)
    
    
    print("���Loader�ļ�")
    readDate(rom_file,L_P,L_L,'RK29xxLoader(L).bin')
    print("���updata.img")
    readDate(rom_file,U_P,U_L,'update.img')
    
    print("��ѹupdata.img��Temp�ļ���")
    os.execute('AFPTool.exe -unpack update.img Temp\\')
    
    print("��ѹsystem.img��system�ļ���")
    os.execute('cramfsck_nocrc -x system Temp\\Image\\system.img')
    
    print("����rootȨ��")
    os.execute('copy /B su system\\bin\\su >nul')
    os.execute('copy /B Superuser.apk system\\app\\ >nul')
    os.execute('chmod -R 0777 system/*')
    os.execute('chmod 6755 system/bin/su')
    os.execute('chmod 6755 system/app/Superuser.apk')
    print('������� -- ȫ�����')
end