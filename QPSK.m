clear
clc
close all

bitsNo=5;% the
info=randi([0,1],1,bitsNo);

Ts=.01;% smapling rate
Tb=1;%bit duration in seconds
Nc=2;
fc=Nc/Tb;

bit=0:Ts:Tb-Ts;%simulation of each bit

Eb=8;%energy per bit (those numbers are chosen to make calculations easier)
Ab=sqrt(Eb);%bit Amplitude

mean =0;
N0=10;
var=N0/2;

basis1=sqrt(2/Tb)*cos(2*pi*fc*bit);
basis2=sqrt(2/Tb)*sin(2*pi*fc*bit);

even=info(2:2:end);
odd=info(1:2:end);

Tx=[];
for i=1:bitsNo/2 %the loop of the sending
    inPhase=(-1)^(even(i)+1) * Ab *basis1;
    quadPhase=(-1)^(odd(i)+1) * Ab *basis2;
    Tx=[Tx inPhase+quadPhase];
end

AWGNnoise=sqrt(var)*rand(1,length(Tx))+mean;%adding AWGN to the channel
Txnoise=Tx+AWGNnoise;

plot(Tx)
figure
plot(Txnoise)

%*******************************************
% reciever
decision=zeros(1,bitsNo);

for i=0:bitsNo-1
    val=Txnoise(1+i*(Tb/Ts):(i+1)*(Tb/Ts));
    Rx=Ts*val*basis';
    decision(i+1)=(Rx>=0);
end

disp(sum((info-decision)==1))% get the number of errors
