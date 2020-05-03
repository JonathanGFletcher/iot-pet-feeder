using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;

namespace IoTPetFeederDataManager.Models
{
    public class IoTPetFeederDbContext : DbContext
    {
        public IoTPetFeederDbContext(DbContextOptions<IoTPetFeederDbContext> options) : base(options)
        {

        }

        public DbSet<User> Users { get; set; }
        public DbSet<Role> Roles { get; set; }
        public DbSet<Feeder> Feeders { get; set; }
    }
}
