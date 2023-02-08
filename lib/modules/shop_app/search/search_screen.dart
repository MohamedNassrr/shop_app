import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/modules/shop_app/search/cubit/cubit.dart';
import 'package:shopapp/modules/shop_app/search/cubit/states.dart';
import 'package:shopapp/shared/components/components.dart';

class SearchScreen extends StatelessWidget {

  var FormKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: FormKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultFormField(
                      controller: searchController,
                      type: TextInputType.text,
                      validate: (String? value){
                        if(value!.isEmpty){
                          return 'enter text to search';
                        }
                      },
                      onSubmit: (String text){
                        SearchCubit.get(context).search(text);
                      },
                      label: 'Search',
                      preifix: Icons.search,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    if(state is ShopSearchLoadingState)
                      LinearProgressIndicator(),
                    SizedBox(
                      height: 10.0,
                    ),
                    if(state is ShopSearchSuccessState)
                      Expanded(
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) => buildlistProduct(SearchCubit.get(context).model!.data!.data![index], context, isOldPrice: false),
                        separatorBuilder: (context, index) => myDivider(),
                        itemCount: SearchCubit.get(context).model!.data!.data!.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
