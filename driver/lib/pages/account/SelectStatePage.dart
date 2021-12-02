import 'package:driver/assets/AppColors.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/utils/Utils.dart';
import 'package:flutter/material.dart';

class SelectStatePage extends StatefulWidget{
  @override
  State<SelectStatePage> createState() => _SelectStatePageState();
}

class _SelectStatePageState extends State<SelectStatePage> {
  List<String> searchList = [];
  List<String> sortList = [Constants.A_TO_Z, Constants.Z_TO_A];
  TextEditingController edtSearch = new TextEditingController();
  int selectedIndex = -1;
  String sortKey = Constants.A_TO_Z;

  @override
  void initState() {
    super.initState();
    searchList.addAll(Utils.sortData(Constants.stateList, sortKey) as List<String>);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 1,
        title: Text('Select State'),
          actions: [
            Center(child: Text(sortKey)),
            Center(
              child: DropdownButton(
                  value: sortKey,
                  icon: Icon(Icons.sort, color: Colors.white),
                  iconSize: 24,
                  underline: Container(),
                  onChanged: (value) {
                    sortKey = value as String;
                    searchList.clear();
                    searchList.addAll(Utils.sortData(Constants.stateList, sortKey) as List<String>);
                    setState(() {});},
                  items: sortList.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(child: Text(value, style: TextStyle(fontSize: 15)), value: value);
                  }).toList(),
                  selectedItemBuilder: (context) {
                    return sortList.map<Widget>((item) {
                      return Container(alignment: Alignment.center, child: Text(item, textAlign: TextAlign.center, style: TextStyle(fontSize: 15)));
                    }).toList();}),
            ),
            SizedBox(width: 10)
          ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 30),
            width: double.infinity,
            child: TextField(
              controller: edtSearch,
              onChanged: (text) {
                searchList.clear();
                Constants.stateList.forEach((element) {
                  if (element.toLowerCase().contains(edtSearch.text.toLowerCase())){
                    searchList.add(element);
                  }
                });
                setState(() {});
                },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.black38, size: 20),
                  suffixIcon: IconButton(
                    onPressed: (){
                      searchList.clear();
                      searchList.addAll(Utils.sortData(Constants.stateList, sortKey) as List<String>);
                      edtSearch.text = '';
                      setState(() {});
                      },
                    icon: Icon(Icons.cancel, color: Colors.black26,),),
                  filled: true,
                  hintText: 'Search',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.transparent)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.transparent),
                  )),),),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        selectedIndex = index;
                        Navigator.pop(context, searchList[selectedIndex]);
                      },
                      leading: Icon(Icons.location_on_outlined),
                      title: Text(searchList[index]),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: searchList.length),
            ),
          )
        ],
      ),
    );
  }
}