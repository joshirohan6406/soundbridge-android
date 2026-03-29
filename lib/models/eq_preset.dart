enum EqPreset {
  flat(label: 'Flat', bands: [0, 0, 0, 0, 0]),
  bassBoost(label: 'Bass boost', bands: [6, 4, 0, -2, -2]),
  cinema(label: 'Cinema', bands: [3, 1, 0, 2, 4]),
  voice(label: 'Voice', bands: [-2, 0, 4, 3, 2]),
  podcast(label: 'Podcast', bands: [-2, 2, 5, 2, -1]);

  final String label;
  final List<int> bands;

  const EqPreset({required this.label, required this.bands});
}
