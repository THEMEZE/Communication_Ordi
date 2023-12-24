% Programme MATLAB sur l'ordinateur A (l'émetteur)

% Adresse IP de l'ordinateur B
adresseIPB = '127.0.0.1'; % Remplacez par l'adresse IP de l'ordinateur B

% Port sur lequel l'ordinateur B écoute
portB = 12345; % Remplacez par le port approprié sur l'ordinateur B

% Créer des données à envoyer
donnees = [1, 2, 3, 4, 5];

% Ouvrir une connexion TCP/IP
clientSocket = tcpip(adresseIPB, portB);
fopen(clientSocket);

% Envoyer des données
fwrite(clientSocket, donnees, 'double');

% Fermer la connexion
fclose(clientSocket)

