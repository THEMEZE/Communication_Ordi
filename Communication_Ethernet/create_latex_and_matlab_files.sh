#!/bin/bash

# Chemin vers le répertoire où vous souhaitez enregistrer les fichiers
directory="/Users/themezeguillaume/Desktop/Etude2023/PHD/Etudes/Ordi_Programmation/Communication_Ethernet"

# Conseils LaTeX
cat <<EOF > "$directory/Communication_Ethernet.tex"
%\documentclass{article}
%\usepackage{listings} % Pour afficher du code MATLAB
%\usepackage{color}    % Pour la coloration syntaxique du code

%\begin{document}

%\title{Conseils pour utiliser MATLAB}
%\author{Votre nom}
%\date{\today}
%\maketitle

\section{Matériel nécessaire :}
\begin{enumerate}
    \item Deux ordinateurs équipés de ports Ethernet (RJ45).
    \item Un câble Ethernet, généralement de type Cat5e ou Cat6, pour connecter les deux ordinateurs.
\end{enumerate}

\section{Étapes à suivre :}
\begin{enumerate}
    \item \textbf{Configurer les adresses IP :} Pour permettre la communication entre les deux ordinateurs, il est nécessaire d'attribuer des adresses IP statiques à chacun dans le même sous-réseau. Par exemple, si vous utilisez l'adresse IP \texttt{192.168.1.2} pour l'ordinateur A, utilisez \texttt{192.168.1.3} pour l'ordinateur B. Assurez-vous également d'utiliser le même masque de sous-réseau, par exemple, \texttt{255.255.255.0}.

    \item \textbf{Connectez les ordinateurs :} Branchez une extrémité du câble Ethernet dans le port Ethernet de l'ordinateur A et l'autre extrémité dans le port Ethernet de l'ordinateur B.

    \item \textbf{Configurer les pare-feux :} Assurez-vous que les pare-feux des deux ordinateurs autorisent la communication via le réseau local. Il peut être nécessaire d'ajouter une règle pour permettre le trafic entre les adresses IP des deux ordinateurs.

    \item \textbf{Développer le programme MATLAB :} Écrivez un programme MATLAB sur l'ordinateur A pour collecter les informations que vous souhaitez transférer vers l'ordinateur B. MATLAB offre des fonctionnalités de communication réseau, telles que les sockets, que vous pouvez utiliser pour envoyer des données.
    
\begin{lstlisting}[language=Matlab, caption={Programme MATLAB sur l'ordinateur A (l'émetteur)}]
% Adresse IP de l'ordinateur B
adresseIPB = '192.168.1.3'; % Remplacez par l'adresse IP de l'ordinateur B

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
fclose(clientSocket);
\end{lstlisting}

\begin{lstlisting}[language=Python, caption={Programme Python sur l'ordinateur A (l'émetteur)}]
import socket

# Adresse IP de l'ordinateur B
adresseIPB = '192.168.1.3'  # Remplacez par l'adresse IP de l'ordinateur B
portB = 12345  # Remplacez par le port approprié sur l'ordinateur B

# Créer des données à envoyer
donnees = [1, 2, 3, 4, 5]

# Créer une socket TCP/IP
clientSocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Établir la connexion vers l'ordinateur B
clientSocket.connect((adresseIPB, portB))

# Envoyer des données
donnees_envoyees = bytearray()
for valeur in donnees:
    donnees_envoyees.extend(valeur.to_bytes(8, byteorder='big'))  # Convertir en octets (8 bytes par valeur)

clientSocket.sendall(donnees_envoyees)

