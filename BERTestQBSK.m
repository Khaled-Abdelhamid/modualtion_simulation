clear
clc
close all
Eb=1;
N0=1;
size=10;
vec=[];

for i=1:.01:size
    N0=10^i*Eb;
    BER=QPSK_BER(Eb,N0);
    vec=[vec;Eb/N0 BER];
end
loglog(vec(:,1),vec(:,2),'r')
grid on
hold on
loglog(vec(:,1),erfc(sqrt(vec(:,1))),'b')
title('BER for QBSK')
xlabel('E_{b}/N_{0} (dB)')
ylabel('BERs')


