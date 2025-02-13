clear
clc
close all

bitsNo=200;% the number of bits
info=randi([0,1],1,bitsNo); %the information vector

Ts=.001;% smapling rate
Tb=1;%bit duration in seconds
Nc=2;
fc=Nc/Tb;

bit=0:Ts:Tb-Ts;%simulation of each bit

Eb=8;%energy per bit (those numbers are chosen to make calculations easier)
Ab=sqrt(Eb);%bit Amplitude
Ac=sqrt(2/Tb);
mean =0;
N0=1000;
var=N0/2;

basis1=Ac*cos(2*pi*fc*bit);
basis2=Ac*sin(2*pi*fc*bit);

Tx=[];
%modulation
sbit=0:Ts:2*Tb-Ts;
for i=1:2:bitsNo-1
    if(info(i)==1 && info(i+1)==0)
        ind=1;
    elseif(info(i)==0 && info(i+1)==0)
        ind=2;
    elseif(info(i)==0 && info(i+1)==1)
        ind=3;
    else
        ind=4;
    end
    func= Ac*Ab*cos(2*pi*fc*sbit+(2*ind-1)*pi/4);
    Tx=[Tx func];
end
%plotting constellation
coord=[];
for i=0:2:bitsNo-1
    val=Tx(1+i*(Tb/Ts):(i+1)*(Tb/Ts));
    bas1=Ts*val*basis1';
    bas2=Ts*val*basis2';
    coord=[coord;bas1 bas2];
end
coord=coord/sqrt(Eb/2);
AWGNnoise=sqrt(var)*rand(1,length(Tx))+mean;%adding AWGN to the channel
Txnoise=Tx+AWGNnoise;
%********************************************
%reciever
coordnoise=[];
for i=0:2:bitsNo-1
    val=Txnoise(1+i*(Tb/Ts):(i+1)*(Tb/Ts));
    bas1=Ts*val*basis1';
    bas2=Ts*val*basis2';
    coordnoise=[coordnoise;bas1 bas2];
end
% decision making
coordnoise=coordnoise/sqrt(Eb/2);%normalizing to range form -1 to 1

fixedcoord=zeros(bitsNo/2,2);
for i=1:bitsNo/2
    if(coordnoise(i,1)>=0)
        fixedcoord(i,1)=1;
    else
        fixedcoord(i,1)=-1;
    end
    
    if(coordnoise(i,2)>=0)
        fixedcoord(i,2)=1;
    else
        fixedcoord(i,2)=-1;
    end
end


errorNo=round(sum(sum(abs(coord-fixedcoord))));
Pe=errorNo/bitsNo;
BER=Pe/Tb;
disp(BER)

%plotting
coors=[1 1;1 -1;-1 1;-1 -1];
scatter (coors(:,1),coors(:,2),250,'r','*')
grid on
hold on
scatter (coordnoise(:,1),coordnoise(:,2))
title('Transmitted QBSK constellation with noise')
xlim([-1.5 1.5])
ylim([-1.5 1.5])
xlabel('\phi_{1} normalised over sqrt (E_{b}/2)')
ylabel('\phi_{2} normalised over sqrt (E_{b}/2)')

%*******************************************
% %PSD
figure
spec = spectrum.welch;
Hpsd= psd(spec,Tx,'Fs',bitsNo);
loglog(Hpsd.Data);
grid on
title('PSD for QPSK')
