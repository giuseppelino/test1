
namespace EventsSample.Authentication
{
    /*
    authuser	Request for user sign-in authentication
    code	An OAuth2 authorization code generated by Google
    hd	The hosted domain of the user account
    prompt	User consent dialog
    scope	Space separated list of one or more OAuth2 scopes to be authorized
    state	CRSF state variable
    */   
    public class AuthCodeResponse
    {
        public string authuser { get; set; }
        public string code { get; set; }
        public string hd { get; set; }
        public string prompt { get; set; }
        public string scope { get; set; }
        public string state { get; set; }
    }
}
