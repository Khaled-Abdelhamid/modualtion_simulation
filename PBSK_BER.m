function BER=PBSK_BER(Eb,N0)
bitsNo=50000;% the
info=randi([0,1],1,bitsNo);

Ts=.01;% smapling rate
Tb=1;%bit duration in seconds
Nc=2;
fc=Nc/Tb;

bit=0:Ts:Tb-Ts;%simulation of each bit

Ab=sqrt(Eb);%bit Amplitude

mean =0;

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

errors=sum(abs(info-decision));% get the number of errors
errprob=errors/bitsNo;
BER=errprob/Tb;



