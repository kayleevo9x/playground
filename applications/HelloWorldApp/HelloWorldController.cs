using Microsoft.AspNetCore.Mvc;

public class HelloWorldController : Controller
{
    public IActionResult Index()
    {
        return View();
    }
}