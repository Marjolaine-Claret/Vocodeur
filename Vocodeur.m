%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VOCODEUR : Programme principal r�alisant un vocodeur de phase 
% et permettant de :
%
% 1- modifier le tempo (la vitesse de "prononciation")
%   sans modifier le pitch (fr�quence fondamentale de la parole)
%
% 2- modifier le pitch 
%   sans modifier la vitesse 
%
% 3- "robotiser" une voix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% R�cup�ration d'un signal audio
%--------------------------------

 [y,Fs]=audioread('Diner.wav');   %signal d'origine
% [y,Fs]=audioread('Extrait.wav');   %signal d'origine
% [y,Fs]=audioread('Halleluia.wav');   %signal d'origine

% Remarque : si le signal est en st�r�o, ne traiter qu'une seule voie � la
% fois
y = y(:,1);

% Courbes (�volution au cours du temps, spectre et spectrogramme)
%--------
% Ne pas oublier de cr�er les vecteurs temps, fr�quences...
N = length(y);
t = [0:N-1]/Fs;
f = [0:N-1]*Fs/N; f = f-Fs/2;
Y = fftshift(abs((1/N)*fft(y)));

%evolution temporelle
figure(1)
plot(t,y)
title('�volution temporelle signal initial')

%spectre
Nifreq = round(N/2); Nffreq =round((5000*N/Fs)+(N/2));
figure(2),
plot(f(Nifreq:Nffreq),Y(Nifreq:Nffreq))
xlim([0 5000])
title('spectre signal initial')

%spectrogramme
figure(3)
spectrogram(y,128,120,128,Fs,'yaxis');
title('spectrogrammes signal initial')




% Ecoute
%-------

soundsc(y,Fs)

% %%
% %-------------------------------
% % 1- MODIFICATION DE LA VITESSE
% % (sans modification du pitch)
% %-------------------------------
% % PLUS LENT
% rapp = 2/3;   %peut �tre modifi�
% ylent = PVoc(y,rapp,1024); 
% 
% % Ecoute
% %-------
% % A FAIRE !
% 
% pause
% soundsc(ylent,Fs)
% 
% %%
% % Courbes
% %--------
% % A FAIRE !
% Nlent = length(ylent);
% tlent = [0:Nlent-1]/Fs;
% flent = [0:Nlent-1]*Fs/Nlent; flent = flent-Fs/2;
% Ylent = fftshift(abs((1/Nlent)*fft(ylent)));
% 
% %evolution temporelle
% figure(11)
% plot(tlent,ylent)
% title('�volution temporelle vitesse lente')
% 
% 
% %spectre
% Nifreq = round(Nlent/2); Nffreq =round((4999*Nlent/Fs)+(Nlent/2));
% figure(12)
% plot(flent(Nifreq:Nffreq),Ylent(Nifreq:Nffreq))
% xlim([0 5000])
% title('spectre vitesse lente')
% 
% %spectrogramme
% figure(13)
% spectrogram(ylent,128,120,128,Fs,'yaxis');
% title('spectrogramme vitesse lentes')
% 
% %
% % PLUS RAPIDE
% rapp = 4/2;   %peut �tre modifi�
% yrapide = PVoc(y,rapp,1024); 
% 
% 
% % Ecoute 
% %-------
% pause
% soundsc(yrapide,Fs)
% 
% 
% % Courbes
% %--------
% Nrapide = length(yrapide);
% trapide = [0:Nrapide-1]/Fs;
% frapide = [0:Nrapide-1]*Fs/Nrapide; frapide = frapide-Fs/2;
% Yrapide = fftshift(abs((1/Nrapide)*fft(yrapide)));
% 
% %evolution temporelle
% figure(1)
% plot(trapide,yrapide)
% title('�volution temporelle vitesse rapide')
% 
% %spectre
% Nifreq = round(Nrapide/2); Nffreq =round((4999*Nrapide/Fs)+(Nrapide/2));
% figure(2),
% plot(frapide(Nifreq:Nffreq),Yrapide(Nifreq:Nffreq))
% xlim([0 5000])
% title('spectre vitesse rapide')
% 
% %spectrogramme
% figure(3)
% spectrogram(yrapide,128,120,128,Fs,'yaxis');
% title('spectrogrammes vitesse rapide')

