using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using IoTPetFeederDataManager.Models;
using Microsoft.AspNetCore.Authorization;

namespace IoTPetFeederDataManager.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FeedersController : ControllerBase
    {
        private readonly IoTPetFeederDbContext _context;

        public FeedersController(IoTPetFeederDbContext context)
        {
            _context = context;
        }

        [Authorize(Roles = "Admin")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Feeder>>> GetFeeders()
        {
            var feeders = await _context.Feeders
                .ToListAsync();

            int currentTimeUnix = (Int32)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;
            feeders.ForEach(f => f.CurrentTime = currentTimeUnix);

            return feeders;
        }

        [Authorize(Roles = "Admin,StandardUser,Feeder")]
        [HttpGet("{id}")]
        public async Task<ActionResult<Feeder>> GetFeeder(string id)
        {
            var feeder = await _context.Feeders
                .Where(f => f.FeederId == id)
                .FirstOrDefaultAsync();

            if (feeder == null)
            {
                return NotFound();
            }

            int currentTimeUnix = (Int32)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;

            feeder.CurrentTime = currentTimeUnix;

            return feeder;
        }

        [Authorize(Roles = "Admin,StandardUser,Feeder")]
        [HttpPut("{id}")]
        public async Task<IActionResult> PutFeeder(Guid id, Feeder feeder)
        {
            if (id != feeder.Id)
            {
                return BadRequest();
            }

            _context.Entry(feeder).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!FeederExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<ActionResult<Feeder>> PostFeeder(Feeder feeder)
        {
            _context.Feeders.Add(feeder);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetFeeder", new { id = feeder.Id }, feeder);
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<ActionResult<Feeder>> DeleteFeeder(int id)
        {
            var feeder = await _context.Feeders.FindAsync(id);
            if (feeder == null)
            {
                return NotFound();
            }

            _context.Feeders.Remove(feeder);
            await _context.SaveChangesAsync();

            return feeder;
        }

        private bool FeederExists(Guid id)
        {
            return _context.Feeders.Any(e => e.Id == id);
        }
    }
}
