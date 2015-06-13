function realtime(b) 
blue_int_twoway = 2;
blue_bin_twoway = 5;
mode = blue_int_twoway;
two_fifteen = 2.^15;
fread(b);
if (mode == blue_int_twoway)
    fprintf(b,'b');
elseif (mode == blue_bin_twoway)
    fprintf(b,'e');   
    fscanf(b)
    fscanf(b)
    fscanf(b)
end
fprintf(b,'Y');
c = clock();
variable_filename = strcat(int2str(c(1)),'_',int2str(c(2)),'_',int2str(c(3)),'_',int2str(c(4)),'_',int2str(c(5)));
   
flag = 1;
gz = zeros(1,1);
gy = zeros(1,1);
gx = zeros(1,1);
ax = zeros(1,1);
ay = zeros(1,1);
az = zeros(1,1);
mx = zeros(1,1);
my = zeros(1,1);
mz = zeros(1,1);
figure
subplot(3,1,1)
plot_ax = plot(ax,'-r');
hold on
plot_ay = plot(ay,'-b');
plot_az = plot(az,'-g');
hold off
xlabel('Time(s)');
ylabel('Acceleration(mg)');
legend('AX','AY','AZ');
title('Accelerpmeter')

subplot(3,1,2)
plot_gx = plot(gx,'-r');
hold on
plot_gy = plot(gy,'-b');
plot_gz = plot(gz,'-g');
hold off
legend('GX','GY','GZ');
title('Gyroscope')
xlabel('Time(s)');
ylabel('Angular Velocity(deg/s)');

subplot(3,1,3)
plot_mx = plot(mx,'-r');
hold on
plot_my = plot(my,'-b');
plot_mz = plot(mz,'-g');
legend('MX','MY','MZ');
title('Compass')
xlabel('Time(s)');
ylabel('Magnetic Field Strength (uT)');
global KEY_IS_PRESSED;
KEY_IS_PRESSED = 0;
set(gcf, 'KeyPressFcn', @myKeyPressFcn)
try
    i = 1;
    sample_start = 1;
    KEY_IS_PRESSED = 0;
    temp = 0;
    while (KEY_IS_PRESSED == 0);
        ok = 0;
        if (mode == blue_int_twoway)
            a = fscanf(b,' %d ');
            if (length(a) == 10) 
                ok = 1;
            end
        elseif (mode == blue_bin_twoway)
            buf = fread(b,24,'uint8');
            if (length(buf) == 24)
                a(1) =  bitsll(buf(1),24) + bitsll(buf(2),16) + bitsll(buf(3),8) + buf(4);
                for k = 1:9
                    a(k+1) = bitsll(buf(2*k+3),8) + buf(2*k+4);
                    if (a(k+1) > two_fifteen) 
                        a(k+1) = -(two_fifteen - mod(a(k+1),two_fifteen));
                    end            
                end
                ok = 1;
            end
        end     
        fprintf(b,'Y');
        if (ok == 1)       
            a_res = 2000;%2g
            g_res = 250; %degreees/second
            m_res = 1200; %1200uT
            m_bits = 12;
            bits = 15; 
            if(temp == 0)
                temp = a(1);
            end
            time(i) = (a(1)-temp)/1000;
            ax(i) = scale(a(2),a_res,bits);
            ay(i) = scale(a(3),a_res,bits); 
            az(i) = scale(a(4),a_res,bits);
            gx(i) = scale(a(5),g_res,bits);
            gy(i) = scale(a(6),g_res,bits);
            gz(i) = scale(a(7),g_res,bits);
            mx(i) = scale(a(8),m_res,bits);
            my(i) = scale(a(9),m_res,bits);
            mz(i) = scale(a(10),m_res,bits);
            if (i>100) 
                sample_start = sample_start + 1;
            end
            if (mod(i,100==0)) 
                
                save(variable_filename,'time','ax','ay','az','gx','gy','gz','mx','my','mz');
            end
            hold on
            set(plot_ax,'XData',time(sample_start:i));    
            set(plot_ax,'YData',ax(sample_start:i));
            set(plot_ay,'XData',time(sample_start:i));    
            set(plot_ay,'YData',ay(sample_start:i));
            set(plot_az,'XData',time(sample_start:i));    
            set(plot_az,'YData',az(sample_start:i));

            set(plot_gx,'XData',time(sample_start:i));    
            set(plot_gx,'YData',gx(sample_start:i));
            set(plot_gy,'XData',time(sample_start:i));    
            set(plot_gy,'YData',gy(sample_start:i));    
            set(plot_gz,'XData',time(sample_start:i));    
            set(plot_gz,'YData',gz(sample_start:i)); 
            
            set(plot_mx,'XData',time(sample_start:i));    
            set(plot_mx,'YData',mx(sample_start:i));
            set(plot_my,'XData',time(sample_start:i));    
            set(plot_my,'YData',my(sample_start:i));    
            set(plot_mz,'XData',time(sample_start:i));    
            set(plot_mz,'YData',mz(sample_start:i));   
            hold off
            drawnow
            i = i+1;
        end
    end
    
    close all;
CATCH ME
    close all;
end    
function myKeyPressFcn(hObject, event)

global KEY_IS_PRESSED;
KEY_IS_PRESSED  = 1;
close all;
    
    
    
    
