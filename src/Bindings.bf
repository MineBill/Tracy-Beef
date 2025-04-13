using System;

namespace Tracy;

typealias CString = char8*;
typealias c_size = System.Interop.c_size;

[CRepr]
struct SourceLocationData
{
	CString Name;
	CString Function;
	CString File;
	uint32 Line;
	uint32 Color;
}

[CRepr]
struct CZoneContext
{
	uint32 ID;
	Bool32 Active;
}

[CRepr]
struct Bool32
{
	public int32 m_Value;

	public static operator bool(Self self) => self.m_Value == 1;
	public static operator Self(bool value) => .() { m_Value = value ? 1 : 0 };
}

public static class Tracy
{
	[LinkName("___tracy_set_thread_name")]
	public static extern void SetThreadName(CString name);

	[LinkName("___tracy_alloc_srcloc")]
	private static extern uint64 _AllocSrcLoc(uint32 line, CString source, c_size sourceSz, CString @function, c_size functionSz, uint32 color);
	public static uint64 AllocSrcLoc(uint32 line, StringView source, StringView @function, uint32 color) => _AllocSrcLoc(line, source.Ptr, (.)source.Length, @function.Ptr, (.)@function.Length, color);

	[LinkName("___tracy_emit_zone_begin")]
	public static extern CZoneContext EmitZoneBegin(SourceLocationData* srcLoc, Bool32 active);

	[LinkName("___tracy_emit_zone_begin_callstack")]
	public static extern CZoneContext EmitZoneBeginCallstack(SourceLocationData* srcLoc, int32 depth, Bool32 active);

	[LinkName("___tracy_emit_zone_begin_alloc")]
	public static extern CZoneContext EmitZoneBeginAlloc(uint64 srcLoc, Bool32 active);

	[LinkName("___tracy_emit_zone_begin_alloc_callstack")]
	public static extern CZoneContext EmitZoneBeginAllocCallstack(uint64 srcLoc, int32 depth, Bool32 active);

	[LinkName("___tracy_emit_zone_end")]
	public static extern void EmitZoneEnd(CZoneContext ctx);

	[LinkName("___tracy_emit_zone_text")]
	private static extern void _EmitZoneText(CZoneContext ctx, CString text, c_size size);
	public static void EmitZoneText(CZoneContext ctx, StringView text) => _EmitZoneText(ctx, text.Ptr, (.)text.Length);

	[LinkName("___tracy_emit_zone_name")]
	private static extern void _EmitZoneName(CZoneContext ctx, CString text, c_size size);
	public static void EmitZoneName(CZoneContext ctx, StringView text) => _EmitZoneName(ctx, text.Ptr, (.)text.Length);

	[LinkName("___tracy_emit_zone_color")]
	public static extern void EmitZoneColor(CZoneContext ctx, uint32 color);

	[LinkName("___tracy_emit_zone_value")]
	public static extern void EmitZoneValue(CZoneContext ctx, uint64 value);

	[LinkName("___tracy_emit_message")]
	private static extern void _EmitMessage(CString text, c_size size, int32 callstack);
	public static void EmitMessage(StringView text, int32 callstack) => _EmitMessage(text.Ptr, (.)text.Length, callstack);

	[LinkName("___tracy_emit_frame_mark")]
	public static extern void FrameMark(CString text = null);

	[LinkName("___tracy_emit_frame_mark_start")]
	public static extern void FrameMarkStart(CString text);

	[LinkName("___tracy_emit_frame_mark_end")]
	public static extern void FrameMarkEnd(CString text);

	[LinkName("___tracy_connected")]
	public static extern Bool32 Connected();

	public const int DefaultStackDepth = 5;

#region Mixins
	// Emit a zone
	public static mixin Zone(bool active = true, int depth = Tracy.DefaultStackDepth)
	{
		scope:mixin Zone(active, depth);
	}

#if !TRACY_ENABLE
	[SkipCall]
#endif
	/// Emit a zone with a name
	public static mixin ZoneN(StringView name, bool active = true, int depth = Tracy.DefaultStackDepth)
	{
		scope:mixin Zone(active, depth).Name(name);
	}

#if !TRACY_ENABLE
	[SkipCall]
#endif
	/// Emit a zone with a color
	public static mixin ZoneC(uint32 color, bool active = true, int depth = Tracy.DefaultStackDepth)
	{
		scope:mixin Zone(active, depth).Color(color);
	}

#if !TRACY_ENABLE
	[SkipCall]
#endif
	/// Emit a zone with a color
	public static mixin ZoneC(Color color, bool active = true, int depth = Tracy.DefaultStackDepth)
	{
		scope:mixin Zone(active, depth).Color(color);
	}

#if !TRACY_ENABLE
	[SkipCall]
#endif
	/// Emit a zone with a name and a color
	public static mixin ZoneNC(StringView name, uint32 color, bool active = true, int depth = Tracy.DefaultStackDepth)
	{
		scope:mixin Zone(active, depth)..Name(name)..Color(color);
	}

#if !TRACY_ENABLE
	[SkipCall]
#endif
	/// Emit a zone with a name and a color
	public static mixin ZoneNC(StringView name, Color color, bool active = true, int depth = Tracy.DefaultStackDepth)
	{
		scope:mixin Zone(active, depth)..Name(name)..Color(color);
	}
#endregion
}