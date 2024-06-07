class User {
  int? id;
  String? email;
  String? phoneNumber;
  String? fullName;
  int? nbChallenge;
  int? nbChallengeDone;
  int? estimatedTime;
  int? actualTime;
  double? score;

  User({
    this.id,
    this.email,
    this.phoneNumber,
    this.fullName,
    this.nbChallenge,
    this.nbChallengeDone,
    this.estimatedTime,
    this.actualTime,
    this.score,
  });

  @override
  String toString() {
    return 'User{id: $id, email: $email, phoneNumber: $phoneNumber, fullName: $fullName, nbChallenge: $nbChallenge, nbChallengeDone: $nbChallengeDone, estimatedTime: $estimatedTime, actualTime: $actualTime, score: $score}';
  }
}
