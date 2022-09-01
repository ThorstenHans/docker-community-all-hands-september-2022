using System.IO;
using Microsoft.AspNetCore.Mvc;

namespace ThorstenHans.SampleApi.Controllers;

[ApiController]
[Route("/demo")]
public class DemoController : ControllerBase
{
    private readonly ILogger<DemoController> _logger;

    public DemoController(ILogger<DemoController> logger)
    {
        _logger = logger;
    }

    [HttpGet("hello")]
    public IActionResult Hello()
    {
        return Ok("Hello Community All-Hands!");
    }

    [HttpPost("write")]
    public IActionResult Write([FromBody] string message)
    {
        var fileName = Path.GetRandomFileName();
        System.IO.File.WriteAllText(Path.Combine(".", "out", fileName ), message);
        return Ok(new { fileName });
    }
}
