class QuotesModel{
  String quoteId;
  String quoteDescription;
  String quoteCategory;
  String quoteImageUrl;
  QuotesModel({this.quoteDescription,this.quoteCategory,this.quoteImageUrl});

  QuotesModel.fromMap(Map snapshot,String id){
    quoteId = id ?? '';
    quoteDescription = snapshot['quoteDescription'] ?? '';
    quoteCategory = snapshot['quoteCategory'] ?? '';
    quoteImageUrl = snapshot['quoteImageUrl'] ?? '';
  }
  toJson() {
    return {
      "quoteDescription": quoteDescription,
      "quoteCategory":quoteCategory,
      "quoteImageUrl":quoteImageUrl
    };
  }
}