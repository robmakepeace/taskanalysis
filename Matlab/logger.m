function logger(b,samples, beep_on)  
close all
clc
clear('time','a','temp')

no_of_devices = size(b,1)
flag = [0;0];
for j = 1:no_of_devices
    fprintf(b(j),'c');
end
for j = 1:no_of_devices
    time(j,1) = 0;
    fread(b(j));
    flushinput(b(j));
    for d = 1:50
        fscanf(b(j),' %d ');
    end
end
disp('go')
c = clock();
variable_filename = strcat(int2str(c(1)),'_',int2str(c(2)),'_',int2str(c(3)),'_',int2str(c(4)),'_',int2str(c(5))); 
time = zeros(no_of_devices,samples);
a = zeros(no_of_devices,10); 
for i = 1:samples
    if(mod(i,50)==0)
        i
    end
    for j = 1:no_of_devices
        temp = fscanf(b(j),' %d ')';
        if (length(temp) == 10) 
            a(j,:) = temp;
        else
            a(j,:) = zeros(1,10);
        end
        %fprintf(b(j),'Y');
    end
    if (mod(i,samples/5)==0 && beep_on == 1)
        beep
    end
    for j = 1:no_of_devices
        if (length(a(j,:)) == 10)
            
            if(flag(j) == 0)
                time(j,1) = a(j,1);
                flag(j) = 1;
            else
                time(j,i) = (a(j,1)-time(j,1))/1000;
            end
            [a(j,1) time(j,1) a(j,1)-time(j,1)];
            ax(j,i) = a(j,2);
            ay(j,i) = a(j,3); 
            az(j,i) = a(j,4);
            gx(j,i) = a(j,5);
            gy(j,i) = a(j,6);
            gz(j,i) = a(j,7);
            mx(j,i) = a(j,8);
            my(j,i) = a(j,9);
            mz(j,i) = a(j,10);
        end
    end
end
a_res = 2000;%2g
g_res = 250; %degreees/second
m_res = 1200; %1200uT
m_bits = 12;
bits = 15; 
for j = 1:no_of_devices
    temp = fscanf(b(j),' %d ')';
    time(j,1) = 0;
    ax(j,:) = scale(ax(j,:),a_res,bits);
    ay(j,:) = scale(ay(j,:),a_res,bits); 
    az(j,:) = scale(az(j,:),a_res,bits);
    gx(j,:) = scale(gx(j,:),g_res,bits);
    gy(j,:) = scale(gy(j,:),g_res,bits);
    gz(j,:) = scale(gz(j,:),g_res,bits);
    mx(j,:) = scale(mx(j,:),m_res,bits);
    my(j,:) = scale(my(j,:),m_res,bits);
    mz(j,:) = scale(mz(j,:),m_res,bits);
    raw(j) = make_struct(time(j,:),ax(j,:),ay(j,:),az(j,:),gx(j,:),gy(j,:),gz(j,:),mx(j,:),my(j,:),mz(j,:));
    plot_9dof(raw(j),1,length(raw(j).time));
end
self = process_struct();
s = raw;
save(variable_filename,'s');

