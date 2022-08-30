# Matlab'de excel dosyasindan (.xlsx) odyogram cizdirme
University of Groningen/University Medical Center Groningen
PhD student Soner Turudu

Oncelikle calistirmak icin "Home-Add Ons" kismindan 'Financial Toolbox' indirilmesi gerekiyor. 
Cunku NaN verilerin (excel dosyasinda karsiligi olmayan) ortalama ve
standart sapma hesaplamalarinda normal std ve mean komutlarini
kullanmiyoruz

Kullanilan argumanlar:
nplots: bir grafik mi cizdirecegiz, yoksa iki tane mi? Eger degerini 1
olarak atarsak, bir grafikte 2 sekli (sag ve sol) birden cizdirecek; eger degerini 2
olarak atarsak, iki ayri grafikte 2 sekli cizdirecek.

plotindv: eger her katilimciya ait odyogram verilerini gormek
istiyorsak bu komutu 1 olarak atayabiliriz. Eger 0 yaparsak herhangi
bir katilimciya ait veriler cizdirilmeyecek.

errbartype: eger bu degeri 0 olarak atarsak SEM (ortalamanin standart
hatasi) ya da SD (standart sapma) verileri cizdirilmeyecek. Eger 1
olarak atarsak ortalama ve SD cizdirilirken; 2 olarak atarsak ortalama
ve SEM verileri cizdirilmis olur.

Ornek kullanima bakarsak;
asagidaki komut penceresinde " odyogram_cizdirme(2,1,2) yazarsak
nplots:2, plotindv:1, errbartype:2 olarak ayarlamis olacagiz. Yani 2
ayri grafik cizdirecegiz; bu grafiklerde her katilimciya ait veri
olacak; ortalama ve SEM gosterilecek.
  
https://github.com/SonerTrd
reference: https://github.com/bcm9
