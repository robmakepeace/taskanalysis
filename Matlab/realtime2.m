function realtime2(head, hip) 
blue_int_twoway = 2;
blue_bin_twoway = 5;
mode = blue_int_twoway;
two_fifteen = 2.^15;
fread(head);
fread(hip);
if (mode == blue_int_twoway)
    fprintf(head,'b');
    fprintf(hip,'b');    
elseif (mode == blue_bin_twoway)
    fprintf(head,'e');   
    fprintf(hip,'e');     
    %fscanf(head)
    %fscanf(hip)
    %fscanf(head)
    %fscanf(hip)
    %fscanf(head)
    %fscanf(hip)    
end
fprintf(head,'Y');
fprintf(hip,'Y');
c = clock();
variable_filename = strcat(int2str(c(1)),'_',int2str(c(2)),'_',int2str(c(3)),'_',int2str(c(4)),'_',int2str(c(5)));
   
flag = 1;
head_gz = zeros(1,1);
head_gy = zeros(1,1);
head_gx = zeros(1,1);
head_ax = zeros(1,1);
head_ay = zeros(1,1);
head_az = zeros(1,1);
head_mx = zeros(1,1);
head_my = zeros(1,1);
head_mz = zeros(1,1);
hip_gz = zeros(1,1);
hip_gy = zeros(1,1);
hip_gx = zeros(1,1);
hip_ax = zeros(1,1);
hip_ay = zeros(1,1);
hip_az = zeros(1,1);
hip_mx = zeros(1,1);
hip_my = zeros(1,1);
hip_mz = zeros(1,1);
figure
subplot(3,2,1)
plot_head_ax = plot(head_ax,'-r');
hold on
plot_head_ay = plot(head_ay,'-b');
plot_head_az = plot(head_az,'-g');
hold off
xlabel('Time(s)');
ylabel('Acceleration(mg)');
legend('AX','AY','AZ');
title('Head - Accelerpmeter')

subplot(3,2,3)
plot_head_gx = plot(head_gx,'-r');
hold on
plot_head_gy = plot(head_gy,'-b');
plot_head_gz = plot(head_gz,'-g');
hold off
legend('GX','GY','GZ');
title('Head - Gyroscope')
xlabel('Time(s)');
ylabel('Angular Velocity(deg/s)');

subplot(3,2,5)
plot_head_mx = plot(head_mx,'-r');
hold on
plot_head_my = plot(head_my,'-b');
plot_head_mz = plot(head_mz,'-g');
legend('MX','MY','MZ');
title('Head - Compass')
xlabel('Time(s)');
ylabel('Magnetic Field Strength (uT)');

subplot(3,2,2)
plot_hip_ax = plot(hip_ax,'-r');
hold on
plot_hip_ay = plot(hip_ay,'-b');
plot_hip_az = plot(hip_az,'-g');
hold off
xlabel('Time(s)');
ylabel('Acceleration(mg)');
legend('AX','AY','AZ');
title('Hip - Accelerpmeter')

subplot(3,2,4)
plot_hip_gx = plot(hip_gx,'-r');
hold on
plot_hip_gy = plot(hip_gy,'-b');
plot_hip_gz = plot(hip_gz,'-g');
hold off
legend('GX','GY','GZ');
title('Hip - Gyroscope')
xlabel('Time(s)');
ylabel('Angular Velocity(deg/s)');

