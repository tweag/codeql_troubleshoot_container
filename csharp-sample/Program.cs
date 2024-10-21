using System;
using System.Data.SqlClient;

namespace csharp
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Enter your username:");
            string username = Console.ReadLine();

            // Vulnerable SQL query with string concatenation
            string query = "SELECT * FROM Users WHERE Username = '" + username + "'";

            using (SqlConnection connection = new SqlConnection("your_connection_string"))
            {
                SqlCommand command = new SqlCommand(query, connection);
                connection.Open();

                SqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    Console.WriteLine(reader["Username"]);
                }
            }

            Console.WriteLine("Query executed: " + query);
        }
    }
}