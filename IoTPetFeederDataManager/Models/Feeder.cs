using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace IoTPetFeederDataManager.Models
{
    public class Feeder
    {
        [Key]
        public Guid Id { get; set; }
        [Required]
        public string FeederId { get; set; }
        public int FeedOverride { get; set; } = 0;
        public int FeedCount { get; set; } = 0;
        public int CurrentTime { get; set; }
        public int NumberOfFeedTimes { get; set; }
        public string FeedTimes { get; set; }
    }
}
