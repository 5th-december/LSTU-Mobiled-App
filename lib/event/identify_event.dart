abstract class IdentifyEvent {}

class IdentificationButtonPressedEvent extends IdentifyEvent 
{
  final String name;
  final int enterYear;
  final String zBookNumber;

  IdentificationButtonPressedEvent({
    this.name,
    this.enterYear,
    this.zBookNumber
  });
}