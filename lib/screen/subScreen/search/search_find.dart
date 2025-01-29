import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/search/search_history_model.dart';

class SearchFindScreen extends StatefulWidget {
  const SearchFindScreen({
    super.key,
    required this.searchHistoryModel,
    required this.onTap,
  });

  final List<SearchHistoryModel> searchHistoryModel;
  final Function onTap;

  @override
  State<SearchFindScreen> createState() => _SearchFindScreenState();
}

class _SearchFindScreenState extends State<SearchFindScreen> {
  @override
  Widget build(BuildContext context) {

    return Container(
      height: 67.h,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0;
                i < widget.searchHistoryModel.length;
                i++) ...[
              GestureDetector(
                onTap: (){
                  print('검색어 선택');
                  widget.onTap(widget.searchHistoryModel[i].historyText);
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
                        widget.searchHistoryModel[i].historyText.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        widget.searchHistoryModel[i].historyDate.toString(),
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
        ),
      ),
    );
  }
}
