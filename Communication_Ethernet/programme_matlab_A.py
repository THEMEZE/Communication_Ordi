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

