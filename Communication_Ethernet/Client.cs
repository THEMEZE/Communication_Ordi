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
