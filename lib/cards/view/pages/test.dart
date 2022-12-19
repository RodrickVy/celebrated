class Size{
  final double width;
  final double height;

  const Size(this.width, this.height);

  @override
  String toString() {
    // TODO: implement toString
    return "width:$width height:$height";
  }
}

class Ratio{
  final double width;
  final double height;

  const Ratio(this.width, this.height);

}
/// computes what the height and width of the card should be on the current [screenSize] based on the ratio
Size computeSizeFromRatio(Size screenSize, Ratio cardRatio) {
  // the difference in % between the x and y length of the card as a decimal
  double ratioPercentDifference = (cardRatio.height / cardRatio.width);

  double width = screenSize.width;
  double height = width * ratioPercentDifference;

  if (width <= screenSize.width && height <= screenSize.height) {
    return Size(width, height);
  } else {
    /// the only other case is when  height > screenSize.height
    final double difference = height - screenSize.height;
    height = height - difference;
    // the percentage of the decrease in height  as a decimal
    final double differencePercent = (difference / height);

    width = width - (width * differencePercent);

    return Size(width, height);
  }
}

void main() {
   print(computeSizeFromRatio(const Size(700, 1300),const Ratio(1, 2)));
}
