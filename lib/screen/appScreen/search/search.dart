import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/search/search_history_model.dart';
import 'package:skrrskrr/model/search/search_model.dart';
import 'package:skrrskrr/prov/search_prov.dart';
import 'package:skrrskrr/screen/subScreen/search/search_find.dart';
import 'package:skrrskrr/screen/subScreen/search/search_main.dart';
import 'package:skrrskrr/screen/subScreen/search/search_result.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });


  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isSearchHistory = true;
  bool isSearchMain = true;
  late SearchModel searchModel;

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
      body: Container(
        padding: const EdgeInsets.all(10),
        width: 100.w,
        height: 130.h,
        color: Color(0xff000000),
        child: FutureBuilder(
            future: _getSearchInitFuture, // 비동기 메소드 호출
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('오류 발생: ${snapshot.error}'));
              }

              searchModel = searchProv.model;
              recentListenTrackHistory = searchProv.recentListenTrackHistory;

              return Column(
                children: [
                  SizedBox(
                    height: 41,
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
                      decoration: InputDecoration(
                        filled: false,
                        hintText: '검색어를 입력하세요',
                        hintStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: IconButton(
                          icon: Icon(
                            !isSearchMain ? Icons.arrow_back : Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () => {
                            if(!isSearchMain){
                              isSearchMain = !isSearchMain,
                              setState(() {})
                            }
                          },
                        ),

                        // 오른쪽 끝에 X 버튼 추가
                        suffixIcon: isSearchHistory
                            ? _searchController.text.isNotEmpty
                            ? IconButton(
                          icon: const Icon(
                              Icons.close,
                              size: 17,
                              color: Colors.white
                          ),
                          onPressed: () {_searchController.clear(); // 텍스트 필드 비우기
                              setState(() {});
                          },
                        )
                            : null
                            : null, // 텍스트가 비어 있으면 X 버튼을 안 보이게 함
                      ),
                      onTap: () {
                        isSearchMain = false;
                        isSearchHistory = true;
                        setState(() {});
                      },

                      // 검색
                      onSubmitted: (text) async {
                        if (text != "") {
                          searchModel.searchText = text;
                          await searchProv.search(text, 0);
                          isSearchMain = false;
                          isSearchHistory = false;
                          setState(() {});
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 15),
                  Container(
                      width: 100.w,
                      child: isSearchMain
                      /// 검색 결과
                          ? SearchMainScreen(
                            recentListenTrackHistory: recentListenTrackHistory,
                            onTap: (String searchHistory) async {
                              isSearchMain = false;
                              isSearchHistory = false;
                            },
                          )
                          : isSearchHistory
                          ? SearchFindScreen(
                              onTap: (String searchHistory) async {
                                await searchProv.search(searchHistory, 0);
                                _searchController.text = searchHistory;
                                searchModel.searchText = _searchController.text;
                                isSearchMain = false;
                                isSearchHistory = false;
                                FocusScope.of(context).unfocus();
                                setState(() {});
                              },
                            )
                          : SearchResultScreen(searchModel: searchModel)),
                ],
              );
            }
        ),
      ),
    );
  }
}
