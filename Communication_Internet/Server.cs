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

exit
