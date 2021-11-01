import 'package:driver/assets/AppColors.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/LoadDescriptionModel.dart';
import 'package:driver/model/PortModel.dart';
import 'package:driver/model/SteamshipLineModel.dart';
import 'package:driver/model/VesselModel.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SelectLoadDescriptionPage extends StatefulWidget{
  @override
  State<SelectLoadDescriptionPage> createState() => _SelectLoadDescriptionPageState();
}

class _SelectLoadDescriptionPageState extends State<SelectLoadDescriptionPage> {

  TextEditingController edtSearch = new TextEditingController();

  List<LoadDescriptionModel> searchList = [];

  bool isSearchPort = false;
  late final ProgressDialog progressDialog;

  String displayPort(PortModel model) => model.name;
  int selectedIndex = -1;
  List<String> sortList = [Constants.A_TO_Z, Constants.Z_TO_A];
  String sortKey = Constants.A_TO_Z;
  String sortedName = '';

  @override
  void initState() {
    super.initState();

    progressDialog = ProgressDialog(context);
    progressDialog.style(progressWidget: Container(padding: EdgeInsets.all(13), child: CircularProgressIndicator(color: AppColors.lightBlue)));

    searchList.addAll(Utils.sortData(Common.loadDescriptionList, sortKey) as List<LoadDescriptionModel>);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.darkBlue,
          title: Text('Select Vessel'),
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
                    searchList.addAll(Utils.sortData(Common.loadDescriptionList, sortKey) as List<LoadDescriptionModel>);
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 30),
                  width: double.infinity,
                  child: TextField(
                    controller: edtSearch,
                    onChanged: (text) {
                      searchList.clear();
                      Common.loadDescriptionList.forEach((element) {
                        if (element.name.toLowerCase().contains(edtSearch.text.toLowerCase())){
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
                        searchList.addAll(Utils.sortData(Common.loadDescriptionList, sortKey) as List<LoadDescriptionModel>);
                        edtSearch.text = '';
                        setState(() {});
                      },
                      icon: Icon(Icons.cancel, color: Colors.black26,),
                    ),
                    filled: true,
                    hintText: 'Search',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.transparent),
                    )
                  ),
              ),
                ),
            SizedBox(height: 30),
            Row(
              children: [
                SizedBox(width: 22),
                Icon(Icons.apartment, color: AppColors.lightBlue),
                SizedBox(width: 10),
                Text('Vessel list', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                child: Stack(
                    children: [
                      Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                      Container(color: AppColors.lightBlue, width: 30, height: 3)])),
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
                        title: Text(searchList[index].name),
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
      ),
    );
  }
  showProgress(){
    if (!progressDialog.isShowing()){
      progressDialog.show();
    }
  }

  closeProgress(){
    if (progressDialog.isShowing()){
      progressDialog.hide();
    }
  }
}