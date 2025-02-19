using System;

namespace Tracy;
public class Zone
{
	private CZoneContext m_Ctx;

	public this(bool active, int depth, String fileName = Compiler.CallerFileName, int line = Compiler.CallerLineNum, String func = Compiler.CallerMemberName)
	{
		var id = Tracy.AllocSrcLoc((.)line, fileName, func, 0);
#if TRACY_NO_CALLSTACK
		m_Ctx = Tracy.EmitZoneBeginAlloc(id, active);
#else
		m_Ctx = Tracy.EmitZoneBeginAllocCallstack(id, (int32)depth, active);
#endif
	}

	public ~this()
	{
		Tracy.EmitZoneEnd(m_Ctx);
	}

	public void Name(StringView name)
	{
		Tracy.EmitZoneName(m_Ctx, name);
	}

	public void Color(uint32 color)
	{
		Tracy.EmitZoneColor(m_Ctx, color);
	}

	public void Color(Color color)
	{
		Tracy.EmitZoneColor(m_Ctx, color.Underlying);
	}
}
