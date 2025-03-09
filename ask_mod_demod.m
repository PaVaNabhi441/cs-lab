clc; clear all; close all;

x=[1 0 0 1 1 0 1];  % Binary Information
bp=0.000001;        % bit period
disp('Binary information at Transmitter :');
disp(x);

%% representation of transmitting binary information as digital signal
bit=[];
for n=1:1:length(x)
    if x(n)==1
        se=ones(1,100);
    elseif x(n)==0
        se=zeros(1,100);
    end
    bit=[bit se];
end

t1=bp/100:bp/100:100*length(x)*(bp/100);
subplot(3,1,1);
plot(t1,bit,'r','linewidth',2.5);
grid on;
axis([0 bp*length(x) -.5 1.5]);
ylabel('amplitude(volt)');
xlabel('time(sec)');
title('transmitting information as digital signal');

%% ASK modulation
A1=10;      % Amplitude of carrier signal for information 1
A2=0;       % Amplitude of carrier signal for information 0
br=1/bp;    % bit rate
f=br*10;    % carrier frequency
t2=bp/99:bp/99:bp;
ss=length(t2);
m=[];
for i=1:1:length(x)
    if x(i)==1
        y=A1*cos(2*pi*f*t2);
    else
        y=A2*cos(2*pi*f*t2);
    end
    m=[m y];
end
t3=bp/99:bp/99:bp*length(x);
subplot(3,1,2);
plot(t3,m,'b','linewidth',2.5);
xlabel('time(sec)');
ylabel('amplitude(volt)');
title('ASK modulated waveform');

%% ASK demodulation
mn=[];
for n=ss:ss:length(m)
    t=bp/99:bp/99:bp;
    y=cos(2*pi*f*t);    % carrier signal
    mm=y.*m((n-(ss-1)):n);
    t4=bp/99:bp/99:bp;
    z=trapz(t4,mm);     % integration
    zz=round((2*z/bp));
    if(zz>5)          % logic level = (A1+A2)/2=5
        a=1;
    else
        a=0;
    end
    mn=[mn a];
end
disp('Binary information at Receiver :');
disp(mn);

%% Representation of binary information as digital signal which achieved after ASK demodulation
bit=[];
for n=1:length(mn)
    if mn(n)==1
        se=ones(1,100);
    else
        se=zeros(1,100);
    end
    bit=[bit se];
end
t4=bp/100:bp/100:100*length(mn)*(bp/100); 
subplot(3,1,3) 
plot(t4,bit,'g','linewidth',2.5); 
grid on;
axis([0 bp*length(mn) -.5 1.5]); 
ylabel('amplitude(volt)'); 
xlabel('time(sec)');
title('ASK demodulated waveform');