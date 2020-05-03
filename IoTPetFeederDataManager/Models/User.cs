using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace IoTPetFeederDataManager.Models
{
    public class User
    {
        [Key]
        public Guid Id { get; set; }
        [Required]
        public string EmailAddress { get; set; }
        [Required]
        public string Password { get; set; }
        public Role Role { get; set; }
        public string Token { get; set; }
        public virtual ICollection<Feeder> Feeders { get; set; }
    }
}