# Fermer la connexion
clientSocket.close()
\end{lstlisting}


    \item \textbf{Programme sur l'ordinateur B :} Rédigez un programme sur l'ordinateur B qui attend de recevoir les données de l'ordinateur A. Ce programme doit également utiliser des sockets pour écouter les connexions entrantes.
    
\begin{lstlisting}[language=Matlab, caption={Programme MATLAB sur l'ordinateur B (le récepteur)}]
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
\end{lstlisting}

\begin{lstlisting}[language=Python, caption={Programme Python sur l'ordinateur B (le récepteur)}]
import socket

# Port sur lequel l'ordinateur B écoute
portB = 12345  # Remplacez par le port approprié

# Adresse IP à écouter (0.0.0.0 signifie toutes les interfaces)
adresseIP = '0.0.0.0'

# Créer une socket TCP/IP en attente
serveurSocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
serveurSocket.bind((adresseIP, portB))
serveurSocket.listen(1)  # Attendre au maximum une connexion

print(f"En attente de connexion sur le port {portB}...")

# Accepter la connexion entrante
clientSocket, clientAdresse = serveurSocket.accept()
print(f"Connexion acceptée depuis {clientAdresse}")

# Recevoir les données de l'ordinateur A
donneesRecues = clientSocket.recv(1024)  # Utilisez une taille de tampon appropriée
print("Données reçues :", donneesRecues.decode())

# Fermer la connexion
clientSocket.close()
serveurSocket.close()
\end{lstlisting}




    \item \textbf{Transfert de données :} Dans le programme MATLAB de l'ordinateur A, utilisez la connexion réseau pour envoyer les données à l'ordinateur B. Dans le programme de l'ordinateur B, recevez et traitez les données reçues.

    \item \textbf{Gestion des erreurs et de la sécurité :} Assurez-vous de prendre en charge la gestion des erreurs de communication et ajoutez des mécanismes de sécurité si nécessaire, notamment le chiffrement des données si vous travaillez avec des informations sensibles.

    \item \textbf{Testez la communication :} Exécutez les deux programmes sur les ordinateurs A et B et vérifiez que les données sont correctement transférées.
\end{enumerate}


%\end{document}

EOF
# Fin des conseils LaTeX

# Programme MATLAB
cat <<EOF > "$directory/programme_matlab_A.m"
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
pause(0.0001)

% Envoyer des données
fwrite(clientSocket, donnees, 'double');

% Fermer la connexion
fclose(clientSocket)

EOF
# Fin Programme MATLAB

# Programme Python
cat <<EOF > "$directory/programme_matlab_A.py"
import socket

# Adresse IP de l'ordinateur B
adresseIPB = '127.0.0.1'  # Remplacez par l'adresse IP de l'ordinateur B
portB = 12345  # Remplacez par le port approprié sur l'ordinateur B

# Créer des données à envoyer
donnees = [1, 2, 3, 4, 5]

# Créer une socket TCP/IP
clientSocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Établir la connexion vers l'ordinateur B
clientSocket.connect((adresseIPB, portB))

# Envoyer des données
donnees_envoyees = bytearray()
for valeur in donnees:
    donnees_envoyees.extend(valeur.to_bytes(8, byteorder='big'))  # Convertir en octets (8 bytes par valeur)

clientSocket.sendall(donnees_envoyees)

# Fermer la connexion
clientSocket.close()

EOF
# Fin Programme Python

# Programme MATLAB
cat <<EOF > "$directory/programme_matlab_B.m"
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
EOF
# Fin du programme MATLAB

# Programme Python

cat <<EOF > "$directory/programme_matlab_B.py"
import socket

# Port sur lequel l'ordinateur B écoute
portB = 12345  # Remplacez par le port approprié

# Adresse IP à écouter (0.0.0.0 signifie toutes les interfaces)
adresseIP = '0.0.0.0'

# Créer une socket TCP/IP en attente
serveurSocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
serveurSocket.bind((adresseIP, portB))
serveurSocket.listen(1)  # Attendre au maximum une connexion

print(f"En attente de connexion sur le port {portB}...")

# Accepter la connexion entrante
clientSocket, clientAdresse = serveurSocket.accept()
print(f"Connexion acceptée depuis {clientAdresse}")

# Recevoir les données de l'ordinateur A
donneesRecues = clientSocket.recv(1024)  # Utilisez une taille de tampon appropriée
print("Données reçues :", donneesRecues.decode())

# Fermer la connexion
clientSocket.close()
serveurSocket.close()

EOF
# Fin du programme Pyton


echo "Fichiers créés avec succès dans le répertoire $directory."


# Créez le code source du serveur
cat <<EOL > Server.cs
using System;
using System.Net;
using System.Net.Sockets;
using System.Text;

class Server
{
    static void Main()
    {
        TcpListener server = null;

        try
        {
            IPAddress ipAddress = IPAddress.Parse("127.0.0.1");
            int port = 12345;

            server = new TcpListener(ipAddress, port);
            server.Start();

            Console.WriteLine("Serveur en attente de connexions...");

            while (true)
            {
                TcpClient client = server.AcceptTcpClient();
                Console.WriteLine("Client connecté!");
                HandleClient(client);
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Erreur: " + ex.Message);
        }
        finally
        {
            server?.Stop();
        }
    }

    static void HandleClient(TcpClient client)
    {
        NetworkStream stream = client.GetStream();
        byte[] buffer = new byte[1024];
        int bytesRead;

        while ((bytesRead = stream.Read(buffer, 0, buffer.Length)) > 0)
        {
            string data = Encoding.ASCII.GetString(buffer, 0, bytesRead);
            Console.WriteLine("Message reçu: " + data);
            byte[] response = Encoding.ASCII.GetBytes("Message reçu par le serveur.");
            stream.Write(response, 0, response.Length);
        }

        client.Close();
    }
}
EOL

# Créez le code source du client
cat <<EOL > Client.cs
using System;
using System.Net;
using System.Net.Sockets;
using System.Text;

class Client
{
    static void Main()
    {
        try
        {
            string serverIp = "127.0.0.1";
            int serverPort = 12345;

            TcpClient client = new TcpClient(serverIp, serverPort);
            Console.WriteLine("Connecté au serveur!");

            NetworkStream stream = client.GetStream();
            string message = "Hello, serveur!";
            byte[] data = Encoding.ASCII.GetBytes(message);
            stream.Write(data, 0, data.Length);

            data = new byte[1024];
            int bytesRead = stream.Read(data, 0, data.Length);
            string response = Encoding.ASCII.GetString(data, 0, bytesRead);
            Console.WriteLine("Réponse du serveur: " + response);

            client.Close();
        }
        catch (Exception ex)
        {
            Console.WriteLine("Erreur: " + ex.Message);
        }
    }
}
EOL

# Compilez le serveur et le client
mcs Server.cs -out:Server.exe
mcs Client.cs -out:Client.exe

echo "Les fichiers Server.cs, Client.cs, Server.exe et Client.exe ont été créés avec succès."

echo "Ce script Bash générera deux fichiers source, `Server.cs` et `Client.cs`, contenant respectivement le code du serveur et du client, puis les compilera en exécutables `Server.exe` et `Client.exe`. Assurez-vous de modifier l'adresse IP et le port dans le code client pour correspondre à ceux du serveur. Après avoir exécuté le script, vous pouvez exécuter les fichiers exécutables générés pour démarrer le serveur et le client."


