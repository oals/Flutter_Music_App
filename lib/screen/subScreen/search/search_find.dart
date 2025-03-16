import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/search/search_history_model.dart';
import 'package:skrrskrr/prov/search_prov.dart';

class SearchFindScreen extends StatefulWidget {
  const SearchFindScreen({
    super.key,
    required this.onTap,
  });

  final Function onTap;

  @override
  State<SearchFindScreen> createState() => _SearchFindScreenState();
}


class _SearchFindScreenState extends State<SearchFindScreen> {
  late SearchProv searchProv;
  late Future<bool> _getSearchTextHistoryFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSearchTextHistoryFuture = Provider.of<SearchProv>(context,listen : false).fnSearchTextHistory();
  }

  @override
  Widget build(BuildContext context) {
    SearchProv searchProv = Provider.of<SearchProv>(context);

    return Container(
      height: 67.h,
      child: SingleChildScrollView(
        child: FutureBuilder(
          future : _getSearchTextHistoryFuture,
          builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
          return Center(child: Text('오류 발생: ${snapshot.error}'));
          }

          List<SearchHistoryModel> searchHistoryList = searchProv.searchHistoryModel;

          return Column(
              children: [
                for (int i = 0; i < searchHistoryList.length; i++) ...[
                  GestureDetector(
                    onTap: (){
                      print('검색어 선택');
                      widget.onTap(searchHistoryList[i].historyText);
                    },
                    child: Container(
                      width: 90.w,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.09,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            searchHistoryList[i].historyText.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            searchHistoryList[i].historyDate.toString(),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            );
          }
        ),
      ),
    );
  }
}
