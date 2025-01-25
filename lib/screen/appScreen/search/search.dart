import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skrrskrr/model/search/search_history_model.dart';
import 'package:skrrskrr/model/search/search_model.dart';
import 'package:skrrskrr/prov/search_prov.dart';
import 'package:skrrskrr/screen/appScreen/search/search_find.dart';
import 'package:skrrskrr/screen/appScreen/search/search_main.dart';
import 'package:skrrskrr/screen/appScreen/search/search_result.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    
    
  });

  
  

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isSeachHistory = true;
  bool isSearchMain = true;
  late SearchProv searchProv;
  late final SearchModel searchModel;
  late List<SearchHistoryModel> searchHistoryModel;
  late List<String> popularTrackHistory;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    searchProv = Provider.of<SearchProv>(context, listen: false);
    await searchProv.fnInit();
    setState(() {
      searchModel = searchProv.model;
      searchHistoryModel = searchProv.searchHistoryModel;
      popularTrackHistory = searchProv.popularTrackHistory;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return Center(child: CircularProgressIndicator()); // 로딩 중일 때 보여줄 UI
    }

    return Scaffold(


      body: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff000000), // 상단의 연한 색
              Color(0xff000000),    // 하단의 어두운 색
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        width: 100.w,
        height: 130.h,
        child: Column(
          children: [
              SizedBox(
                height: 50,
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
                    spreadRadius: 5,  // 그림자의 확산 정도
                    blurRadius: 6,    // 그림자의 흐림 정도
                    offset: Offset(0, 2),  // 그림자의 방향 (x, y)
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
                     icon : Icon(
                      !isSearchMain ? Icons.arrow_back  : Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: ()=>{
                      if(!isSearchMain){
                        setState(() {
                          isSearchMain = !isSearchMain;
                        })
                      }
                    },
                  ),

                  // 오른쪽 끝에 X 버튼 추가
                  suffixIcon: isSeachHistory
                      ? _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.close,
                        size: 17, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _searchController.clear(); // 텍스트 필드 비우기
                      });
                    },
                  )
                      : null
                      : null, // 텍스트가 비어 있으면 X 버튼을 안 보이게 함
                ),
                onTap: () {
                  setState(() {
                    isSearchMain = false;
                    isSeachHistory = true;
                  });
                },

                // 검색
                onSubmitted: (text) async {
                  if (text != "") {
                    searchModel.searchText = text;
                    await searchProv.searchTrack(text,0);
                    DateTime currentDate = DateTime.now();

                    // 연도, 일, 월을 추출
                    String year = currentDate.year.toString();
                    String day = currentDate.day
                        .toString()
                        .padLeft(2, '0'); // 일(day)을 두 자릿수로
                    String month = currentDate.month
                        .toString()
                        .padLeft(2, '0'); // 월(month)을 두 자릿수로

                    // 원하는 형식으로 날짜 포맷
                    String formattedDate = '$year-$day-$month';

                    SearchHistoryModel newSearchHistory = SearchHistoryModel();
                    newSearchHistory.historyText = text;
                    newSearchHistory.historyDate = formattedDate;

                    searchHistoryModel.insert(0, newSearchHistory);

                    setState(() {
                      isSearchMain = false;
                      isSeachHistory = false;
                    });
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
                        popularTrackHistory: popularTrackHistory,
                        
                        
                        onTap: (String searchHistory) async {
                          await searchProv.searchTrack(searchHistory,0);
                          _searchController.text = searchHistory;
                          searchModel.searchText = _searchController.text;
                          setState(() {
                            isSearchMain = false;
                            isSeachHistory = false;
                          });
                        },
                      )
                    : isSeachHistory
                        ? SearchFindScreen(
                            searchHistoryModel: searchHistoryModel,
                            onTap: (String searchHistory) async {
                              await searchProv.searchTrack(searchHistory,0);
                              _searchController.text = searchHistory;
                              searchModel.searchText = _searchController.text;
                              setState(() {
                                isSearchMain = false;
                                isSeachHistory = false;
                              });
                            },
                          )
                        : SearchResultScreen(
                            
                            
                            searchModel: searchModel)),
          ],
        ),
      ),
    );
  }
}
