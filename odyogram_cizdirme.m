function [data] = odyogram_cizdirme(nplot,plotindv,errbartype)
% Matlab'de excel dosyasindan (.xlsx) odyogram cizdirme
% University of Groningen/University Medical Center Groningen
% PhD student Soner Turudu
% 
% Oncelikle calistirmak icin "Home-Add Ons" kismindan 'Financial Toolbox' indirilmesi gerekiyor. 
% Cunku NaN verilerin (excel dosyasinda karsiligi olmayan) ortalama ve
% standart sapma hesaplamalarinda normal std ve mean komutlarini
% kullanmiyoruz
% 
% Kullanilan argumanlar:
%   nplots: bir grafik mi cizdirecegiz, yoksa iki tane mi? Eger degerini 1
%   olarak atarsak, bir grafikte 2 sekli (sag ve sol) birden cizdirecek; eger degerini 2
%   olarak atarsak, iki ayri grafikte 2 sekli cizdirecek.
%   
%   plotindv: eger her katilimciya ait odyogram verilerini gormek
%   istiyorsak bu komutu 1 olarak atayabiliriz. Eger 0 yaparsak herhangi
%   bir katilimciya ait veriler cizdirilmeyecek.
%
%   errbartype: eger bu degeri 0 olarak atarsak SEM (ortalamanin standart
%   hatasi) ya da SD (standart sapma) verileri cizdirilmeyecek. Eger 1
%   olarak atarsak ortalama ve SD cizdirilirken; 2 olarak atarsak ortalama
%   ve SEM verileri cizdirilmis olur.
%
%   Ornek kullanima bakarsak;
%   asagidaki komut penceresinde " plot_audiogram(2,1,2) yazarsak
%   nplots:2, plotindv:1, errbartype:2 olarak ayarlamis olacagiz. Yani 2
%   ayri grafik cizdirecegiz; bu grafiklerde her katilimciya ait veri
%   olacak; ortalama ve SEM gosterilecek.
%   
%   https://github.com/SonerTrd
%   reference: https://github.com/bcm9

%% Default if no arguments 
if nargin<1
    nplot=2;
    errbartype=2;
    plotindv=1;
end

%% Load data from excel spreadsheet
% user selects excel file
disp('Odyogram verisetini seciniz .xlsx file')
[file,path] = uigetfile('*.xlsx',...
    'Odyogram verisetini seciniz .xlsx file', ...
    'MultiSelect', 'off');
data=readtable([path,file],'ReadRowNames',false,'ReadVariableNames',true);

% burada oncelikle verisetini cektik, simdi ise verileri temizleyip sadece
% sayisal degerleri alacagiz ve leftdBHL, rightdBHL olarak isimlendirecegiz
% daha sonra errbartype ile hangi degerleri atayinca hangi hesaplamalari
% yapacagini kodluyoruz

% count nfreqs tested
nfreqs=size(data,2)-2;
% extract freq strings from table
freq_string=data.Properties.VariableNames(3:end);
% remove x's from strings
freq_string=erase(freq_string,"x");
% organize thresholds
leftdBHL=table2array(data(1:2:end,3:end));
rightdBHL=table2array(data(2:2:end,3:end));
% calculate error
if errbartype==0
    errL=NaN(1,nfreqs);
    errR=NaN(1,nfreqs);
 elseif errbartype==1
    errL=nanstd(leftdBHL);
    errR=nanstd(rightdBHL);
 elseif errbartype==2
    errL=nanstd(leftdBHL)/sqrt(length(leftdBHL));
    errR=nanstd(rightdBHL)/sqrt(length(rightdBHL));
end
% set plotting parameters
markersize=8; %sekildeki isaretlerin boyutu ayarlaniyor
fsize=13; %karakterlerin boyutu ayarlaniyor

