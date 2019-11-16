clear
clc
close all

bitsNo=3000;% the
info=randi([0,1],1,bitsNo);

Ts=.01;% smapling rate
Tb=1;%bit duration in seconds
Eb=4;%energy per bit (those numbers are chosen to make calculations easier)
Nc=2;
fc=Nc/Tb;
mean =0;
N0=0;
var=N0/2;

Ab=sqrt(Eb);%bit Amplitude
bit=0:Ts:Tb-Ts;%simulation of each bit
basis=sqrt(2/Tb)*cos(2*pi*fc*bit);
Tx=[];%BPSK Logic
for i=1:bitsNo
    res=(-1)^(info(i)+1) * Ab *basis;
    Tx=[Tx res];
end

AWGNnoise=sqrt(var)*rand(1,length(Tx))+mean;
Txnoise=Tx+AWGNnoise;
% plot(Tx)
% figure
% plot(Txnoise)

%*******************************************
% reciever
decision=zeros(1,bitsNo);
for i=0:bitsNo-1
    val=Txnoise(1+i*(Tb/Ts):(i+1)*(Tb/Ts));
    Rx=Ts*val*basis';
    decision(i+1)=(Rx>=0);
end
disp(sum((info-decision)==1))