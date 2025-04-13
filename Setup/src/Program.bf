using System;
using BeefLibSetupHelper;

namespace Setup;

class Program
{
	const String kTracyTag = "v0.11.1";
	const String kTracyRepo = "https://github.com/wolfpld/tracy";

	public static void Main(String[] args)
	{
		SetupHelper.CheckDeps!();

		SetupHelper.CloneOptions opts = .()
			{
				Url = kTracyRepo,
				CommitOrTag = kTracyTag
			};

		SetupHelper.CloneRepo(opts, "Tracy");
	}
}