% Programme MATLAB sur l'ordinateur B (le récepteur)

% Port sur lequel l'ordinateur B écoute
portB = 12345; % Remplacez par le port approprié

% Ouvrir une connexion TCP/IP en attente
serveurSocket = tcpip('0.0.0.0', portB, 'NetworkRole', 'Server');
fopen(serveurSocket);

% Attendre les données de l'ordinateur A
donneesRecues = fread(serveurSocket, serveurSocket.BytesAvailable, 'double');

% Afficher les données reçues
disp('Données reçues :');
disp(donneesRecues);

% Fermer la connexion
fclose(serveurSocket);
