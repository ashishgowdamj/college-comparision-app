class College {
  final String id;
  final String name;
  final String city;
  final String type;
  final int rank;
  final int fees;
  final String? imageUrl;
  final String? website;
  final String? establishedYear;
  final String? ownership;
  final int? totalCourses;
  final int? btechCourses;
  final double? medianSalary;
  final double? highestSalary;
  final double? totalFees;
  final double? rating;
  final int? reviews;
  final double? placementRating;
  final double? infrastructureRating;
  final double? facultyRating;
  final double? campusRating;
  final double? valueRating;
  final String? nirfRank;
  final String? indiaTodayRank;
  final List<String>? facilities;

  College({
    required this.id,
    required this.name,
    required this.city,
    required this.type,
    required this.rank,
    required this.fees,
    this.imageUrl,
    this.website,
    this.establishedYear,
    this.ownership,
    this.totalCourses,
    this.btechCourses,
    this.medianSalary,
    this.highestSalary,
    this.totalFees,
    this.rating,
    this.reviews,
    this.placementRating,
    this.infrastructureRating,
    this.facultyRating,
    this.campusRating,
    this.valueRating,
    this.nirfRank,
    this.indiaTodayRank,
    this.facilities,
  });

  factory College.fromMap(Map<String, dynamic> map, String id) {
    return College(
      id: id,
      name: map['name']?.toString() ?? '',
      city: map['city']?.toString() ?? '',
      type: map['type']?.toString() ?? '',
      rank: map['rank'] is int ? map['rank'] : int.tryParse(map['rank']?.toString() ?? '0') ?? 0,
      fees: map['fees'] is int ? map['fees'] : int.tryParse(map['fees']?.toString() ?? '0') ?? 0,
      imageUrl: map['imageUrl']?.toString(),
      website: map['website']?.toString(),
      establishedYear: map['establishedYear']?.toString(),
      ownership: map['ownership']?.toString(),
      totalCourses: map['totalCourses'] is int ? map['totalCourses'] : int.tryParse(map['totalCourses']?.toString() ?? '0'),
      btechCourses: map['btechCourses'] is int ? map['btechCourses'] : int.tryParse(map['btechCourses']?.toString() ?? '0'),
      medianSalary: map['medianSalary'] is double ? map['medianSalary'] : double.tryParse(map['medianSalary']?.toString() ?? '0'),
      highestSalary: map['highestSalary'] is double ? map['highestSalary'] : double.tryParse(map['highestSalary']?.toString() ?? '0'),
      totalFees: map['totalFees'] is double ? map['totalFees'] : double.tryParse(map['totalFees']?.toString() ?? '0'),
      rating: map['rating'] is double ? map['rating'] : double.tryParse(map['rating']?.toString() ?? '0'),
      reviews: map['reviews'] is int ? map['reviews'] : int.tryParse(map['reviews']?.toString() ?? '0'),
      placementRating: map['placementRating'] is double ? map['placementRating'] : double.tryParse(map['placementRating']?.toString() ?? '0'),
      infrastructureRating: map['infrastructureRating'] is double ? map['infrastructureRating'] : double.tryParse(map['infrastructureRating']?.toString() ?? '0'),
      facultyRating: map['facultyRating'] is double ? map['facultyRating'] : double.tryParse(map['facultyRating']?.toString() ?? '0'),
      campusRating: map['campusRating'] is double ? map['campusRating'] : double.tryParse(map['campusRating']?.toString() ?? '0'),
      valueRating: map['valueRating'] is double ? map['valueRating'] : double.tryParse(map['valueRating']?.toString() ?? '0'),
      nirfRank: map['nirfRank']?.toString(),
      indiaTodayRank: map['indiaTodayRank']?.toString(),
      facilities: map['facilities'] != null 
          ? List<String>.from(map['facilities'].map((item) => item.toString()))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name.toString(),
      'city': city.toString(),
      'type': type.toString(),
      'rank': rank.toString(),
      'fees': fees.toString(),
      'imageUrl': imageUrl?.toString(),
      'website': website?.toString(),
      'establishedYear': establishedYear?.toString(),
      'ownership': ownership?.toString(),
      'totalCourses': totalCourses?.toString(),
      'btechCourses': btechCourses?.toString(),
      'medianSalary': medianSalary?.toString(),
      'highestSalary': highestSalary?.toString(),
      'totalFees': totalFees?.toString(),
      'rating': rating?.toString(),
      'reviews': reviews?.toString(),
      'placementRating': placementRating?.toString(),
      'infrastructureRating': infrastructureRating?.toString(),
      'facultyRating': facultyRating?.toString(),
      'campusRating': campusRating?.toString(),
      'valueRating': valueRating?.toString(),
      'nirfRank': nirfRank?.toString(),
      'indiaTodayRank': indiaTodayRank?.toString(),
      'facilities': facilities?.map((f) => f.toString()).toList(),
    };
  }

  College copyWith({
    String? id,
    String? name,
    String? city,
    String? type,
    int? rank,
    int? fees,
    String? imageUrl,
    String? establishedYear,
    String? ownership,
    int? totalCourses,
    int? btechCourses,
    double? medianSalary,
    double? highestSalary,
    double? totalFees,
    double? rating,
    int? reviews,
    double? placementRating,
    double? infrastructureRating,
    double? facultyRating,
    double? campusRating,
    double? valueRating,
    String? nirfRank,
    String? indiaTodayRank,
    List<String>? facilities,
  }) {
    return College(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      type: type ?? this.type,
      rank: rank ?? this.rank,
      fees: fees ?? this.fees,
      imageUrl: imageUrl ?? this.imageUrl,
      establishedYear: establishedYear ?? this.establishedYear,
      ownership: ownership ?? this.ownership,
      totalCourses: totalCourses ?? this.totalCourses,
      btechCourses: btechCourses ?? this.btechCourses,
      medianSalary: medianSalary ?? this.medianSalary,
      highestSalary: highestSalary ?? this.highestSalary,
      totalFees: totalFees ?? this.totalFees,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      placementRating: placementRating ?? this.placementRating,
      infrastructureRating: infrastructureRating ?? this.infrastructureRating,
      facultyRating: facultyRating ?? this.facultyRating,
      campusRating: campusRating ?? this.campusRating,
      valueRating: valueRating ?? this.valueRating,
      nirfRank: nirfRank ?? this.nirfRank,
      indiaTodayRank: indiaTodayRank ?? this.indiaTodayRank,
      facilities: facilities ?? this.facilities,
    );
  }
} 