subplot(3,2,6)
plot_hip_mx = plot(hip_mx,'-r');
hold on
plot_hip_my = plot(hip_my,'-b');
plot_hip_mz = plot(hip_mz,'-g');
legend('MX','MY','MZ');
title('Hip - Compass')
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
        ok1 = 0;
        ok2 = 0;       
        if (mode == blue_int_twoway)
            a_head = fscanf(head,' %d ');
            if (length(a_head) == 10) 
                ok1 = 1;
            end
            a_hip = fscanf(hip,' %d ');
            if (length(a_hip) == 10) 
                ok2 = 1;
            end
        end     
        fprintf(head,'Y');
        fprintf(hip,'Y'); 
     
        a_res = 2000;%2g
        g_res = 250; %degreees/second
        m_res = 1200; %1200uT
        m_bits = 12;
        bits = 15; 
        if (ok1 == 1)       
            if(temp == 0)
                temp = a_head(1);
            end
            head_time(i) = (a_head(1)-temp)/1000;
            head_ax(i) = scale(a_head(2),a_res,bits);
            head_ay(i) = scale(a_head(3),a_res,bits); 
            head_az(i) = scale(a_head(4),a_res,bits);
            head_gx(i) = scale(a_head(5),g_res,bits);
            head_gy(i) = scale(a_head(6),g_res,bits);
            head_gz(i) = scale(a_head(7),g_res,bits);
            head_mx(i) = scale(a_head(8),m_res,bits);
            head_my(i) = scale(a_head(9),m_res,bits);
            head_mz(i) = scale(a_head(10),m_res,bits);
        end        
        if (ok2 == 1)       
            if(temp == 0)
                temp = a_hip(1);
            end
            hip_time(i) = (a_hip(1)-temp)/1000;
            hip_ax(i) = scale(a_hip(2),a_res,bits);
            hip_ay(i) = scale(a_hip(3),a_res,bits); 
            hip_az(i) = scale(a_hip(4),a_res,bits);
            hip_gx(i) = scale(a_hip(5),g_res,bits);
            hip_gy(i) = scale(a_hip(6),g_res,bits);
            hip_gz(i) = scale(a_hip(7),g_res,bits);
            hip_mx(i) = scale(a_hip(8),m_res,bits);
            hip_my(i) = scale(a_hip(9),m_res,bits);
            hip_mz(i) = scale(a_hip(10),m_res,bits);
        end 
        
        if (i>100) 
            sample_start = sample_start + 1;
        end
        
        if (mod(i,100==0)) 
            %s_head = make_struct(head_time,head_ax,head_ay,head_az,head_gx,head_gy,head_gz,head_mx,head_my,head_mz);
            %s_hip = make_struct(hip_time,hip_ax,hip_ay,hip_az,hip_gx,hip_gy,hip_gz,hip_mx,hip_my,hip_mz);
            %save(variable_filename,s_head,s_hip);
        end
        
        hold on
        set(plot_head_ax,'XData',head_time(sample_start:i));    
        set(plot_head_ax,'YData',head_ax(sample_start:i));
        set(plot_head_ay,'XData',head_time(sample_start:i));    
        set(plot_head_ay,'YData',head_ay(sample_start:i));
        set(plot_head_az,'XData',head_time(sample_start:i));    
        set(plot_head_az,'YData',head_az(sample_start:i));

        set(plot_head_gx,'XData',head_time(sample_start:i));    
        set(plot_head_gx,'YData',head_gx(sample_start:i));
        set(plot_head_gy,'XData',head_time(sample_start:i));    
        set(plot_head_gy,'YData',head_gy(sample_start:i));    
        set(plot_head_gz,'XData',head_time(sample_start:i));    
        set(plot_head_gz,'YData',head_gz(sample_start:i)); 
            
        set(plot_head_mx,'XData',head_time(sample_start:i));    
        set(plot_head_mx,'YData',head_mx(sample_start:i));
        set(plot_head_my,'XData',head_time(sample_start:i));    
        set(plot_head_my,'YData',head_my(sample_start:i));    
        set(plot_head_mz,'XData',head_time(sample_start:i));    
        set(plot_head_mz,'YData',head_mz(sample_start:i));  
        
        set(plot_hip_ax,'XData',hip_time(sample_start:i));    
        set(plot_hip_ax,'YData',hip_ax(sample_start:i));
        set(plot_hip_ay,'XData',hip_time(sample_start:i));    
        set(plot_hip_ay,'YData',hip_ay(sample_start:i));
        set(plot_hip_az,'XData',hip_time(sample_start:i));    
        set(plot_hip_az,'YData',hip_az(sample_start:i));

        set(plot_hip_gx,'XData',hip_time(sample_start:i));    
        set(plot_hip_gx,'YData',hip_gx(sample_start:i));
        set(plot_hip_gy,'XData',hip_time(sample_start:i));    
        set(plot_hip_gy,'YData',hip_gy(sample_start:i));    
        set(plot_hip_gz,'XData',hip_time(sample_start:i));    
        set(plot_hip_gz,'YData',hip_gz(sample_start:i)); 
            
        set(plot_hip_mx,'XData',hip_time(sample_start:i));    
        set(plot_hip_mx,'YData',hip_mx(sample_start:i));
        set(plot_hip_my,'XData',hip_time(sample_start:i));    
        set(plot_hip_my,'YData',hip_my(sample_start:i));    
        set(plot_hip_mz,'XData',hip_time(sample_start:i));    
        set(plot_hip_mz,'YData',hip_mz(sample_start:i));  
        hold off
        drawnow
        i = i+1;
    end   
    close all;
CATCH ME
    close all;
end    
function myKeyPressFcn(hObject, event)

global KEY_IS_PRESSED;
KEY_IS_PRESSED  = 1;
close all;
    
    
    
    
