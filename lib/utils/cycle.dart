const Map<String, String> _presetCycles = {
  'Weekly': '7 00:00:00',
  'Monthly': '30 00:00:00',
  'Yearly': '365 00:00:00',
};

const String defaultCycle = '1 00:00:00';

String buildCycleString({
  required String? preset,
  String days = '',
  String hours = '',
  String minutes = '',
}) {
  final presetCycle = _presetCycles[preset];
  if (presetCycle != null) return presetCycle;
  if (preset != 'Custom') return defaultCycle;

  final d = int.tryParse(days.trim()) ?? 0;
  final h = int.tryParse(hours.trim()) ?? 0;
  final m = int.tryParse(minutes.trim()) ?? 0;

  if (d == 0 && h == 0 && m == 0) return defaultCycle;

  final time = '${_pad(h)}:${_pad(m)}:00';
  return d > 0 ? '$d $time' : time;
}

String _pad(int value) => value.toString().padLeft(2, '0');
