class SHACLResults {
  final bool conforms;

  SHACLResults({required this.conforms});

  factory SHACLResults.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('sh:conforms')) {
      final conformsObj = json['sh:conforms'];
      if (conformsObj is Map && conformsObj.containsKey('@value')) {
        final conformsValue = conformsObj['@value'];
        return SHACLResults(conforms: (conformsValue == 'true'));
      }
    } else if (json.containsKey('@graph')) {
      final graph = json['@graph'];
      if (graph is List) {
        final validationResult = graph.firstWhere(
          (item) => item['@type'] == 'sh:ValidationReport',
          orElse: () => {},
        );
        if (validationResult.containsKey('sh:conforms')) {
          final conformsObj = validationResult['sh:conforms'];
          if (conformsObj is Map && conformsObj.containsKey('@value')) {
            final conformsValue = conformsObj['@value'];
            return SHACLResults(conforms: (conformsValue == 'true'));
          }
        }
      }
    }

    // Return a default value or throw an exception if desired
    return SHACLResults(conforms: false);
  }
}
