import 'package:injectable/injectable.dart';
import '../../model/search_result_model.dart';
import '../interface/i_search_data_source.dart';

@LazySingleton(as: ISearchDataSource)
class MockSearchDataSource implements ISearchDataSource {
  // Mock database of users
  final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': 'user_1',
      'name': 'Caleb Reed',
      'role': 'Athlete',
      'profileImage': 'https://i.pravatar.cc/150?img=1',
      'userType': 'athlete',
      'location': 'Cairo',
      'age': 24,
      'position': 'Forward',
      'typeOfPlay': 'Football',
      'level': 'Advanced',
    },
    {
      'id': 'user_2',
      'name': 'Owen Turner',
      'role': 'Agent',
      'profileImage': 'https://i.pravatar.cc/150?img=2',
      'userType': 'agent',
      'location': 'Cairo',
      'age': 35,
      'position': null,
      'typeOfPlay': null,
      'level': null,
    },
    {
      'id': 'user_3',
      'name': 'Olivia Bennett',
      'role': 'Coach',
      'profileImage': 'https://i.pravatar.cc/150?img=3',
      'userType': 'coach',
      'location': 'Alexandria',
      'age': 40,
      'position': null,
      'typeOfPlay': 'Football',
      'level': 'Advanced',
    },
    {
      'id': 'user_4',
      'name': 'Noah Thompson',
      'role': 'Athlete',
      'profileImage': 'https://i.pravatar.cc/150?img=4',
      'userType': 'athlete',
      'location': 'Cairo',
      'age': 22,
      'position': 'Midfielder',
      'typeOfPlay': 'Football',
      'level': 'Intermediate',
    },
    {
      'id': 'user_5',
      'name': 'Ethan Carter',
      'role': 'Athlete',
      'profileImage': 'https://i.pravatar.cc/150?img=5',
      'userType': 'athlete',
      'location': 'Giza',
      'age': 26,
      'position': 'Goalkeeper',
      'typeOfPlay': 'Football',
      'level': 'Advanced',
    },
    {
      'id': 'user_6',
      'name': 'Sophia Hayes',
      'role': 'Athlete',
      'profileImage': 'https://i.pravatar.cc/150?img=6',
      'userType': 'athlete',
      'location': 'Cairo',
      'age': 21,
      'position': 'Defender',
      'typeOfPlay': 'Football',
      'level': 'Beginner',
    },
    {
      'id': 'user_7',
      'name': 'Liam Foster',
      'role': 'Coach',
      'profileImage': 'https://i.pravatar.cc/150?img=7',
      'userType': 'coach',
      'location': 'Alexandria',
      'age': 45,
      'position': null,
      'typeOfPlay': 'Basketball',
      'level': 'Advanced',
    },
    {
      'id': 'user_8',
      'name': 'Emma Davis',
      'role': 'Scout',
      'profileImage': 'https://i.pravatar.cc/150?img=8',
      'userType': 'scout',
      'location': 'Cairo',
      'age': 38,
      'position': null,
      'typeOfPlay': null,
      'level': null,
    },
    {
      'id': 'user_9',
      'name': 'Mason Wright',
      'role': 'Athlete',
      'profileImage': 'https://i.pravatar.cc/150?img=9',
      'userType': 'athlete',
      'location': 'Giza',
      'age': 19,
      'position': 'Forward',
      'typeOfPlay': 'Basketball',
      'level': 'Intermediate',
    },
    {
      'id': 'user_10',
      'name': 'Isabella Martinez',
      'role': 'Athlete',
      'profileImage': 'https://i.pravatar.cc/150?img=10',
      'userType': 'athlete',
      'location': 'Cairo',
      'age': 23,
      'position': 'Midfielder',
      'typeOfPlay': 'Football',
      'level': 'Advanced',
    },
    {
      'id': 'user_11',
      'name': 'Lucas Anderson',
      'role': 'Coach',
      'profileImage': 'https://i.pravatar.cc/150?img=11',
      'userType': 'coach',
      'location': 'Alexandria',
      'age': 50,
      'position': null,
      'typeOfPlay': 'Football',
      'level': 'Advanced',
    },
    {
      'id': 'user_12',
      'name': 'Mia Johnson',
      'role': 'Agent',
      'profileImage': 'https://i.pravatar.cc/150?img=12',
      'userType': 'agent',
      'location': 'Cairo',
      'age': 33,
      'position': null,
      'typeOfPlay': null,
      'level': null,
    },
    {
      'id': 'user_13',
      'name': 'Alexander Lee',
      'role': 'Athlete',
      'profileImage': 'https://i.pravatar.cc/150?img=13',
      'userType': 'athlete',
      'location': 'Giza',
      'age': 25,
      'position': 'Defender',
      'typeOfPlay': 'Football',
      'level': 'Advanced',
    },
    {
      'id': 'user_14',
      'name': 'Charlotte Brown',
      'role': 'Athlete',
      'profileImage': 'https://i.pravatar.cc/150?img=14',
      'userType': 'athlete',
      'location': 'Cairo',
      'age': 20,
      'position': 'Forward',
      'typeOfPlay': 'Basketball',
      'level': 'Beginner',
    },
    {
      'id': 'user_15',
      'name': 'James Wilson',
      'role': 'Scout',
      'profileImage': 'https://i.pravatar.cc/150?img=15',
      'userType': 'scout',
      'location': 'Alexandria',
      'age': 42,
      'position': null,
      'typeOfPlay': null,
      'level': null,
    },
  ];

  @override
  Future<List<SearchResultModel>> search({
    required String query,
    SearchFilters? filters,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    print('Mock API: GET /search?query=$query&filters=${filters?.toJson()}');
    
    // Filter results based on query and filters
    var results = _mockUsers.where((user) {
      // Search by name (case-insensitive)
      final matchesQuery = query.isEmpty || 
          user['name'].toString().toLowerCase().contains(query.toLowerCase());
      
      if (!matchesQuery) return false;
      
      // Apply filters if provided
      if (filters != null) {
        // Age filter
        if (filters.minAge != null && user['age'] != null) {
          if (user['age'] < filters.minAge!) return false;
        }
        if (filters.maxAge != null && user['age'] != null) {
          if (user['age'] > filters.maxAge!) return false;
        }
        
        // Location filter
        if (filters.location != null && filters.location!.isNotEmpty) {
          if (user['location'] != filters.location) return false;
        }
        
        // Position filter
        if (filters.position != null && filters.position!.isNotEmpty) {
          if (user['position'] != filters.position) return false;
        }
        
        // Type of play filter
        if (filters.typeOfPlay != null && filters.typeOfPlay!.isNotEmpty) {
          if (user['typeOfPlay'] != filters.typeOfPlay) return false;
        }
        
        // Level filter
        if (filters.level != null && filters.level!.isNotEmpty) {
          if (user['level'] != filters.level) return false;
        }
        
        // User type filter
        if (filters.userType != null) {
          if (user['userType'] != filters.userType!.name) return false;
        }
      }
      
      return true;
    }).toList();
    
    // Convert to models
    return results.map((user) => SearchResultModel.fromJson(user)).toList();
  }

  @override
  Future<List<String>> getLocations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ['Cairo', 'Alexandria', 'Giza', 'Sharm El Sheikh', 'Hurghada'];
  }

  @override
  Future<List<String>> getPositions() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ['Forward', 'Midfielder', 'Defender', 'Goalkeeper'];
  }

  @override
  Future<List<String>> getTypesOfPlay() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ['Football', 'Basketball', 'Tennis', 'Volleyball', 'Swimming'];
  }
}