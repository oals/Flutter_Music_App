import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/search/search_history_model.dart';
import 'package:skrrskrr/prov/search_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_Indicator_item.dart';

class SearchFindSubScreen extends StatefulWidget {
  const SearchFindSubScreen({
    super.key,
    required this.onTap,
  });

  final Function onTap;

  @override
  State<SearchFindSubScreen> createState() => _SearchFindSubScreenState();
}


class _SearchFindSubScreenState extends State<SearchFindSubScreen> {
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

    return FutureBuilder(
      future : _getSearchTextHistoryFuture,
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Expanded(
            child: Center(child: CustomProgressIndicatorItem())
        );
      } else if (snapshot.hasError) {
        return Center(child: Text('오류 발생: ${snapshot.error}'));
      }

      List<SearchHistoryModel> searchHistoryList = searchProv.searchHistoryModel;

      return Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 12.h),
            itemCount: searchHistoryList.length,
            itemBuilder: (context, i) => ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                  GestureDetector(
                    onTap: (){
                      print('검색어 선택');
                      widget.onTap(searchHistoryList[i].historyText);
                    },
                    child: Container(
                      width: 100.w,
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
            ),
          ),
        ),
      );
      }
    );
  }
}
