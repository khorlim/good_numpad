class NumPadConfig<T extends num> {
  final T maxValue;
  final T minValue;

  NumPadConfig({
    required this.maxValue,
    required this.minValue,
  });

  const NumPadConfig.empty()
      : maxValue = 0 as T,
        minValue = 0 as T;
}
