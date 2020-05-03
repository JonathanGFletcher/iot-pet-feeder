using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace IoTPetFeederDataManager.Models
{
    public class UserWithToken : User
    {
        public string AccessToken { get; set; }
        public string RefreshToken { get; set; }

        public UserWithToken(User user)
        {
            this.Id = user.Id;
            this.EmailAddress = user.EmailAddress;
            this.Password = user.Password;
            this.Feeders = user.Feeders;
        }
    }
}
