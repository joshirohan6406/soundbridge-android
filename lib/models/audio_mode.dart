enum AudioMode {
  movie(bufferMs: 200, name: 'movie', label: 'Movie'),
  music(bufferMs: 120, name: 'music', label: 'Music'),
  gaming(bufferMs: 60, name: 'gaming', label: 'Gaming'),
  custom(bufferMs: 120, name: 'custom', label: 'Custom');

  final int bufferMs;
  final String name;
  final String label;

  const AudioMode({
    required this.bufferMs,
    required this.name,
    required this.label,
  });

  static AudioMode fromName(String name) {
    return AudioMode.values.firstWhere(
      (m) => m.name == name,
      orElse: () => AudioMode.music,
    );
  }
}
