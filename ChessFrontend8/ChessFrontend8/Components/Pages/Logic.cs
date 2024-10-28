

using Chess;

namespace ChessFrontend8.Components.Pages
{
    public class Logic
    {
        private readonly YourService _yourService; // Instance of YourService

        public Logic(HttpClient httpClient) // Inject HttpClient into Logic
        {
            _yourService = new YourService(httpClient); // Initialize YourService with HttpClient
        }



        public async Task<string> GetRatio(string FEN)
        {
            using (var httpClient = new HttpClient())
            {
                // Adjust the URL to match your API's address
               
                var response = await httpClient.GetAsync($"https://localhost:7076/api/GAMES/currposition?position={Uri.EscapeDataString(FEN)}");


                if (response.IsSuccessStatusCode)
                {
                    return await response.Content.ReadAsStringAsync();
                }
                else
                {
                    // Handle error
                    Console.WriteLine($"Error getting Ratio: {response.StatusCode}");
                    return string.Empty;
                }
            }
        }
        public async Task<string> FetchFEN(string moves)
        {
            using (var httpClient = new HttpClient())
            {
                // Adjust the URL to match your API's address
                var response = await httpClient.GetAsync($"https://localhost:7076/api/GAMES/FEN?moves={Uri.EscapeDataString(moves)}");

                if (response.IsSuccessStatusCode)
                {
                    return await response.Content.ReadAsStringAsync();
                }
                else
                {
                    // Handle error
                    Console.WriteLine($"Error fetching FEN: {response.StatusCode}");
                    return string.Empty;
                }
            }
        }







        // Public method to validate moves
        public async Task<bool> ValidateMove(string pgn)
        {
            return await _yourService.ValidateMove(pgn);
        }

        // Public method to log in a user
        public async Task<bool> Login(string username, string password)
        {
            return await _yourService.Login(username, password);
        }

        // Nested YourService class
        private class YourService // Made this private if it's only for Logic's use
        {
            private readonly HttpClient _httpClient;

            public YourService(HttpClient httpClient) // Inject HttpClient
            {
                _httpClient = httpClient;
            }

            public async Task<bool> ValidateMove(string pgn)
            {
                var url = $"https://localhost:7076/api/Games/Validator?moves={Uri.EscapeDataString(pgn)}";
                var response = await _httpClient.GetAsync(url);

                if (response.IsSuccessStatusCode)
                {
                    var result = await response.Content.ReadAsStringAsync();
                    return bool.Parse(result);
                }

                return false; // Handle error appropriately
            }

            // Method for logging in a user
            public async Task<bool> Login(string username, string password)
            {
                var loginRequest = new LoginRequest // Create the request object
                {
                    Username = username,
                    Password = password
                };

                var response = await _httpClient.PostAsJsonAsync("https://localhost:7076/api/UserAccount/login", loginRequest);

                return response.IsSuccessStatusCode; // Return true if login is successful
            }
        }
    }

    // Define LoginRequest class to represent the login request payload
    public class LoginRequest
    {
        public string Username { get; set; }
        public string Password { get; set; }
    }
}