%% Plot data, single plot
if nplot==1 %eger sadece 1 sekil cizdirmek istiyorsak
    figure('position',[300 300 500 500],'paperpositionmode','auto');
    % plot left
    errorbar(1:nfreqs,nanmean(leftdBHL),errL,'b-x','LineWidth',1.5,'MarkerSize',markersize)
    % b-x ile mavi (blue/b) ve x (sol kulak) isareti yapmis oluyoruz
    hold on
    % plot right
    errorbar(1:nfreqs,nanmean(rightdBHL),errR,'r-o','LineWidth',1.5,'MarkerSize',markersize)
    % r-o ile kirmizi (red/r) ve o (sag kulak) isareti yapmis oluyoruz
    % plot individual data
    if plotindv==1
        plot(1:nfreqs,leftdBHL,'k--','MarkerSize',markersize)
    % k-- ile her katilimciya ait verileri siyah ile gosteriyoruz
        plot(1:nfreqs,rightdBHL,'k-.','MarkerSize',markersize)
    end
    set(gca, 'YDir','reverse')
    % yukaridaki satirda verileri ters ceviriyoruz, odyogram ozelliginden
    % dolayi
    grid on
    axis square
    yticks(-20:10:120)
    % yticks ile y ekseninde gorulecek degerleri goruyoruz. -20 ile
    % baslamis, 10'ar 10'ar buyuyerek 120'ye kadar gitmis. Eger y ekseninde
    % 15 20 25 seklinde gitsin istersen yticks(-20:5:120) seklinde
    % duzenleyebiliriz.
    ylim([-15 115]) 
    % ylim ile grafigin y ekseninde sinirlarini belirliyoruz. -15 yapinca
    % -20'ye ait deger gorunmeyecek. Ancak ylim([10 115]) olarak ayarlarsak
    % da bu sefer bir katilimcida eger -5 dB de deger varsa, o
    % gorunmeyecek.
    xlim([0 nfreqs+1])
    xticks([1:nfreqs])
    xticklabels(freq_string)
    set(gca, 'XAxisLocation', 'bottom')
    xlabel('\itFREQUENCY \rm(kHz)','FontSize',fsize)
    ylabel('\itPURE-TONE THRESHOLD \rm(dB HL)','FontSize',fsize)
    % bf ile bold font yaptik, italik yapmak istersek 'it'; normal yapmak
    % istersek de 'rm' olarak kullanabiliriz.
    %% Plot data, subplots
elseif nplot==2 % eger 2 sekil birden cizdirmek istiyorsak
    figure('position',[300 300 900 400],'paperpositionmode','auto');
    subplot(1,2,1)
    % plot left
    errorbar(1:nfreqs,nanmean(leftdBHL),errL,'b--x','LineWidth',1.5,'MarkerSize',markersize)
    hold on
    % plot individual data
    if plotindv==1
        plot(1:nfreqs,leftdBHL,'k--','MarkerSize',markersize)
    end
    set(gca, 'YDir','reverse')
    grid on
    axis square
    yticks(-20:10:120)
    ylim([-15 115]) 
    xlim([0 nfreqs+1])
    xticks([1:nfreqs])
    xticklabels(freq_string)
    set(gca, 'XAxisLocation', 'bottom')
    xlabel('\itFREQUENCY \rm(kHz)','FontSize',fsize)
    ylabel('\itPURE-TONE THRESHOLD \rm(dB HL)','FontSize',fsize)
    % plot right
    subplot(1,2,2)
    errorbar(1:nfreqs,nanmean(rightdBHL),errR,'r-o','LineWidth',1.5,'MarkerSize',markersize)
    hold on
    % plot individual data
    if plotindv==1
        plot(1:nfreqs,rightdBHL,'k-.','MarkerSize',markersize)
    end
    set(gca, 'YDir','reverse')
    grid on
    axis square
    yticks(-20:10:120) 
    ylim([-15 115]) 
    xlim([0 nfreqs+1])
    xticks([1:nfreqs])
    xticklabels(freq_string)
    set(gca, 'XAxisLocation', 'bottom')
    xlabel('\itFREQUENCY \rm(kHz)','FontSize',fsize)
    ylabel('\itPURE-TONE THRESHOLD \rm(dB HL)','FontSize',fsize)
end
end
