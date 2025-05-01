class UserReview{
  static String review(String review){
    String statement = review;

    // Regular expression to find digits in the string
    RegExp regExp = RegExp(r'\d+');

    // Find all matches
    Iterable<RegExpMatch> matches = regExp.allMatches(statement);

    // Convert the matches to a list of digits
    List<String> digits = matches.map((match) => match.group(0)!).toList();

    // Print the extracted digits (this will be ["210"])

    // If you need just the first number (reviews count)
    return digits[0];
  }

}