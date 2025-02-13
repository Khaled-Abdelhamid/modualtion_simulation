clear
clc
close all

bitsNo=2000;% the number of bits
info=randi([0,1],1,bitsNo); %the information vector

Ts=.001;% smapling rate
Tb=1;%bit duration in seconds

Nc=2;
fc=Nc/Tb;

bit=0:Ts:Tb-Ts;%simulation of each bit

Eb=5;%energy per bit (those numbers are chosen to make calculations easier)
Ab=sqrt(Eb);%bit Amplitude

mean =0;
N0=10;
var=N0/2;

basis=sqrt(2/Tb)*cos(2*pi*fc*bit);
Tx=[];

for i=1:bitsNo %the loop of the sending
    res=(-1)^(info(i)+1) * Ab *basis;
    Tx=[Tx res];
end


AWGNnoise=sqrt(var)*randn(1,length(Tx))+mean;%adding AWGN to the channel
Txnoise=Tx+AWGNnoise;

%*******************************************
% reciever
decision=zeros(1,bitsNo);
decnoise=zeros(1,bitsNo);

for i=0:bitsNo-1
    val=Txnoise(1+i*(Tb/Ts):(i+1)*(Tb/Ts));
    Rx=Ts*val*basis';
    decnoise(i+1)=Rx;
    decision(i+1)=(Rx>=0);
end

scatter ([Ab*1 Ab*-1]/sqrt(Eb),zeros(1,2),250,'r','*')
grid on
hold on
scatter (decnoise/sqrt(Eb),zeros(1,length(decnoise)))
title('Transmitted PBSK with noise')
xlim([-1.5 1.5])
xlabel('\phi_{1} normalised over sqrt (E_{b})')
%********************************************************
% PSD
figure
spec = spectrum.welch;
powersd= psd(spec,Tx,'Fs',bitsNo);
loglog(powersd.Data);
grid on 
title('PSD for BPSK')
%*******************************************************
%BER
errors=sum(abs(info-decision));% get the number of errors
errprob=errors/bitsNo;
BER=errprob/Tb;
disp(BER)
