using System;
using BeefLibSetupHelper;

namespace Setup;

class Program
{
	public static void Main(String[] args)
	{
		CMake.CheckDeps!();
		CMake.ConfigureAndBuild(".");
	}
}