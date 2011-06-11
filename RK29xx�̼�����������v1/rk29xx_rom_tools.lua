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

dofile('BYTE.lua')

function writeHex(f,num)
    str = string.format('%08X',num)
    D1 = tonumber(string.sub(str,7),16)
    D2 = tonumber(string.sub(str,5,6),16)
    D3 = tonumber(string.sub(str,3,4),16)
    D4 = tonumber(string.sub(str,1,2),16)
    print(str)
    print(D1,D2,D3,D4)
    f:write(B[D1 + 1])
    f:write(B[D2 + 1])
    f:write(B[D3 + 1])
    f:write(B[D4 + 1])
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
function unpackROM()
    print("�뽫�̼��ŵ������ߵ��ļ���,������Ϊwendal.img \n�������κγ�����Ϣ")
    os.execute('pause')
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

--���
function packROM()
    print('��system���´��Ϊsystem.img,���ǵ�Temp\\Image\\system.img')
    os.execute('mkcramfs -q system Temp\\Image\\system.img')
    
    print('��Temp�е��ļ�,���Ϊupdate_new.img�ļ�')
    os.execute('Afptool -pack ./Temp update_new.img')
    
    print('��ȡloader��update_new.img���ļ���С')
    L_P = 0x66 -- Loader�Ĺ̶�ƫ����
    loader_file = io.open('RK29xxLoader(L).bin','rb+')
    L_L = loader_file:seek('end')
    loader_file:seek('set',0) -- �ָ����ļ���ʼλ��

    U_P = L_P + L_L -- update.img��ƫ����,������loader
    update_file = io.open('update_new.img','rb+')
    U_L = update_file:seek('end')
    update_file:seek('set',0) -- �ָ����ļ���ʼλ��

    T_File = io.open('template.img', 'rb+') -- ��ģ���ļ�
    DestF = io.open('wendal_new.img', 'wb+') --����Ŀ���ļ�
    data = T_File:read(25)
    DestF:write(data)
    writeHex(DestF,L_P)
    writeHex(DestF,L_L)
    writeHex(DestF,U_P)
    writeHex(DestF,U_L)
    T_File:read(16) -- ����16�ֽ�
    data = T_File:read(102 - 25 - 16)
    DestF:write(data)
    DestF:flush()
    print('��ʼд��loader')
    while L_L > 0 do
        if L_L > BUFF then
            data = loader_file:read(BUFF)
            L_L = L_L - BUFF
        else
            data = loader_file:read(L_L)
            L_L = 0
        end
        DestF:write(data)
    end
    print('��ʼд��update.img')
    while U_L > 0 do
        if U_L > BUFF then
            data = update_file:read(BUFF)
            U_L = U_L - BUFF
        else
            data = update_file:read(U_L)
            U_L = 0
        end
        DestF:write(data)
    end
    DestF:flush()
    DestF:close()
    print('����MD5')
    os.execute('md5sums.exe -u wendal_new.img > md5.txt')
    M_File = io.open('md5.txt','r')
    md5 = M_File:read(32)
    print('MD5='..md5)
    print('��MD5д��wendal_new.img')
    DestF = io.open('wendal_new.img', 'ab+') --����Ŀ���ļ�
    DestF:seek('end')
    DestF:write(md5)
    DestF:flush()
    DestF:close()
    print('������!! Ŀ���ļ�wendal_new.img')
end


while true do
    print('�����빦�ܺ���: 1-��� 2-��� 3-�˳�')
    m = io.read('*n')
    if m == 1 then
        unpackROM()
    elseif m == 2 then
        packROM()
    elseif m == 3 then
        os.exit(1)
    end
end