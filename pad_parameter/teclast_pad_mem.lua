print('̨��ƽ��̼� �ڴ�����ļ�parameter�޸���')
print('Wendal��Ʒ http://wendal.net')

DATA_NAME = {
misc='���ķ���',
kernel='�ں�',
boot='��������',
recovery='�ָ�����',
system='ϵͳ����',
backup='���ݷ���',
cache='�������',
userdata='�û�������',
kpanic='T760���з���',
user='������'
}

NAMES = {'misc','kernel','boot','recovery','system','backup','cache','userdata','kpanic'}

P_SIZE=512 -- ����Ĵ�С

function printInfo(nameX)
    print(string.format('%-10s %-10s  %10smb',nameX,DATA_NAME[nameX],t[nameX]))
end

function printUserInfo()
    print(string.format('%-10s %-10s  %10smb','user',DATA_NAME['user'],DATA_SIZE))
end

print('���Զ�ȡparameter�ļ�')
f = io.open('parameter')
if not f then
    print('���Ƚ�parameter���뱾���ļ���!!!')
    os.exit(1)
end
io.close(f)

print('��ʼ��ȡparameter�ļ�')
lines = io.lines('parameter')
print('��ȡ���,��ʼ����')
x = nil
index = 0
for line in lines do
    index = index + 1
    if line and string.find(line,'mtdparts=.+') then
        x = line
        break
    end
end

if not x then
    print('��parameter�Ҳ�����Ҫ������!!!!')
    os.exit(2)
end

mem_str_pos = string.find(x, 'nand')+5
print('��parameter�ҵ���Ҫ��������')
mem_data_str = string.sub(x,mem_str_pos)
t = {}
DATA_SIZE=8*1024
INIT_POS = -1
for size,pos,nameX in string.gmatch(mem_data_str, '(0x[%x]+)@(0x[%x]+)[(]([%w]+)[)]') do
    size = tonumber(size) / 1024
    t[nameX] = size
    print(string.format('%-10s %-10s  %10smb',nameX,DATA_NAME[nameX],size))
    DATA_SIZE = DATA_SIZE - size
    if INIT_POS == -1 then
        INIT_POS = tonumber(pos)
    end
end
printUserInfo()


print("\n�����ΰ���ʾ������������Ĵ�С,��λΪmb,�粻�޸�,��ֱ�ӻس�����\n")
DATA_SIZE=8*1024
for i,nameX in pairs(NAMES) do
    if not t[nameX] then
        break
    end
    print(string.format('%-10s %-10s  ���ڵĴ�С:%10smb',nameX,DATA_NAME[nameX],t[nameX]))
    newSize = io.read()
    if newSize and string.len(newSize) > 0 then
        t[nameX] = tonumber(newSize)
    end
    DATA_SIZE = DATA_SIZE - t[nameX]
end
print("�������ݽ�д���ļ�:")
data_str = ''
pos = INIT_POS
for i,nameX in pairs(NAMES) do
    if not t[nameX] then
        break
    end
    print(string.format('%-10s %-10s  %10smb',nameX,DATA_NAME[nameX],t[nameX]))
    data_str = data_str .. string.format('0x%08X@0x%08X(%s),',t[nameX] * 1024,pos,nameX)
    pos = pos + t[nameX] * 1024
end
printUserInfo()
data_str = data_str .. string.format('-@0x%08X(%s)',pos,'user')

--��ʼ����ļ�
--print(data_str)
lines = io.lines('parameter')
f = io.open('parameter_new','w')
i = 0
pre = nil
for line in lines do
    i = i + 1
    if i == index then
        pre = line
        break
    end
    f.write(f, tostring(line) .. '\n')
end

pos = string.find(pre, 'nand')
pre = string.sub(pre, 1,pos - 1)
--print(pre)
f.write(f, pre .. 'nand:' .. data_str)
io.flush(f)

print("�ɹ�д��parameter_new�ļ�")