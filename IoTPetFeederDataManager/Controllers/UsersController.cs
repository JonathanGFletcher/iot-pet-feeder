using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using IoTPetFeederDataManager.Models;
using System.IdentityModel.Tokens.Jwt;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.Options;

namespace IoTPetFeederDataManager.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly IoTPetFeederDbContext _context;
        private readonly JwtSettings _jwtSettings;

        public UsersController(IoTPetFeederDbContext context, IOptions<JwtSettings> jwtSettings)
        {
            _context = context;
            _jwtSettings = jwtSettings.Value;
        }

        [Authorize(Roles = "Admin")]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<User>>> GetUsers()
        {
            return await _context.Users
                .Include(u => u.Role)
                .Include(u => u.Feeders)
                .ToListAsync();
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("{id}")]
        public async Task<ActionResult<User>> GetUser(Guid id)
        {
            var user = await _context.Users
                .Include(u => u.Role)
                .Include(u => u.Feeders)
                .Where(u => u.Id == id)
                .FirstOrDefaultAsync();

            if (user == null)
            {
                return NotFound();
            }

            return user;
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> PutUser(Guid id, User user)
        {
            if (id != user.Id)
            {
                return BadRequest();
            }

            _context.Entry(user).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UserExists(id))
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
        public async Task<ActionResult<User>> PostUser(User user)
        {
            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetUser", new { id = user.Id }, user);
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<ActionResult<User>> DeleteUser(Guid id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
            {
                return NotFound();
            }

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();

            return user;
        }

        [HttpPost("Register")]
        public async Task<ActionResult<User>> Register([FromBody] User user)
        {
            var existingUser = await _context.Users
                .Include(u => u.Role)
                .Include(u => u.Feeders)
                .Where(u => u.EmailAddress == user.EmailAddress)
                .FirstOrDefaultAsync();

            if (existingUser != null)
            {
                if (user.Password == existingUser.Password)
                {
                    return existingUser;
                }
                else
                {
                    return BadRequest("Invalid password.");
                }
            }

            // Override new user role to be StandardUser

            var standardRole = await _context.Roles
                .Where(r => r.Id == 2)
                .FirstOrDefaultAsync();

            user.Role = standardRole;

            // Signing token

            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_jwtSettings.SecretKey);

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[]
                {
                    new Claim(ClaimTypes.Name, user.EmailAddress),
                    new Claim(ClaimTypes.Role, user.Role.Name)
                }),
                Expires = DateTime.UtcNow.AddMonths(6),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };

            var token = tokenHandler.CreateToken(tokenDescriptor);
            user.Token = tokenHandler.WriteToken(token);

            _context.Users.Add(user);

            await _context.SaveChangesAsync();

            return user;
        }

        [Authorize(Roles = "Admin,StandardUser")]
        [HttpPut("AddFeeder/{id}")]
        public async Task<IActionResult> AddFeederForUser(Guid id, [FromBody] Feeder feeder)
        {
            if (UserExists(id))
            {
                var existingFeeder = await _context.Feeders
                    .Where(f => f.Id == feeder.Id)
                    .FirstOrDefaultAsync();

                if (existingFeeder == null)
                {
                    var user = await _context.Users
                        .Include(u => u.Feeders)
                        .Where(u => u.Id == id)
                        .FirstOrDefaultAsync();

                    user.Feeders.Add(feeder);

                    try
                    {
                        _context.Update(user);
                        await _context.SaveChangesAsync();
                    }
                    catch (Exception)
                    {
                        return BadRequest("Failed to add feeder.");
                    }
                }
                else
                {
                    return BadRequest("Feeder already exists.");
                }
            }
            else
            {
                return NotFound("User not found.");
            }

            return Ok("Successfully added feeder.");
        }

        [Authorize(Roles = "Admin,StandardUser")]
        [HttpPut("RemoveFeeder/{id}/{feederId}")]
        public async Task<IActionResult> RemoveFeederFromUser(Guid id, Guid feederId)
        {
            if (UserExists(id))
            {
                var existingFeeder = await _context.Feeders
                    .Where(f => f.Id == feederId)
                    .FirstOrDefaultAsync();

                if (existingFeeder != null)
                {
                    var user = await _context.Users
                        .Include(u => u.Feeders)
                        .Where(u => u.Id == id)
                        .FirstOrDefaultAsync();

                    user.Feeders.Remove(existingFeeder);

                    try
                    {
                        _context.Update(user);
                        await _context.SaveChangesAsync();
                    }
                    catch (Exception)
                    {
                        return BadRequest("Failed to remove feeder.");
                    }
                }
                else
                {
                    return NotFound("Feeder not found.");
                }
            }
            else
            {
                return NotFound("User not found.");
            }

            return Ok("Successfully removed feeder.");
        }

        private bool UserExists(Guid id)
        {
            return _context.Users.Any(e => e.Id == id);
        }
    }
}
