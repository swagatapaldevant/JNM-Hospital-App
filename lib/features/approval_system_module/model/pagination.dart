class PaginationModel {
    PaginationModel({
        required this.page,
        required this.searchData,

    });

    final int? page;
    final int? searchData;
  

    factory PaginationModel.fromJson(Map<String, dynamic> json){ 
        return PaginationModel(
            page: json["page"],
            searchData: json["search_data"],
        );
    }

    Map<String, dynamic> toJson() => {
        "page": page,
        "search_data": searchData,
    };

}