import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:news_app/modules/web_view/webview.dart';
import 'package:news_app/shared/cubit/news_states.dart';

Widget newsItem(List<dynamic>? article, int index, context) {
  return InkWell(
    onTap: () {
      navigateTo(
          context: context,
          widget: NewsWebView(
            url: article![index]['url'],
          ));
    },
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(
                  '${article![index]['urlToImage']}',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 120,
              width: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      article[index]['title'],
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Text(
                    article[index]['publishedAt'],
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget commonTextFormField({
  required TextEditingController controller,
  required FormFieldValidator<String>? validator,
  TextInputType? keyboardType,
  ValueChanged<String>? onChanged,
  GestureTapCallback? onTap,
  required String labelText,
  required IconData preFixIcon,
  IconData? suffixIcon,
  ValueChanged<String>? onFieldSubmitted,
  bool obscureText = false,
  VoidCallback? onPressed,
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      // hintText: 'Enter Email',
      labelText: labelText,
      prefixIcon: Icon(preFixIcon),
      suffixIcon: IconButton(onPressed: onPressed, icon: Icon(suffixIcon)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    onFieldSubmitted: onFieldSubmitted,
    onChanged: onChanged,
    onTap: onTap,
    obscureText: obscureText,
  );
}

Widget getArticles(
    {required List? list, required NewsStates state, bool? isSearch}) {
  return ConditionalBuilder(
    condition: list!.length > 0,
    builder: (context) {
      return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          // print(
          //     'index $index total result ${cubit.business!['totalResults']}');
          // print(cubit.business!['articles']);
          return newsItem(list, index, context);
        },
        separatorBuilder: (context, index) {
          return Divider(
            indent: 10,
          );
        },
        itemCount: 11,
      );
    },
    fallback: (context) {
      return isSearch == true
          ? Container()
          : Center(
              child: CircularProgressIndicator(),
            );
    },
  );
}

Future<dynamic> navigateTo(
    {required BuildContext context, required Widget widget}) {
  return Navigator.push(context, MaterialPageRoute(builder: (context) {
    return widget;
  }));
}
