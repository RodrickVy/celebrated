

class FeatureAccess{
  final String name;
  final int limit;

  const FeatureAccess({required this.name,  this.limit=0});

  Map<String, dynamic> toMap() {
    return {
      'name': name,

      'limit': limit,
    };
  }

  factory FeatureAccess.fromMap(Map<String, dynamic> map) {
    return FeatureAccess(
      name: map['name'] as String,
      limit: map['limit']??0,
    );
  }


}