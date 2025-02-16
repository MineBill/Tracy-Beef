# Tracy-Beef

Incomplete (missing GPU stuff) Beef bindings for the Tracy profiler.

## Get Started
You can use the handy mixins that mimic the C++ macros:
```beef
using System;
using Tracy;

namespace Codegen;

class Program
{
	public static void Main()
	{
		while (true)
		{
			System.Threading.Thread.Sleep(100);
			Tracy.Zone!();
			{
				Tracy.ZoneN!("My cool zone");
				let a = 2;
			}
			Tracy.EmitFrameMark(null);
		}
	}
}
```
Or use the `Zone` class:
```beef
scope Zone(true, depth: 5)..Color(.Green)..Name("Zone Name");
```
Or use the bindings directly and build your own abstractions!

## Building the native library
The native `TracyClient` library is checked into the repo for convenience and (should) be kept up to date with Tracy.

If however you want to build it your self, you can follow these steps:

`$ cmake -S . -B cmake-build`

`$ cmake --build cmake-build --config Debug # for debug`

`$ cmake --build cmake-build --config Release # for release`