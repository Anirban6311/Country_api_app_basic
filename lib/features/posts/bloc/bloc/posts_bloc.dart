// import 'dart:async';
// import 'dart:convert';

// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:http/http.dart' as http;

// import '../../models/posts_data_ui_model.dart';

// part 'posts_event.dart';
// part 'posts_state.dart';

// class PostsBloc extends Bloc<PostsEvent, PostsState> {
//   PostsBloc() : super(PostsInitial()) {
//     on<PostsInitialFetchEvent>(postsInitialFetchEvent);
//   }

//   FutureOr<void> postsInitialFetchEvent(
//       PostsInitialFetchEvent event, Emitter<PostsState> emit) async {
//     emit(PostsfetchingLoadingState());
//     var client = http.Client();

//     //1.Fetch the posts in reponse
//     //2.Map json to dart model
//     //3.give the list of posts to successstate to emit the state
//     List<CountryDataModel> posts = [];
//     try {
//       var response = await client
//           .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
//       List result = jsonDecode(response.body);
//       for (int i = 0; i < result.length; i++) {
//         //mapping the json body to a list of CountryDataModel
//         CountryDataModel post =
//             CountryDataModel.fromMap(result[i] as Map<String, dynamic>);

//         posts.add(post);
//       }
//       print(posts);
//       emit(PostFetchingSuccessfulState(posts: posts));
//     } catch (e) {
//       emit(PostsfetchingErrorState());
//       print(e.toString());
//     }
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../models/posts_data_ui_model.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc() : super(PostsInitial()) {
    on<PostsInitialFetchEvent>(postsInitialFetchEvent);
  }

  FutureOr<void> postsInitialFetchEvent(
      PostsInitialFetchEvent event, Emitter<PostsState> emit) async {
    emit(PostsfetchingLoadingState());
    var client = http.Client();

    try {
      // Fetch the posts in response
      var response = await client.get(
          Uri.parse(
            'https://api.api-ninjas.com/v1/country?name=${event.country}',
          ),
          headers: {'X-Api-Key': 'YHtBiNuLo+9ux37f4+rJVQ==GMXz1VFAp7rGAULt'});

      if (response.statusCode == 200) {
        print("Connection is ok");
        print(event.country);
        List<dynamic> result = jsonDecode(response.body);

        // Check if the result is not empty  
        ////use for loop if there are a list of items to be fetched
        if (result.isNotEmpty) {
          // Mapping the json body to a list of CountryDataModel
          CountryDataModel post =
              CountryDataModel.fromMap(result[0] as Map<String, dynamic>);

          emit(PostFetchingSuccessfulState(posts: [post])); // Wrap in a list
        } else {
          emit(PostsfetchingErrorState()); // Emit error for no data
          print("No data found for the country: ${event.country}");
        }
      } else {
        emit(PostsfetchingErrorState());
        print("Error in connection: ${response.statusCode}");
      }
    } catch (e) {
      emit(PostsfetchingErrorState());
      print(e.toString());
    } finally {
      client.close(); // Ensure the client is closed after the request
    }
  }
}
