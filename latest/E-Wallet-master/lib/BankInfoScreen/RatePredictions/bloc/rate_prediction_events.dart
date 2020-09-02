abstract class RatePredictionEvents extends Object {
  const RatePredictionEvents();
}

class InitPage extends RatePredictionEvents {}
class GetDates extends RatePredictionEvents {}
class GetRateSellPrediction extends RatePredictionEvents {}
class ReloadPage extends RatePredictionEvents {}