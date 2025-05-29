import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/prov/search_prov.dart';
import 'package:skrrskrr/screen/subScreen/comn/loadingBar/custom_progress_Indicator_item.dart';
import 'package:skrrskrr/screen/subScreen/search/search_find_sub_screen.dart';
import 'package:skrrskrr/screen/subScreen/search/search_main_sub_screen.dart';
import 'package:skrrskrr/screen/subScreen/search/search_result_sub_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });


  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  int? searchId = 0;
  late List<String> recentListenTrackHistory;
  late Future<bool> _getSearchInitFuture;

  @override
  void initState() {
    super.initState();
    _getSearchInitFuture = Provider.of<SearchProv>(context, listen: false).fnSearchRecentListenTrack();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    SearchProv searchProv = Provider.of<SearchProv>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: const EdgeInsets.all(10),
        width: 100.w,
        color: Color(0xff000000),
        child: FutureBuilder(
            future: _getSearchInitFuture, // 비동기 메소드 호출
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CustomProgressIndicatorItem());
              } else if (snapshot.hasError) {
                return Center(child: Text('오류 발생: ${snapshot.error}'));
              }


              recentListenTrackHistory = searchProv.recentListenTrackHistory;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff1C1C1C), // 상단의 연한 색 (색상값을 조정하세요)
                          Color(0xff1C1C1E), // 하단의 어두운 색 (현재 색상)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // 그림자 색상
                          spreadRadius: 5, // 그림자의 확산 정도
                          blurRadius: 6, // 그림자의 흐림 정도
                          offset: Offset(0, 2), // 그림자의 방향 (x, y)
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        filled: false,
                        hintText: 'search',
                        hintStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w500),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: IconButton(
                          icon: Icon(
                            searchId != 0 ? Icons.arrow_back : Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () => {
                            _searchController.text = "",

                            if (searchId != 0) {
                              FocusScope.of(context).requestFocus(_focusNode),
                              if (searchId == 2) {
                                searchId = 1,
                              } else {
                                searchId = 0,
                                _focusNode.unfocus(),
                              },
                              setState(() {})
                            }
                          },
                        ),

                        // 오른쪽 끝에 X 버튼 추가
                        suffixIcon: searchId != 0 && _searchController.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(
                              Icons.close,
                              size: 17,
                              color: Colors.white
                          ),
                          onPressed: () {
                            _searchController.clear(); // 텍스트 필드 비우기
                            setState(() {});
                          },
                        ) : null, // 텍스트가 비어 있으면 X 버튼을 안 보이게 함
                      ),

                      onTap: () {
                        searchId = 1;
                        setState(() {});
                      },

                      // 검색
                      onSubmitted: (text) async {
                        if (text != "") {
                          _searchController.text = text;
                          await searchProv.setSearchHistory(text, 0);
                          searchId = 2;
                          setState(() {});
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  if (searchId == 0)
                    SearchMainSubScreen(recentListenTrackHistory: recentListenTrackHistory,)

                  else if (searchId == 1)
                    SearchFindSubScreen(
                      onTap: (String searchHistory) async {
                        _focusNode.unfocus();
                        await searchProv.setSearchHistory(searchHistory, 0);
                        _searchController.text = searchHistory;
                        searchId = 2;
                        setState(() {});
                      },
                    )

                  else
                    SearchResultSubScreen(searchText: _searchController.text),

                ],
              );
            }
        ),
      ),
    );
  }
}
