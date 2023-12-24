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