%%
%----------------------------------
% 2- MODIFICATION DU PITCH
% (sans modification de vitesse)
%----------------------------------
% Param�tres g�n�raux:
%---------------------
% Nombre de points pour la FFT/IFFT
Nfft = 256;

% Nombre de points (longueur) de la fen�tre de pond�ration 
% (par d�faut fen�tre de Hanning)
Nwind = Nfft;


% Augmentation 
%--------------
a = 1;  b = 5;  %peut �tre modifi�
yvoc = PVoc(y, a/b,Nfft,Nwind);


% R�-�chantillonnage du signal temporel afin de garder la m�me vitesse
ypitch = resample(yvoc, a, b); 


%Somme de l'original et du signal modifi�
%Attention : on doit prendre le m�me nombre d'�chantillons
%Remarque : vous pouvez mettre un coefficient � ypitch pour qu'il
%intervienne + ou - dans la somme...
plot(y)
hold on
plot(ypitch)
hold off
Npitch = length(ypitch);
N = min(Npitch, length(y));
y1 = y(1:N);
coeff = 0.5;
ypitch1 = ypitch(1:N);
som = y1 + coeff*ypitch1;

% Ecoute
%-------
pause
soundsc(som,Fs)

% Courbes
%--------
Npitch = length(som);
tpitch = [0:Npitch-1]/Fs;
fpitch = [0:Npitch-1]*Fs/Npitch; fpitch = fpitch-Fs/2;
SUMpitch = fftshift(abs((1/Npitch)*fft(som)));

%evolution temporelle
figure(1)
plot(tpitch,som)
title('�volution temporelle pitch')

%spectre
Nifreq = round(Npitch/2); Nffreq =round((4999*Npitch/Fs)+(Npitch/2));
figure(2),
plot(fpitch(Nifreq:Nffreq),SUMpitch(Nifreq:Nffreq))
xlim([0 5000])
title('spectre pitch')

%spectrogramme
figure(3)
spectrogram(som,128,120,128,Fs,'yaxis');
title('spectrogrammes pitch')


% 
% %Diminution 
% %------------
% 
% a = 3;  b = 2;   %peut �tre modifi�
% yvoc = PVoc(y, a/b,Nfft,Nwind); 
% 
% % R�-�chantillonnage du signal temporel afin de garder la m�me vitesse
% ypitch = resample(yvoc,t,Fs); 
% 
% %Somme de l'original et du signal modifi�
% %Attention : on doit prendre le m�me nombre d'�chantillons
% %Remarque : vous pouvez mettre un coefficient � ypitch pour qu'il
% %intervienne + ou - dans la somme...
% Npitch = length(ypitch);
% N;
% som = ypitch + y;
% 
% % Ecoute
% %-------
% pause
% soundsc(som,Fs)
% 
% % Courbes
% %--------
% Npitch = length(som);
% tpitch = [0:Npitch-1]/Fs;
% fpitch = [0:Npitch-1]*Fs/Npitch; fpitch = fpitch-Fs/2;
% SUMpitch = fftshift(abs((1/Npitch)*fft(som)));
% 
% %evolution temporelle
% figure(1)
% plot(tpitch,som)
% title('�volution temporelle pitch')
% 
% %spectre
% Nifreq = round(Npitch/2); Nffreq =round((4999*Npitch/Fs)+(Npitch/2));
% figure(2),
% plot(fpitch(Nifreq:Nffreq),SUMpitch(Nifreq:Nffreq))
% xlim([0 5000])
% title('spectre pitch')
% 
% %spectrogramme
% figure(3)
% spectrogram(som,128,120,128,Fs,'yaxis');
% title('spectrogrammes pitch')
% 



%%
%----------------------------
% 3- ROBOTISATION DE LA VOIX
%-----------------------------
% Choix de la fr�quence porteuse (2000, 1000, 500, 200)
Fc = 500;   %peut �tre modifi�

yrob = Rob(y,Fc,Fs);

% Ecoute
%-------
pause
soundsc(yrob,Fs)

% Courbes
%-------------
% A FAIRE !

