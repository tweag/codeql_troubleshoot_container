using Microsoft.EntityFrameworkCore;

namespace CodeQLTestApp
{
    public class SampleDbContext : DbContext
    {
        public DbSet<SampleEntity> Entities { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder options)
            => options.UseInMemoryDatabase("TestDB");
    }
}