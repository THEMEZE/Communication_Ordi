#!/bin/bash

# Chemin vers le répertoire où vous souhaitez enregistrer les fichiers
directory="/Users/themezeguillaume/Desktop/Etude2023/PHD/Etudes/Ordi_Programmation/Communication_Internet"

# Conseils LaTeX
cat <<EOF > "$directory/Communication_Internet.tex"
%\documentclass{article}
%\usepackage[utf8]{inputenc}

%\title{Guide pour la Communication entre Deux Ordinateurs via un Réseau Wi-Fi}
%\date{}
%\begin{document}

%\maketitle

La communication entre deux ordinateurs via un réseau Wi-Fi est relativement simple, que ce soit pour le partage de fichiers, l'impression en réseau ou toute autre forme de communication. Voici les étapes générales pour établir une communication entre deux ordinateurs via un réseau Wi-Fi :

\begin{enumerate}
    \item \textbf{Assurez-vous que les deux ordinateurs sont connectés au même réseau Wi-Fi :}
    
    Vérifiez que les deux ordinateurs sont connectés au même réseau Wi-Fi. Vous devez connaître le nom du réseau (SSID) et le mot de passe si un mot de passe est nécessaire pour s'y connecter.
    
    \item \textbf{Obtenez les adresses IP des ordinateurs :}
    
    Chaque ordinateur doit avoir une adresse IP pour communiquer sur le réseau. Vous pouvez généralement laisser votre réseau attribuer automatiquement une adresse IP à chaque ordinateur (mode DHCP), ou vous pouvez configurer des adresses IP statiques si vous le préférez.
    
    \item \textbf{Partagez des fichiers (si nécessaire) :}
    
    Si vous souhaitez partager des fichiers entre les deux ordinateurs, assurez-vous que le partage de fichiers est activé. Sur Windows, vous pouvez utiliser le partage de fichiers SMB, tandis que sur Mac, vous pouvez utiliser le partage de fichiers via AFP ou SMB.
    
    \item \textbf{Utilisez des protocoles de communication :}
    
    Vous pouvez utiliser différents protocoles de communication pour échanger des données entre les ordinateurs, tels que HTTP pour la navigation sur le Web, FTP pour le transfert de fichiers, SSH pour un accès distant sécurisé, etc.
    
    \item \textbf{Configurer les pare-feu et la sécurité :}
    
    Assurez-vous que les pare-feu sur les deux ordinateurs permettent la communication sur le réseau Wi-Fi. Vous devrez peut-être ajouter des règles pour autoriser le trafic entrant et sortant.
    
    \item \textbf{Utilisez des applications ou des services adaptés à votre objectif :}
    
    Selon ce que vous souhaitez faire (partager des fichiers, imprimer en réseau, jouer à des jeux en réseau, etc.), vous devrez utiliser des applications ou des services spécifiques. Par exemple, pour le partage de fichiers, vous pouvez utiliser des applications telles que Dropbox, Google Drive, ou simplement le partage de fichiers du système d'exploitation.
    
    \item \textbf{Testez la communication :}
    
    Une fois que vous avez configuré tout ce qui est nécessaire, assurez-vous de tester la communication entre les deux ordinateurs pour vous assurer que tout fonctionne comme prévu.
\end{enumerate}

Gardez à l'esprit que les détails de la configuration peuvent varier en fonction du système d'exploitation que vous utilisez (Windows, macOS, Linux) et du but de la communication. Assurez-vous également de prendre en compte les questions de sécurité lors de la configuration d'une communication Wi-Fi, notamment en utilisant des mots de passe sécurisés pour le réseau Wi-Fi et en configurant correctement les pare-feu pour protéger vos ordinateurs contre les menaces en ligne.

\begin{lstlisting}[language=Matlab, caption={Programme MATLAB sur l'ordinateur A (l'émetteur)}]
% Adresse IP de l'ordinateur B (serveur)
ipServeur = 'adresse_ip_de_l_ordinateur_b'; % Remplacez par l'adresse IP réelle de l'ordinateur B
port = 12345; % Port sur lequel le serveur écoute

% Création d'un objet socket TCP/IP
clientSocket = tcpip(ipServeur, port);

% Ouvrir la connexion vers l'ordinateur B
fopen(clientSocket);

% Les données à envoyer
donneesAEnvoyer = 'Ceci est un exemple de données depuis l''ordinateur A';

% Envoyer les données
fwrite(clientSocket, donneesAEnvoyer);

% Fermer la connexion
fclose(clientSocket);

\end{lstlisting}


\begin{lstlisting}[language=Matlab, caption={Programme MATLAB sur l'ordinateur B (recever)}]

% Port sur lequel le serveur écoute
port = 12345;

% Création d'un objet socket TCP/IP côté serveur
serveurSocket = tcpip('0.0.0.0', port, 'NetworkRole', 'server');

% Attendre une connexion entrante
disp('En attente de connexion...');
fopen(serveurSocket);
disp('Connexion établie.');

% Lire les données reçues
donneesRecues = fread(serveurSocket, serveurSocket.BytesAvailable, 'char')';

% Afficher les données reçues
disp('Données reçues de l''ordinateur A :');
disp(donneesRecues);

% Fermer la connexion
fclose(serveurSocket);

\end{lstlisting}

%\end{document}



EOF
# Fin Latex

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
            IPAddress ipAddress = IPAddress.Parse("192.168.1.100");
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
            string serverIp = "192.168.1.100";
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
```

echo "Ce script Bash génère les fichiers source pour le serveur et le client en utilisant la redirection de texte (`cat <<EOL > NomDuFichier.cs`), puis les compile en exécutables C# à l'aide du compilateur Mono C# (`mcs`). Après avoir exécuté ce script, vous obtiendrez les fichiers `Server.cs`, `Client.cs`, `Server.exe`, et `Client.exe`. Vous pourrez ensuite exécuter ces exécutables pour démarrer le serveur et le client. Assurez-vous de modifier les adresses IP et les ports en fonction de votre configuration réseau."
