import 'package:api_bloc/features/posts/bloc/bloc/posts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsPage extends StatefulWidget {
  final String country;
  const PostsPage({super.key , required this.country});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  @override
  PostsBloc postsBloc = PostsBloc();
  void initState() {
    postsBloc.add(PostsInitialFetchEvent(country: widget.country));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts page"),
      ),
      body: BlocConsumer<PostsBloc, PostsState>(
        bloc: postsBloc,
        listener: (context, state) {
          listenWhen:
          (previous, current) => current is PostsActionState;
          buildWhen:
          (previous, current) => current is! PostsActionState;
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case PostsfetchingLoadingState:
              return Container(
                child: CircularProgressIndicator(),
              );
            case PostFetchingSuccessfulState:
              final successstate = state as PostFetchingSuccessfulState;
              // successtate will now contain the posts that are emit to it

              return Container(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: successstate.posts.length,
                  itemBuilder: (context, index) {
                    final post = successstate.posts[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Country name and GDP as header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  post.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'GDP: \$${post.gdp.toStringAsFixed(2)} M',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),

                            // Capital city and region information
                            Row(
                              children: [
                                Icon(Icons.location_city,
                                    color: Colors.blueAccent, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Capital: ${post.capital}',
                                  style: const TextStyle(color: Colors.black87),
                                ),
                                const Spacer(),
                                Text(
                                  post.region,
                                  style:
                                      const TextStyle(color: Colors.blueGrey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),

                            // Currency info
                            Row(
                              children: [
                                Icon(Icons.currency_exchange,
                                    color: Colors.teal, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Currency: ${post.currency.name} (${post.currency.code})',
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              ],
                            ),
                            const Divider(thickness: 1, height: 20),

                            // Additional country details
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Population: ${post.population} million',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                Text(
                                  'Urban Population: ${post.urbanPopulation}%',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                Text(
                                  'Life Expectancy (Male): ${post.lifeExpectancyMale} years',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                Text(
                                  'Internet Users: ${post.internetUsers}%',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.arrow_forward_ios,
                                  size: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );

            default:
              return Container();
          }
        },
      ),
    );
  }
}
