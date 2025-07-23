class TADetails {
  static List<String> getAdditionalDetails() {
    return ['Cash on delivery', 'Available'];
  }

  static List<String> getTagLineDetails() {
    return ['Vegetables', 'Fruit'];
  }

  static List<String> getCountries = ['USA', 'Canada', 'UK'];

  static Map<String, List<String>> countryCityMap = {
    'USA': ['New York', 'Los Angeles', 'Chicago'],
    'Canada': ['Toronto', 'Vancouver', 'Montreal'],
    'UK': ['London', 'Manchester', 'Birmingham'],
  };

  static Map<String, List<String>> cityAddressMap = {
    'New York': ['123 Main St', '456 Elm St'],
    'Los Angeles': ['789 Sunset Blvd', '101 Hollywood Ave'],
    'Chicago': ['202 Michigan Ave', '303 Lake Shore Dr'],
    'Toronto': ['1 Queen St', '2 King St'],
    'Vancouver': ['3 Granville St', '4 Robson St'],
    'Montreal': ['5 Saint Catherine St', '6 Sherbrooke St'],
    'London': ['7 Oxford St', '8 Regent St'],
    'Manchester': ['9 Deansgate', '10 Piccadilly'],
    'Birmingham': ['11 Broad St', '12 New St'],
  };
}
